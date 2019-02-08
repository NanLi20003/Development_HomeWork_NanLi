%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HW2Q2.m

% Basic function:
% Calculate the welfare gain in different conditions

%% set environment
close all
clear all
rng(1234)

%% Parameters Specification 
etaArray = [1 2 4];
beta = 0.99;
dSeason = [0.863 0.727 0.932
           0.691 0.381 0.845
           1.151 1.303 1.076
           1.140 1.280 1.070
           1.094 1.188 1.047
           1.060 1.119 1.030
           1.037 1.073 1.018
           1.037 1.073 1.018
           1.037 1.073 1.018
           1.002 1.004 1.001
           0.968 0.935 0.984
           0.921 0.843 0.961]; % Determinstic seasonal component
sigmaU  = 0.2; %
sigmaE  = 0.2; %
sSeason = [0.085 0.171 0.043
          0.068 0.137 0.034
          0.290 0.580 0.145
          0.283 0.567 0.142
          0.273 0.546 0.137
          0.273 0.546 0.137
          0.239 0.478 0.119
          0.205 0.410 0.102
          0.188 0.376 0.094
          0.188 0.376 0.094
          0.171 0.341 0.085
          0.137 0.273 0.068];
  
  nHousehold = 1000; % number of household
  nYear = 40; % each household live 40 year
  nMonth = 12; % number of months

  v = 1; 

 %Calibration  of kappa
 theta = 0.66;
 yc = 1/0.5;
 hm = 28.5*(30/7);

 kappa = (theta*yc)*(1/(hm^2));

  %% define the peranent level of consumption
  uArray = lognrnd(0, sqrt(sigmaU),nHousehold,1);
  zArray = uArray.*exp(-sigmaU/2);
  
  zMatrix = zeros(nHousehold,nYear,nMonth);
  for h = 1:nHousehold
      zMatrix(h,:,:) = zArray(h,1);
  end
  % 1000*1 matrix to specify the permanent level of consumption, which is
  % unique for each household.
  
  %% define the deterministic seasonal component 
  dSeasonCom = dSeason;
  % 12*3 matrix  month*three conditions
  % to measure the seasonal component follows the deterministic process. 
  
  hSeasonMatrix =  zeros(nHousehold,nYear,nMonth);
  mSeasonMatrix =  zeros(nHousehold,nYear,nMonth);
  lSeasonMatrix =  zeros(nHousehold,nYear,nMonth);
  
  for m = 1:nMonth
      hSeasonMatrix(:,:,m) = dSeasonCom(m,2);
      mSeasonMatrix(:,:,m) = dSeasonCom(m,1);
      lSeasonMatrix(:,:,m) = dSeasonCom(m,3);
  end
  
    
  %% define the Stochastic Seasonal Component 
  hsSeasonMatrix = zeros(nHousehold,nYear,nMonth);
  msSeasonMatrix = zeros(nHousehold,nYear,nMonth);
  lsSeasonMatrix = zeros(nHousehold,nYear,nMonth);
  for h = 1:nHousehold
      for m = 1:nMonth
         epsilonM = sSeason(m,1);
         epsilonH = sSeason(m,2);
         epsilonL = sSeason(m,3);
         msSeasonMatrix(h,:,m)= lognrnd(0,sqrt(epsilonM))*exp(-epsilonM/2);
         hsSeasonMatrix(h,:,m)= lognrnd(0,sqrt(epsilonH))*exp(-epsilonH/2);
         lsSeasonMatrix(h,:,m)= lognrnd(0,sqrt(epsilonL))*exp(-epsilonL/2);      
      end    
  end    
  
  %% define the nonseasonal stochastic component
  eYMatrix = zeros(nHousehold,nYear,nMonth);
  for h = 1:nHousehold
      for y = 1:nYear
          eYMatrix(h,y,:)=lognrnd(0, sqrt(sigmaE))*exp(-sigmaE/2);
      end    
  end    
  
  %% calculate consumption
  nonSeasonC = zMatrix.*eYMatrix;
  mmSeasonC = zMatrix.*eYMatrix.*mSeasonMatrix.*msSeasonMatrix;
  mhSeasonC = zMatrix.*eYMatrix.*mSeasonMatrix.*hsSeasonMatrix;
  mlSeasonC = zMatrix.*eYMatrix.*mSeasonMatrix.*lsSeasonMatrix;
  hmSeasonC = zMatrix.*eYMatrix.*hSeasonMatrix.*msSeasonMatrix;
  hhSeasonC = zMatrix.*eYMatrix.*hSeasonMatrix.*hsSeasonMatrix;
  hlSeasonC = zMatrix.*eYMatrix.*hSeasonMatrix.*lsSeasonMatrix;
  lmSeasonC = zMatrix.*eYMatrix.*lSeasonMatrix.*msSeasonMatrix;
  lhSeasonC = zMatrix.*eYMatrix.*lSeasonMatrix.*hsSeasonMatrix;
  llSeasonC = zMatrix.*eYMatrix.*lSeasonMatrix.*lsSeasonMatrix;
    
