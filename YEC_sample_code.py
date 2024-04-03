# AJPS (2015) Estimating the effect of Germany reunification on economic growth 
# rolling-origin cross valiation : fixed valid-period  

import pandas as pd 
import numpy as np
import cvxpy as cvx

from scipy.optimize import minimize
from matplotlib import pyplot as plt 
from sklearn.model_selection import train_test_split
from sklearn import datasets
from sklearn import svm 

from itertools import product 
from collections import Counter


class optimize(object):

    class quadprog(object):
                
        def __init__(self):
            pass
            # call solver
            # self.result = self.solver()

        def objective_function(self, x, H, f):
            x = x[:,np.newaxis]
            cost = 0.5*x.T @ H @ x + f @ x
            
            return cost.flatten()

        def solver(self,H,f,A,b,x0,bnds):
            cons = ({'type': 'ineq', 'fun': lambda x: b - np.dot(A, x)})
            
            optimum = minimize(self.objective_function,
                                        x0          = x0,
                                        args        = (H,f), 
                                        bounds      = bnds,
                                        constraints = cons)

            return optimum.x

    def __init__(self, v20, X1, X0, Z1, Z0):
        self.v20    = v20
        self.X1     = X1
        self.X0     = X0
        self.Z1     = Z1
        self.Z0     = Z0
        self.v2_opt = []
        self.optimum = []

        self.bnds   = (((0,np.inf),) * X1.shape[0])
        # self.cons   = ({'type': 'ineq', 'fun': lambda x: )})

        # self.lb = np.zeros((I,1))
        # self.ub = np.ones((I,1))

        self.qp     = self.quadprog()

    def loss_fun(self,v2):

        b = np.vstack((1,v2[1:,np.newaxis]))
        a = np.zeros((b.shape[0],b.shape[0]))
        np.fill_diagonal(a,b)

        # construct the problem - constrain weights to be non-negative
        w = cvx.Variable((self.X0.shape[1],1),nonneg=True)

        # define the objective
        obj = cvx.Minimize(cvx.sum(a @ cvx.square(self.X1 - self.X0 @ w)))

        # add constraint sum of weights must equal one
        constraints = [cvx.sum(w) == 1]

        # solve problem
        problem = cvx.Problem(obj,constraints)
        
       
        result = problem.solve(verbose=False)
       
        w = w.value
        loss = (self.Z1 - self.Z0 @ w).T @ (self.Z1 - self.Z0 @ w)

        # loss = (self.Z1 - self.Z0 @ w.value).T @ (self.Z1 - self.Z0 @ w.value)
        
        return np.squeeze(loss) # in order to make lower (minimal) dimension: 2 -> 1

    def recover_weight(self):
        b = self.v2_opt #np.vstack((1,self.v2_opt[:,np.newaxis]))
        a = np.zeros((b.shape[0],b.shape[0]))
        np.fill_diagonal(a,b)
        D = a
        H = self.X0.T @ D @ self.X0
        f = -self.X1.T @ D @ self.X0 
        I = self.X0.shape[1]
        Aeq = np.ones((1,I)) 
        Beq = 1 

        x0   = np.zeros((I,1))
        bnds = tuple((0,1) for _ in range(I))

        w = self.qp.solver(H,f,Aeq,Beq,x0,bnds)
        w = abs(w)

        return w

    def solver(self):
        self.optimum = minimize(self.loss_fun, 
                            x0     = np.vstack((1,self.v20)), 
                            method = 'L-BFGS-B', 
                            bounds = self.bnds,
                            options={'gtol': 1e-6, 'disp': False})

        self.v2_opt = self.optimum.x
        