%% define the peranent level of labor
  luArray = lognrnd(0, sqrt(sigmaU),nHousehold,1);
  lzArray = luArray.*exp(-sigmaU/2);
  
  lzMatrix = zeros(nHousehold,nYear,nMonth);
  for h = 1:nHousehold
      lzMatrix(h,:,:) = lzArray(h,1);
  end
  % 1000*1 matrix to specify the permanent level of consumption, which is
  % unique for each household.
  
 %% nonseasonal stochastic component of labor
 leYMatrix = zeros(nHousehold,nYear,nMonth); % if it not correlated with consumption
  for h = 1:nHousehold
      for y = 1:nYear
          leYMatrix(h,y,:)=lognrnd(0, sqrt(sigmaE))*exp(-sigmaE/2);
      end    
  end    
 
lpYMatrix = eYMatrix; % if it is highly correlated with consumption
    

%% Q2.1: highly positive correlated
lphSeasonMatrix = hSeasonMatrix;
lpmSeasonMatrix = mSeasonMatrix;
lplSeasonMatrix = lSeasonMatrix;
lphsSeasonMatrix = hsSeasonMatrix;
lpmsSeasonMatrix = msSeasonMatrix;
lplsSeasonMatrix = lsSeasonMatrix;


 %% calculate labor
 nonSeasonL = lzMatrix.*leYMatrix*hm;
 mmSeasonL = lzMatrix.*leYMatrix.*lpmSeasonMatrix.*lpmsSeasonMatrix*hm;
 mhSeasonL = lzMatrix.*leYMatrix.*lpmSeasonMatrix.*lphsSeasonMatrix*hm;
 mlSeasonL = lzMatrix.*leYMatrix.*lpmSeasonMatrix.*lplsSeasonMatrix*hm;
 hmSeasonL = lzMatrix.*leYMatrix.*lphSeasonMatrix.*lpmsSeasonMatrix*hm;
 hhSeasonL = lzMatrix.*leYMatrix.*lphSeasonMatrix.*lphsSeasonMatrix*hm;
 hlSeasonL = lzMatrix.*leYMatrix.*lphSeasonMatrix.*lplsSeasonMatrix*hm;
 lmSeasonL = lzMatrix.*leYMatrix.*lplSeasonMatrix.*lpmsSeasonMatrix*hm;
 lhSeasonL = lzMatrix.*leYMatrix.*lplSeasonMatrix.*lphsSeasonMatrix*hm;
 llSeasonL = lzMatrix.*leYMatrix.*lplSeasonMatrix.*lplsSeasonMatrix*hm;
 
 %% calculate the utility
 uNonSeason = utilityl(nonSeasonC,nonSeasonL,kappa);
 
 ummNonSeasonL = utilityl(mmSeasonC,nonSeasonL,kappa); % remove seasonality of labor
 umhNonSeasonL = utilityl(mhSeasonC,nonSeasonL,kappa);
 umlNonSeasonL = utilityl(mlSeasonC,nonSeasonL,kappa);
 uhmNonSeasonL = utilityl(hmSeasonC,nonSeasonL,kappa);
 uhhNonSeasonL = utilityl(hhSeasonC,nonSeasonL,kappa);
 uhlNonSeasonL = utilityl(hlSeasonC,nonSeasonL,kappa);
 ulmNonSeasonL = utilityl(lmSeasonC,nonSeasonL,kappa);
 ulhNonSeasonL = utilityl(lhSeasonC,nonSeasonL,kappa);
 ullNonSeasonL = utilityl(llSeasonC,nonSeasonL,kappa);
 
 ummNonSeasonC = utilityl(mmSeasonL,nonSeasonC,kappa); % remove seasonality of labor
 umhNonSeasonC = utilityl(mhSeasonL,nonSeasonC,kappa);
 umlNonSeasonC = utilityl(mlSeasonL,nonSeasonC,kappa);
 uhmNonSeasonC = utilityl(hmSeasonL,nonSeasonC,kappa);
 uhhNonSeasonC = utilityl(hhSeasonL,nonSeasonC,kappa);
 uhlNonSeasonC = utilityl(hlSeasonL,nonSeasonC,kappa);
 ulmNonSeasonC = utilityl(lmSeasonL,nonSeasonC,kappa);
 ulhNonSeasonC = utilityl(lhSeasonL,nonSeasonC,kappa);
 ullNonSeasonC = utilityl(llSeasonL,nonSeasonC,kappa);
 
 
 ummSeasonConL = utilityl(mmSeasonC,mmSeasonL,kappa);
 umhSeasonConL = utilityl(mhSeasonC,mhSeasonL,kappa);
 umlSeasonConL = utilityl(mlSeasonC,mlSeasonL,kappa);
 uhmSeasonConL = utilityl(hmSeasonC,hmSeasonL,kappa);
 uhhSeasonConL = utilityl(hhSeasonC,hhSeasonL,kappa);
 uhlSeasonConL = utilityl(hlSeasonC,hlSeasonL,kappa);
 ulmSeasonConL = utilityl(lmSeasonC,lmSeasonL,kappa);
 ulhSeasonConL = utilityl(lhSeasonC,lhSeasonL,kappa);
 ullSeasonConL = utilityl(llSeasonC,llSeasonL,kappa);
 
 
 
 %% calculate welfare
 wNonSeason = welfare(uNonSeason);
 
 wmmNonSeasonL = welfare(ummNonSeasonL);
 wmhNonSeasonL = welfare(umhNonSeasonL);
 wmlNonSeasonL = welfare(umlNonSeasonL);
 whmNonSeasonL = welfare(uhmNonSeasonL);
 whhNonSeasonL = welfare(uhhNonSeasonL);
 whlNonSeasonL = welfare(uhlNonSeasonL);
 wlmNonSeasonL = welfare(ulmNonSeasonL);
 wlhNonSeasonL = welfare(ulhNonSeasonL);
 wllNonSeasonL = welfare(ullNonSeasonL);
 
 wmmNonSeasonC = welfare(ummNonSeasonC);
 wmhNonSeasonC = welfare(umhNonSeasonC);
 wmlNonSeasonC = welfare(umlNonSeasonC);
 whmNonSeasonC = welfare(uhmNonSeasonC);
 whhNonSeasonC = welfare(uhhNonSeasonC);
 whlNonSeasonC = welfare(uhlNonSeasonC);
 wlmNonSeasonC = welfare(ulmNonSeasonC);
 wlhNonSeasonC = welfare(ulhNonSeasonC);
 wllNonSeasonC = welfare(ullNonSeasonC);
 
 
 
 wmmSeasonConL = welfare(ummSeasonConL);
 wmhSeasonConL = welfare(umhSeasonConL);
 wmlSeasonConL = welfare(umlSeasonConL);
 whmSeasonConL = welfare(uhmSeasonConL);
 whhSeasonConL = welfare(uhhSeasonConL);
 whlSeasonConL = welfare(uhlSeasonConL);
 wlmSeasonConL = welfare(ulmSeasonConL);
 wlhSeasonConL = welfare(ulhSeasonConL);
 wllSeasonConL = welfare(ullSeasonConL);
 
 %% calculate the gain
 gmml = gain(wmmNonSeasonL,wNonSeason,beta,1); % consumption
 gmmc = gain(wmmSeasonConL,wmmNonSeasonL,beta,1); % labor
 gmmt = gain(wmmSeasonConL,wNonSeason,beta,1);
 
 gmhl = gain(wmhNonSeasonL,wNonSeason,beta,1);
 gmhc = gain(wmhSeasonConL,wmhNonSeasonL,beta,1);
 gmht = gain(wmhSeasonConL,wNonSeason,beta,1);
 
 gmll = gain(wmlNonSeasonL,wNonSeason,beta,1);
 gmlc = gain(wmlSeasonConL,wmlNonSeasonL,beta,1);
 gmlt = gain(wmlSeasonConL,wNonSeason,beta,1);
 
 ghml = gain(whmNonSeasonL,wNonSeason,beta,1);
 ghmc = gain(whmSeasonConL,whmNonSeasonL,beta,1);
 ghmt = gain(whmSeasonConL,wNonSeason,beta,1);
 
 ghhl = gain(whhNonSeasonL,wNonSeason,beta,1);
 ghhc = gain(whhSeasonConL,whhNonSeasonL,beta,1);
 ghht = gain(whhSeasonConL,wNonSeason,beta,1);
 
 ghll = gain(whlNonSeasonL,wNonSeason,beta,1);
 ghlc = gain(whlSeasonConL,whlNonSeasonL,beta,1);
 ghlt = gain(whlSeasonConL,wNonSeason,beta,1);
 
 glml = gain(wlmNonSeasonL,wNonSeason,beta,1);
 glmc = gain(wlmSeasonConL,wlmNonSeasonL,beta,1);
 glmt = gain(wlmSeasonConL,wNonSeason,beta,1);
 
 glhl = gain(wlhNonSeasonL,wNonSeason,beta,1);
 glhc = gain(wlhSeasonConL,wlhNonSeasonL,beta,1);
 glht = gain(wlhSeasonConL,wNonSeason,beta,1);
 
 glll = gain(wllNonSeasonL,wNonSeason,beta,1);
 gllc = gain(wllSeasonConL,wllNonSeasonL,beta,1);
 gllt = gain(wllSeasonConL,wNonSeason,beta,1);

 medianMatrix = [median(gmml) median(gmmc) median(gmmt);
               median(gmhl) median(gmhc) median(gmht);
               median(gmll) median(gmlc) median(gmlt);
               median(ghml) median(ghmc) median(ghmt);
               median(ghhl) median(ghhc) median(ghht);
               median(ghll) median(ghlc) median(ghlt);
               median(glml) median(glmc) median(glmt);
               median(glhl) median(glhc) median(glht);
               median(glll) median(gllc) median(gllt)]
 
 gmml2 = gain(wmmNonSeasonC,wNonSeason,beta,1); % consumption
 gmmc2 = gain(wmmSeasonConL,wmmNonSeasonC,beta,1); % labor
 gmmt = gain(wmmSeasonConL,wNonSeason,beta,1);
 
 gmhl2 = gain(wmhNonSeasonC,wNonSeason,beta,1);
 gmhc2 = gain(wmhSeasonConL,wmhNonSeasonC,beta,1);
 gmht = gain(wmhSeasonConL,wNonSeason,beta,1);
 
 gmll2 = gain(wmlNonSeasonC,wNonSeason,beta,1);
 gmlc2 = gain(wmlSeasonConL,wmlNonSeasonC,beta,1);
 gmlt = gain(wmlSeasonConL,wNonSeason,beta,1);
 
 ghml2 = gain(whmNonSeasonC,wNonSeason,beta,1);
 ghmc2 = gain(whmSeasonConL,whmNonSeasonC,beta,1);
 ghmt = gain(whmSeasonConL,wNonSeason,beta,1);
 
 ghhl2 = gain(whhNonSeasonC,wNonSeason,beta,1);
 ghhc2 = gain(whhSeasonConL,whhNonSeasonC,beta,1);
 ghht = gain(whhSeasonConL,wNonSeason,beta,1);
 
 ghll2 = gain(whlNonSeasonC,wNonSeason,beta,1);
 ghlc2 = gain(whlSeasonConL,whlNonSeasonC,beta,1);
 ghlt = gain(whlSeasonConL,wNonSeason,beta,1);
 
 glml2 = gain(wlmNonSeasonC,wNonSeason,beta,1);
 glmc2 = gain(wlmSeasonConL,wlmNonSeasonC,beta,1);
 glmt = gain(wlmSeasonConL,wNonSeason,beta,1);
 
 glhl2 = gain(wlhNonSeasonC,wNonSeason,beta,1);
 glhc2 = gain(wlhSeasonConL,wlhNonSeasonC,beta,1);
 glht = gain(wlhSeasonConL,wNonSeason,beta,1);
 
 glll2 = gain(wllNonSeasonC,wNonSeason,beta,1);
 gllc2 = gain(wllSeasonConL,wllNonSeasonC,beta,1);
 gllt = gain(wllSeasonConL,wNonSeason,beta,1);

 medianMatrix2 = [median(gmml2) median(gmmc2) median(gmmt);
               median(gmhl2) median(gmhc2) median(gmht);
               median(gmll2) median(gmlc2) median(gmlt);
               median(ghml2) median(ghmc2) median(ghmt);
               median(ghhl2) median(ghhc2) median(ghht);
               median(ghll2) median(ghlc2) median(ghlt);
               median(glml2) median(glmc2) median(glmt);
               median(glhl2) median(glhc2) median(glht);
               median(glll2) median(gllc2) median(gllt)]
 
 
 
 %% Q2.2: highly negative correlated