if __name__ == "__main__":

     #--------------------------------------------------------------------------------------#
    # import data as data frame 
    data = pd.read_csv("/Users/stellachoi/Documents/GitHub/scm/empiric_datasets/german.csv")
    data = data.drop(columns = "code", axis = 1)
    outcome_var = "gdp"
    id_var = "country"
    time_var = "year"
    treat_period = 1990 
    treated_unit = "West Germany"
    
    
    covariates = [col for col in data.columns if col not in [id_var,time_var]]

    period_all = data[time_var].nunique()
    pre_period = data.loc[data[time_var] < treat_period][time_var].nunique()
    
    split_point = int(0.7 * pre_period)
    valid_point = pre_period - split_point 
    train_year = data[time_var][0] + split_point - 1

    mspe_all = []
    
    t = split_point
        
    treat_year = data[time_var][0] + t - 1
    n_controls = data[id_var].nunique() - 1 # remove one treated unit
    n_covariates = len(covariates)

    # get treated and control outcome 
    treated_data = data.loc[data[id_var] == treated_unit]
    treated_outcome_all = np.array(treated_data[outcome_var])[:,np.newaxis]

    pretreated_data = treated_data.loc[data[time_var] < treat_period]
    pre_treated_outcome = np.array(pretreated_data[outcome_var]).reshape(pre_period,1)
    
    Z1_train = pre_treated_outcome[:t,:]
    Z1_valid = pre_treated_outcome[t+1:t+valid_point,:]

    control_data = data.loc[data[id_var] != treated_unit]
    control_outcome_all = np.array(control_data[outcome_var]).reshape(n_controls, period_all).T #All outcomes

    precontrol_data = control_data.loc[data[time_var] < treat_period]
    pre_control_outcome = np.array(precontrol_data[outcome_var]).reshape(n_controls,pre_period).T # time x control units 
    
    Z0_train = pre_control_outcome[:t,:]
    Z0_valid = pre_control_outcome[t+1:t+valid_point,:]


    trainingTreatData = treated_data.loc[data[time_var] <= treat_period] # treat_year
    X1_train = np.array(trainingTreatData[covariates].mean(axis=0))[:,np.newaxis]
        
    trainingControlData = control_data[data[time_var] <= treat_period] # treat_year
    X0_train = np.array(trainingControlData[covariates].set_index(np.arange(len(trainingControlData[covariates])) \
                        // t).mean(level=0)).T # k variables x j units 


    Y0 = control_outcome_all.T
    Y1 = treated_outcome_all
    mspe = []
    k = n_covariates
    m = 2 ** n_covariates - 1 
    im = product((0,1), repeat = n_covariates)
    im = np.array(list(im))
    im = im[1:,:]
    imSize = im.shape[0]
    # np.savetxt("/Users/stellachoi/Documents/GitHub/scm/ajps/1219/ajps_modelSize.csv",im,delimiter=",")#, fmt='%1.8f')
    alphaAll = []    
    diffAll = []

    
    for i in range(imSize):
        print(i)
        
        idx = []
        for k in range(im.shape[1]):
            if im[i,k]:
                idx.append(k)
                
        xs0 = X0_train[idx,:] 
        xs1 = X1_train[idx,:]       
    
        # Normalization 
        bigdata = np.hstack((xs1, xs0)).T
        divisor = bigdata.std(0)[np.newaxis,:]
        c = np.zeros((bigdata.shape[1],bigdata.shape[1]))
        np.fill_diagonal(c,1)
        scamatirx = (bigdata @ (np.divide(1, divisor) * c)).T 
        xs0 = np.array(scamatirx[:,:-1]) 
        xs1 = np.array(scamatirx[:,-1][:,np.newaxis]) 

        # Implement optimization 
        s = np.hstack((xs1,xs0)).T 
        s = s.std(0)[:, np.newaxis] # row st.dev 
        s2 = s[1:,:]
        s1 = s[0][:,np.newaxis]
        v20 = np.divide(s1,s2)**2
        
        # boundary condition
        bnds = np.zeros((xs1.shape))
        
        try:

            # take optimization 
            opt = optimize(v20,xs1,xs0,Z1_train,Z0_train)
            opt.solver()

            w = opt.recover_weight()
            w /= np.sum(w)

            yhat = Z0_valid @ w[:,np.newaxis]
            alpha =  Z1_valid - yhat 
            mspe_pre = np.sqrt(np.mean(alpha ** 2,axis=0))

            Yhat = Y0.T @ w[:,np.newaxis]
            diff = Y1 - Yhat
            
            figure, ax = plt.subplots(figsize=(8,6))
            Yhat = Y0.T @ w[:,np.newaxis]
            years = np.arange(1960,2004,1)
            line1 = plt.plot(years,Y1,'.-', label ='West Germany')
            line2 = plt.plot(years,Yhat,'--',label = 'Synthetic West Germany')
            plt.legend()
            # plt.axis([1960, 2004, 0, 100])
            plt.axvline(treat_period,linestyle=':',color='green')
            plt.xlabel('year')
            plt.ylabel('per Capita GDP')
            plt.tight_layout()
            plt.savefig("/Users/stellachoi/Documents/GitHub/scm/ajps/1219/ajps_model_70_" + str(i) + ".png", format="PNG")
            figure.canvas.draw()       # drawing updated values
        
    
        
        except:
            mspe_pre = np.NaN
            diff = np.NaN
    else: 
        pass    
    
    mspe.append(mspe_pre)
    diffAll.append(diff)
    
    # diffAll = np.array((diffAll))
    # diffAll = np.reshape(diffAll,(diffAll.shape[0],diffAll.shape[1]*diffAll.shape[2]))
        
    # np.savetxt("/Users/stellachoi/Documents/GitHub/scm/ajps/1219/diffAll.csv",diffAll,delimiter=",")#, fmt='%1.8f')            
    np.savetxt("/Users/stellachoi/Documents/GitHub/scm/ajps/1219/ajps_mspe.csv",mspe,delimiter=",")#, fmt='%1.8f')
    
        