% determistic part
lphSeasonMatrix = hSeasonMatrix;
lpmSeasonMatrix = mSeasonMatrix;
lplSeasonMatrix = lSeasonMatrix;

% stochastic part
 %% define the Stochastic Seasonal Component 
  lnhsSeasonMatrix = zeros(nHousehold,nYear,nMonth);
  lnmsSeasonMatrix = zeros(nHousehold,nYear,nMonth);
  lnlsSeasonMatrix = zeros(nHousehold,nYear,nMonth);
  
  for h = 1:nHousehold
      for m = 1:nMonth
         epsilonM = sSeason(m,1);
         epsilonH = sSeason(m,2);
         epsilonL = sSeason(m,3);
         lnmsSeasonMatrix(h,:,m)=  (msSeasonMatrix(h,:,m)./exp(-epsilonM/2)).^(-1).*exp(-epsilonM/2);
         lnhsSeasonMatrix(h,:,m)=  (hsSeasonMatrix(h,:,m)./exp(-epsilonH/2)).^(-1).*exp(-epsilonH/2);
         lnlsSeasonMatrix(h,:,m)=  (lsSeasonMatrix(h,:,m)./exp(-epsilonL/2)).^(-1).*exp(-epsilonL/2);
      end    
  end    


 %% calculate labor
 mmSeasonLN = lzMatrix.*leYMatrix.*lnmSeasonMatrix.*lnmsSeasonMatrix*hm;
 mhSeasonLN = lzMatrix.*leYMatrix.*lnmSeasonMatrix.*lnhsSeasonMatrix*hm;
 mlSeasonLN = lzMatrix.*leYMatrix.*lnmSeasonMatrix.*lnlsSeasonMatrix*hm;
 hmSeasonLN = lzMatrix.*leYMatrix.*lnhSeasonMatrix.*lnmsSeasonMatrix*hm;
 hhSeasonLN = lzMatrix.*leYMatrix.*lnhSeasonMatrix.*lnhsSeasonMatrix*hm;
 hlSeasonLN = lzMatrix.*leYMatrix.*lnhSeasonMatrix.*lnlsSeasonMatrix*hm;
 lmSeasonLN = lzMatrix.*leYMatrix.*lnlSeasonMatrix.*lnmsSeasonMatrix*hm;
 lhSeasonLN = lzMatrix.*leYMatrix.*lnlSeasonMatrix.*lnhsSeasonMatrix*hm;
 llSeasonLN = lzMatrix.*leYMatrix.*lnlSeasonMatrix.*lnlsSeasonMatrix*hm;
 
 %% calculate the utility
 ummSeasonConLN = utilityl(mmSeasonC,mmSeasonLN,kappa);
 umhSeasonConLN = utilityl(mhSeasonC,mhSeasonLN,kappa);
 umlSeasonConLN = utilityl(mlSeasonC,mlSeasonLN,kappa);
 uhmSeasonConLN = utilityl(hmSeasonC,hmSeasonLN,kappa);
 uhhSeasonConLN = utilityl(hhSeasonC,hhSeasonLN,kappa);
 uhlSeasonConLN = utilityl(hlSeasonC,hlSeasonLN,kappa);
 ulmSeasonConLN = utilityl(lmSeasonC,lmSeasonLN,kappa);
 ulhSeasonConLN = utilityl(lhSeasonC,lhSeasonLN,kappa);
 ullSeasonConLN = utilityl(llSeasonC,llSeasonLN,kappa);
 
 
 %% calculate welfare 
 wmmSeasonConLN = welfare(ummSeasonConLN);
 wmhSeasonConLN = welfare(umhSeasonConLN);
 wmlSeasonConLN = welfare(umlSeasonConLN);
 whmSeasonConLN = welfare(uhmSeasonConLN);
 whhSeasonConLN = welfare(uhhSeasonConLN);
 whlSeasonConLN = welfare(uhlSeasonConLN);
 wlmSeasonConLN = welfare(ulmSeasonConLN);
 wlhSeasonConLN = welfare(ulhSeasonConLN);
 wllSeasonConLN = welfare(ullSeasonConLN);
 
 %% calculate the gain
 
 gmmcN = gain(wmmSeasonConLN,wmmNonSeasonL,beta,1);
 gmhcN = gain(wmhSeasonConLN,wmhNonSeasonL,beta,1);
 gmlcN = gain(wmlSeasonConLN,wmlNonSeasonL,beta,1);
 ghmcN = gain(whmSeasonConLN,whmNonSeasonL,beta,1);
 ghhcN = gain(whhSeasonConLN,whhNonSeasonL,beta,1);
 ghlcN = gain(whlSeasonConLN,whlNonSeasonL,beta,1);
 glmcN = gain(wlmSeasonConLN,wlmNonSeasonL,beta,1);
 glhcN = gain(wlhSeasonConLN,wlhNonSeasonL,beta,1);
 gllcN = gain(wllSeasonConLN,wllNonSeasonL,beta,1);
 
 gmmtN = gain(wmmSeasonConLN,wNonSeason,beta,1)
 gmhtN = gain(wmhSeasonConLN,wNonSeason,beta,1)
 gmltN = gain(wmlSeasonConLN,wNonSeason,beta,1)
 ghmtN = gain(whmSeasonConLN,wNonSeason,beta,1)
 ghhtN = gain(whhSeasonConLN,wNonSeason,beta,1)
 ghltN = gain(whlSeasonConLN,wNonSeason,beta,1)
 glmtN = gain(wlmSeasonConLN,wNonSeason,beta,1)
 glhtN = gain(wlhSeasonConLN,wNonSeason,beta,1)
 glltN = gain(wllSeasonConLN,wNonSeason,beta,1)
 
 medianMatrix3 = [median(gmml) median(gmmcN) median(gmmtN);
               median(gmhl) median(gmhcN) median(gmhtN);
               median(gmll) median(gmlcN) median(gmltN);
               median(ghml) median(ghmcN) median(ghmtN);
               median(ghhl) median(ghhcN) median(ghhtN);
               median(ghll) median(ghlcN) median(ghltN);
               median(glml) median(glmcN) median(glmtN);
               median(glhl) median(glhcN) median(glhtN);
               median(glll) median(gllcN) median(glltN)]
 
 