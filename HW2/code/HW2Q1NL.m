%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HW2Q1.m

% Basic function:
% Calculate the welfare gain in different conditions to solve the first
% question.

%% set environment
close all
clear all
rng(1234)

%% Parameters Specification 
% 1)   
% 2)
% 3)
% 4)
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
  epsilonYMatrix = zeros(nHousehold,nYear,nMonth);
  for h = 1:nHousehold
      for y = 1:nYear
          epsilonYMatrix(h,y,:)=lognrnd(0, sqrt(sigmaE))*exp(-sigmaE/2);
      end    
  end    
  
  %% calculate consumption
  %In different conditions, we just use the needed parameters, and times
  %them together to get the consumption
 
  %% calculate utility
  
  %% get the total welfare
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% Q1£º
 %% calculcate the welfare with only nonseasonal risk
 cNonseason = zMatrix.*epsilonYMatrix;
 uNonseason1 = utility(cNonseason,etaArray(1));
 uNonseason2 = utility(cNonseason,etaArray(2));
 uNonseason4 = utility(cNonseason,etaArray(3));
 wNonseason1 = welfare(uNonseason1);
 wNonseason2 = welfare(uNonseason2);
 wNonseason4 = welfare(uNonseason4);

 
 %% calculate the welfare with only seasonal risk
 % Season risk have 3 condistions:middle high low 
 cmSeason = zMatrix.*mSeasonMatrix;
 chSeason = zMatrix.*hSeasonMatrix;
 clSeason = zMatrix.*lSeasonMatrix;
 umSeason1 = utility(cmSeason,etaArray(1));
 umSeason2 = utility(cmSeason,etaArray(2));
 umSeason4 = utility(cmSeason,etaArray(3));
 uhSeason1 = utility(chSeason,etaArray(1));
 uhSeason2 = utility(chSeason,etaArray(2));
 uhSeason4 = utility(chSeason,etaArray(3));
 ulSeason1 = utility(clSeason,etaArray(1));
 ulSeason2 = utility(clSeason,etaArray(2));
 ulSeason4 = utility(clSeason,etaArray(3));
 wmSeason1 = welfare(umSeason1);
 wmSeason2 = welfare(umSeason2);
 wmSeason4 = welfare(umSeason4);
 whSeason1 = welfare(uhSeason1);
 whSeason2 = welfare(uhSeason2);
 whSeason4 = welfare(uhSeason4);
 wlSeason1 = welfare(ulSeason1);
 wlSeason2 = welfare(ulSeason2);
 wlSeason4 = welfare(ulSeason4);
 
 %% Calculate the welfare with nonseasonal and season risk
 cmSeasonConsumption = zMatrix.*mSeasonMatrix.*epsilonYMatrix;
 chSeasonConsumption = zMatrix.*hSeasonMatrix.*epsilonYMatrix;
 clSeasonConsumption = zMatrix.*lSeasonMatrix.*epsilonYMatrix;
 umSeasonConsumption1 = utility(cmSeasonConsumption,etaArray(1));
 umSeasonConsumption2 = utility(cmSeasonConsumption,etaArray(2));
 umSeasonConsumption4 = utility(cmSeasonConsumption,etaArray(3));
 uhSeasonConsumption1 = utility(chSeasonConsumption,etaArray(1));
 uhSeasonConsumption2 = utility(chSeasonConsumption,etaArray(2));
 uhSeasonConsumption4 = utility(chSeasonConsumption,etaArray(3));
 ulSeasonConsumption1 = utility(clSeasonConsumption,etaArray(1));
 ulSeasonConsumption2 = utility(clSeasonConsumption,etaArray(2));
 ulSeasonConsumption4 = utility(clSeasonConsumption,etaArray(3));
 wmSeasonConsumption1 = welfare(umSeasonConsumption1);
 wmSeasonConsumption2 = welfare(umSeasonConsumption2);
 wmSeasonConsumption4 = welfare(umSeasonConsumption4);
 whSeasonConsumption1 = welfare(uhSeasonConsumption1);
 whSeasonConsumption2 = welfare(uhSeasonConsumption2);
 whSeasonConsumption4 = welfare(uhSeasonConsumption4);
 wlSeasonConsumption1 = welfare(ulSeasonConsumption1);
 wlSeasonConsumption2 = welfare(ulSeasonConsumption2);
 wlSeasonConsumption4 = welfare(ulSeasonConsumption4);
 
 %% Calculate the welfare with determinstic and stochastic seasonal compent 
 cmmSeason = zMatrix.*mSeasonMatrix.*msSeasonMatrix;
 cmhSeason = zMatrix.*mSeasonMatrix.*hsSeasonMatrix;
 cmlSeason = zMatrix.*mSeasonMatrix.*lsSeasonMatrix;
 chmSeason = zMatrix.*hSeasonMatrix.*msSeasonMatrix;
 chhSeason = zMatrix.*hSeasonMatrix.*hsSeasonMatrix;
 chlSeason = zMatrix.*hSeasonMatrix.*lsSeasonMatrix;
 clmSeason = zMatrix.*lSeasonMatrix.*msSeasonMatrix;
 clhSeason = zMatrix.*lSeasonMatrix.*hsSeasonMatrix;
 cllSeason = zMatrix.*lSeasonMatrix.*lsSeasonMatrix;

 ummSeason1 = utility(cmmSeason,etaArray(1));
 ummSeason2 = utility(cmmSeason,etaArray(2));
 ummSeason4 = utility(cmmSeason,etaArray(3));
 umhSeason1 = utility(cmhSeason,etaArray(1));
 umhSeason2 = utility(cmhSeason,etaArray(2));
 umhSeason4 = utility(cmhSeason,etaArray(3));
 umlSeason1 = utility(cmlSeason,etaArray(1));
 umlSeason2 = utility(cmlSeason,etaArray(2));
 umlSeason4 = utility(cmlSeason,etaArray(3));
 wmmSeason1 = welfare(ummSeason1);
 wmmSeason2 = welfare(ummSeason2);
 wmmSeason4 = welfare(ummSeason4);
 wmhSeason1 = welfare(umhSeason1);
 wmhSeason2 = welfare(umhSeason2);
 wmhSeason4 = welfare(umhSeason4);
 wmlSeason1 = welfare(umlSeason1);
 wmlSeason2 = welfare(umlSeason2);
 wmlSeason4 = welfare(umlSeason4);
 
 uhmSeason1 = utility(chmSeason,etaArray(1));
 uhmSeason2 = utility(chmSeason,etaArray(2));
 uhmSeason4 = utility(chmSeason,etaArray(3));
 uhhSeason1 = utility(chhSeason,etaArray(1));
 uhhSeason2 = utility(chhSeason,etaArray(2));
 uhhSeason4 = utility(chhSeason,etaArray(3));
 uhlSeason1 = utility(chlSeason,etaArray(1));
 uhlSeason2 = utility(chlSeason,etaArray(2));
 uhlSeason4 = utility(chlSeason,etaArray(3));
 whmSeason1 = welfare(uhmSeason1);
 whmSeason2 = welfare(uhmSeason2);
 whmSeason4 = welfare(uhmSeason4);
 whhSeason1 = welfare(uhhSeason1);
 whhSeason2 = welfare(uhhSeason2);
 whhSeason4 = welfare(uhhSeason4);
 whlSeason1 = welfare(uhlSeason1);
 whlSeason2 = welfare(uhlSeason2);
 whlSeason4 = welfare(uhlSeason4);

 ulmSeason1 = utility(cmmSeason,etaArray(1));
 ulmSeason2 = utility(cmmSeason,etaArray(2));
 ulmSeason4 = utility(cmmSeason,etaArray(3));
 ulhSeason1 = utility(cmhSeason,etaArray(1));
 ulhSeason2 = utility(cmhSeason,etaArray(2));
 ulhSeason4 = utility(cmhSeason,etaArray(3));
 ullSeason1 = utility(cmlSeason,etaArray(1));
 ullSeason2 = utility(cmlSeason,etaArray(2));
 ullSeason4 = utility(cmlSeason,etaArray(3));
 wlmSeason1 = welfare(ummSeason1);
 wlmSeason2 = welfare(ummSeason2);
 wlmSeason4 = welfare(ummSeason4);
 wlhSeason1 = welfare(umhSeason1);
 wlhSeason2 = welfare(umhSeason2);
 wlhSeason4 = welfare(umhSeason4);
 wllSeason1 = welfare(umlSeason1);
 wllSeason2 = welfare(umlSeason2);
 wllSeason4 = welfare(umlSeason4); 
 

 
 %% Calculate the welfare with determinstic and stochastic seasonal compent and consumption risk
 cmmSeasonConsumption = zMatrix.*mSeasonMatrix.*msSeasonMatrix.*epsilonYMatrix;
 cmhSeasonConsumption = zMatrix.*mSeasonMatrix.*hsSeasonMatrix.*epsilonYMatrix;
 cmlSeasonConsumption = zMatrix.*mSeasonMatrix.*lsSeasonMatrix.*epsilonYMatrix;
 chmSeasonConsumption = zMatrix.*hSeasonMatrix.*msSeasonMatrix.*epsilonYMatrix;
 chhSeasonConsumption = zMatrix.*hSeasonMatrix.*hsSeasonMatrix.*epsilonYMatrix;
 chlSeasonConsumption = zMatrix.*hSeasonMatrix.*lsSeasonMatrix.*epsilonYMatrix;
 clmSeasonConsumption = zMatrix.*lSeasonMatrix.*msSeasonMatrix.*epsilonYMatrix;
 clhSeasonConsumption = zMatrix.*lSeasonMatrix.*hsSeasonMatrix.*epsilonYMatrix;
 cllSeasonConsumption = zMatrix.*lSeasonMatrix.*lsSeasonMatrix.*epsilonYMatrix;

 ummSeasonConsumption1 = utility(cmmSeasonConsumption,etaArray(1));
 ummSeasonConsumption2 = utility(cmmSeasonConsumption,etaArray(2));
 ummSeasonConsumption4 = utility(cmmSeasonConsumption,etaArray(3));
 umhSeasonConsumption1 = utility(cmhSeasonConsumption,etaArray(1));
 umhSeasonConsumption2 = utility(cmhSeasonConsumption,etaArray(2));
 umhSeasonConsumption4 = utility(cmhSeasonConsumption,etaArray(3));
 umlSeasonConsumption1 = utility(cmlSeasonConsumption,etaArray(1));
 umlSeasonConsumption2 = utility(cmlSeasonConsumption,etaArray(2));
 umlSeasonConsumption4 = utility(cmlSeasonConsumption,etaArray(3));
 wmmSeasonConsumption1 = welfare(ummSeasonConsumption1);
 wmmSeasonConsumption2 = welfare(ummSeasonConsumption2);
 wmmSeasonConsumption4 = welfare(ummSeasonConsumption4);
 wmhSeasonConsumption1 = welfare(umhSeasonConsumption1);
 wmhSeasonConsumption2 = welfare(umhSeasonConsumption2);
 wmhSeasonConsumption4 = welfare(umhSeasonConsumption4);
 wmlSeasonConsumption1 = welfare(umlSeasonConsumption1);
 wmlSeasonConsumption2 = welfare(umlSeasonConsumption2);
 wmlSeasonConsumption4 = welfare(umlSeasonConsumption4);
 
 uhmSeasonConsumption1 = utility(chmSeasonConsumption,etaArray(1));
 uhmSeasonConsumption2 = utility(chmSeasonConsumption,etaArray(2));
 uhmSeasonConsumption4 = utility(chmSeasonConsumption,etaArray(3));
 uhhSeasonConsumption1 = utility(chhSeasonConsumption,etaArray(1));
 uhhSeasonConsumption2 = utility(chhSeasonConsumption,etaArray(2));
 uhhSeasonConsumption4 = utility(chhSeasonConsumption,etaArray(3));
 uhlSeasonConsumption1 = utility(chlSeasonConsumption,etaArray(1));
 uhlSeasonConsumption2 = utility(chlSeasonConsumption,etaArray(2));
 uhlSeasonConsumption4 = utility(chlSeasonConsumption,etaArray(3));
 whmSeasonConsumption1 = welfare(uhmSeasonConsumption1);
 whmSeasonConsumption2 = welfare(uhmSeasonConsumption2);
 whmSeasonConsumption4 = welfare(uhmSeasonConsumption4);
 whhSeasonConsumption1 = welfare(uhhSeasonConsumption1);
 whhSeasonConsumption2 = welfare(uhhSeasonConsumption2);
 whhSeasonConsumption4 = welfare(uhhSeasonConsumption4);
 whlSeasonConsumption1 = welfare(uhlSeasonConsumption1);
 whlSeasonConsumption2 = welfare(uhlSeasonConsumption2);
 whlSeasonConsumption4 = welfare(uhlSeasonConsumption4);

 ulmSeasonConsumption1 = utility(cmmSeasonConsumption,etaArray(1));
 ulmSeasonConsumption2 = utility(cmmSeasonConsumption,etaArray(2));
 ulmSeasonConsumption4 = utility(cmmSeasonConsumption,etaArray(3));
 ulhSeasonConsumption1 = utility(cmhSeasonConsumption,etaArray(1));
 ulhSeasonConsumption2 = utility(cmhSeasonConsumption,etaArray(2));
 ulhSeasonConsumption4 = utility(cmhSeasonConsumption,etaArray(3));
 ullSeasonConsumption1 = utility(cmlSeasonConsumption,etaArray(1));
 ullSeasonConsumption2 = utility(cmlSeasonConsumption,etaArray(2));
 ullSeasonConsumption4 = utility(cmlSeasonConsumption,etaArray(3));
 wlmSeasonConsumption1 = welfare(ummSeasonConsumption1);
 wlmSeasonConsumption2 = welfare(ummSeasonConsumption2);
 wlmSeasonConsumption4 = welfare(ummSeasonConsumption4);
 wlhSeasonConsumption1 = welfare(umhSeasonConsumption1);
 wlhSeasonConsumption2 = welfare(umhSeasonConsumption2);
 wlhSeasonConsumption4 = welfare(umhSeasonConsumption4);
 wllSeasonConsumption1 = welfare(umlSeasonConsumption1);
 wllSeasonConsumption2 = welfare(umlSeasonConsumption2);
 wllSeasonConsumption4 = welfare(umlSeasonConsumption4);

 %% calculate welfare gain
 %% Q2.1: welfare gain of removing the seasonal component
 gNoseason1 = zeros(nHousehold,3);
 gNoseason1(:,1) = gain(wmSeasonConsumption1,wNonseason1,beta,1);
 gNoseason1(:,2) = gain(whSeasonConsumption1,wNonseason1,beta,1);
 gNoseason1(:,3) = gain(wlSeasonConsumption1,wNonseason1,beta,1);
 
 gNoseason2 = zeros(nHousehold,3);
 gNoseason2(:,1) = gain(wmSeasonConsumption2,wNonseason2,beta,2);
 gNoseason2(:,2) = gain(whSeasonConsumption2,wNonseason2,beta,2);
 gNoseason2(:,3) = gain(wlSeasonConsumption2,wNonseason2,beta,2);
 
 gNoseason4 = zeros(nHousehold,3);
 gNoseason4(:,1) = gain(wmSeasonConsumption4,wNonseason4,beta,4);
 gNoseason4(:,2) = gain(whSeasonConsumption4,wNonseason4,beta,4);
 gNoseason4(:,3) = gain(wlSeasonConsumption4,wNonseason4,beta,4);
 


 gSeason1 = zeros(nHousehold,3);
 gSeason1(:,1) = gain(wmSeasonConsumption1,wmSeason1,beta,1);
 gSeason1(:,2) = gain(whSeasonConsumption1,whSeason1,beta,1);
 gSeason1(:,3) = gain(wlSeasonConsumption1,wlSeason1,beta,1);
 
 gSeason2 = zeros(nHousehold,3);
 gSeason2(:,1) = gain(wmSeasonConsumption2,wmSeason2,beta,2);
 gSeason2(:,2) = gain(whSeasonConsumption2,whSeason2,beta,2);
 gSeason2(:,3) = gain(wlSeasonConsumption2,wlSeason2,beta,2);
 
 gSeason4 = zeros(nHousehold,3);
 gSeason4(:,1) = gain(wmSeasonConsumption4,wmSeason4,beta,4);
 gSeason4(:,2) = gain(whSeasonConsumption4,whSeason4,beta,4);
 gSeason4(:,3) = gain(wlSeasonConsumption4,wlSeason4,beta,4);
 
 
subplot(3,1,1)
h1 = histogram(gSeason1(:,1));
hold on
h2 = histogram(gSeason1(:,2));
hold on
h3 = histogram(gSeason1(:,3));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('\eta = 1')

subplot(3,1,2)
h1 = histogram(gSeason2(:,1));
hold on
h2 = histogram(gSeason2(:,2));
hold on
h3 = histogram(gSeason2(:,3));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('\eta = 2')

subplot(3,1,3)
h1 = histogram(gSeason4(:,1));
hold on
h2 = histogram(gSeason4(:,2));
hold on
h3 = histogram(gSeason4(:,3));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('\eta = 4')
 
 %% Q2.2: welfare gain of removing the nonseasonal risk
 gsNoseason1 = zeros(nHousehold,9);
 gsNoseason1(:,1) = gain(wmmSeasonConsumption1,wNonseason1,beta,1);
 gsNoseason1(:,2) = gain(wmhSeasonConsumption1,wNonseason1,beta,1);
 gsNoseason1(:,3) = gain(wmlSeasonConsumption1,wNonseason1,beta,1);
 gsNoseason1(:,4) = gain(whmSeasonConsumption1,wNonseason1,beta,1);
 gsNoseason1(:,5) = gain(whhSeasonConsumption1,wNonseason1,beta,1);
 gsNoseason1(:,6) = gain(whlSeasonConsumption1,wNonseason1,beta,1);
 gsNoseason1(:,7) = gain(wlmSeasonConsumption1,wNonseason1,beta,1);
 gsNoseason1(:,8) = gain(wlhSeasonConsumption1,wNonseason1,beta,1);
 gsNoseason1(:,9) = gain(wllSeasonConsumption1,wNonseason1,beta,1);
 
subplot(3,1,1)
h1 = histogram(gsNoseason1(:,1));
hold on
h2 = histogram(gsNoseason1(:,2));
hold on
h3 = histogram(gsNoseason1(:,3));
legend([h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Middle Level')

subplot(3,1,2)
h1 = histogram(gsNoseason1(:,4));
hold on
h2 = histogram(gsNoseason1(:,5));
hold on
h3 = histogram(gsNoseason1(:,6));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is High Level')

subplot(3,1,3)
h1 = histogram(gsNoseason1(:,7));
hold on
h2 = histogram(gsNoseason1(:,8));
hold on
h3 = histogram(gsNoseason1(:,9));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Low Level')

 gsNoseason2 = zeros(nHousehold,9);
 gsNoseason2(:,1) = gain(wmmSeasonConsumption2,wNonseason2,beta,2);
 gsNoseason2(:,2) = gain(wmhSeasonConsumption2,wNonseason2,beta,2);
 gsNoseason2(:,3) = gain(wmlSeasonConsumption2,wNonseason2,beta,2);
 gsNoseason2(:,4) = gain(whmSeasonConsumption2,wNonseason2,beta,2);
 gsNoseason2(:,5) = gain(whhSeasonConsumption2,wNonseason2,beta,2);
 gsNoseason2(:,6) = gain(whlSeasonConsumption2,wNonseason2,beta,2);
 gsNoseason2(:,7) = gain(wlmSeasonConsumption2,wNonseason2,beta,2);
 gsNoseason2(:,8) = gain(wlhSeasonConsumption2,wNonseason2,beta,2);
 gsNoseason2(:,9) = gain(wllSeasonConsumption2,wNonseason2,beta,2);
 
subplot(3,1,1)
h1 = histogram(gsNoseason2(:,1));
hold on
h2 = histogram(gsNoseason2(:,2));
hold on
h3 = histogram(gsNoseason2(:,3));
legend([h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Middle Level')

subplot(3,1,2)
h1 = histogram(gsNoseason2(:,4));
hold on
h2 = histogram(gsNoseason2(:,5));
hold on
h3 = histogram(gsNoseason2(:,6));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is High Level')

subplot(3,1,3)
h1 = histogram(gsNoseason2(:,7));
hold on
h2 = histogram(gsNoseason2(:,8));
hold on
h3 = histogram(gsNoseason2(:,9));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Low Level')
 
 
 gsNoseason4 = zeros(nHousehold,9);
 gsNoseason4(:,1) = gain(wmmSeasonConsumption4,wNonseason4,beta,4);
 gsNoseason4(:,2) = gain(wmhSeasonConsumption4,wNonseason4,beta,4);
 gsNoseason4(:,3) = gain(wmlSeasonConsumption4,wNonseason4,beta,4);
 gsNoseason4(:,4) = gain(whmSeasonConsumption4,wNonseason4,beta,4);
 gsNoseason4(:,5) = gain(whhSeasonConsumption4,wNonseason4,beta,4);
 gsNoseason4(:,6) = gain(whlSeasonConsumption4,wNonseason4,beta,4);
 gsNoseason4(:,7) = gain(wlmSeasonConsumption4,wNonseason4,beta,4);
 gsNoseason4(:,8) = gain(wlhSeasonConsumption4,wNonseason4,beta,4);
 gsNoseason4(:,9) = gain(wllSeasonConsumption4,wNonseason4,beta,4);
 
 
subplot(3,1,1)
h1 = histogram(gsNoseason4(:,1));
hold on
h2 = histogram(gsNoseason4(:,2));
hold on
h3 = histogram(gsNoseason4(:,3));
legend([h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Middle Level')

subplot(3,1,2)
h1 = histogram(gsNoseason4(:,4));
hold on
h2 = histogram(gsNoseason4(:,5));
hold on
h3 = histogram(gsNoseason4(:,6));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is High Level')

subplot(3,1,3)
h1 = histogram(gsNoseason4(:,7));
hold on
h2 = histogram(gsNoseason4(:,8));
hold on
h3 = histogram(gsNoseason4(:,9));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Low Level')
 
 
 gsSeason1 = zeros(nHousehold,9);
 gsSeason1(:,1) = gain(wmmSeasonConsumption1,wmmSeason1,beta,1);
 gsSeason1(:,2) = gain(wmhSeasonConsumption1,wmhSeason1,beta,1);
 gsSeason1(:,3) = gain(wmlSeasonConsumption1,wmlSeason1,beta,1);
 gsSeason1(:,4) = gain(whmSeasonConsumption1,whmSeason1,beta,1);
 gsSeason1(:,5) = gain(whhSeasonConsumption1,whhSeason1,beta,1);
 gsSeason1(:,6) = gain(whlSeasonConsumption1,whlSeason1,beta,1);
 gsSeason1(:,7) = gain(wlmSeasonConsumption1,wlmSeason1,beta,1);
 gsSeason1(:,8) = gain(wlhSeasonConsumption1,wlhSeason1,beta,1);
 gsSeason1(:,9) = gain(wllSeasonConsumption1,wllSeason1,beta,1);
 
 subplot(3,1,1)
h1 = histogram(gsSeason1(:,1));
hold on
h2 = histogram(gsSeason1(:,2));
hold on
h3 = histogram(gsSeason1(:,3));
legend([h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Middle Level')

subplot(3,1,2)
h1 = histogram(gsSeason1(:,4));
hold on
h2 = histogram(gsSeason1(:,5));
hold on
h3 = histogram(gsSeason1(:,6));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is High Level')

subplot(3,1,3)
h1 = histogram(gsSeason1(:,7));
hold on
h2 = histogram(gsSeason1(:,8));
hold on
h3 = histogram(gsSeason1(:,9));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Low Level')
 
 
 gsSeason2 = zeros(nHousehold,9);
 gsSeason2(:,1) = gain(wmmSeasonConsumption2,wmmSeason2,beta,2);
 gsSeason2(:,2) = gain(wmhSeasonConsumption2,wmhSeason2,beta,2);
 gsSeason2(:,3) = gain(wmlSeasonConsumption2,wmlSeason2,beta,2);
 gsSeason2(:,4) = gain(whmSeasonConsumption2,whmSeason2,beta,2);
 gsSeason2(:,5) = gain(whhSeasonConsumption2,whhSeason2,beta,2);
 gsSeason2(:,6) = gain(whlSeasonConsumption2,whlSeason2,beta,2);
 gsSeason2(:,7) = gain(wlmSeasonConsumption2,wlmSeason2,beta,2);
 gsSeason2(:,8) = gain(wlhSeasonConsumption2,wlhSeason2,beta,2);
 gsSeason2(:,9) = gain(wllSeasonConsumption2,wllSeason2,beta,2);
 
 subplot(3,1,1)
h1 = histogram(gsSeason2(:,1));
hold on
h2 = histogram(gsSeason2(:,2));
hold on
h3 = histogram(gsSeason2(:,3));
legend([h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Middle Level')

subplot(3,1,2)
h1 = histogram(gsSeason2(:,4));
hold on
h2 = histogram(gsSeason2(:,5));
hold on
h3 = histogram(gsSeason2(:,6));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is High Level')

subplot(3,1,3)
h1 = histogram(gsSeason2(:,7));
hold on
h2 = histogram(gsSeason2(:,8));
hold on
h3 = histogram(gsSeason2(:,9));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Low Level')
 
 gsSeason4 = zeros(nHousehold,9);
 gsSeason4(:,1) = gain(wmmSeasonConsumption4,wmmSeason4,beta,4);
 gsSeason4(:,2) = gain(wmhSeasonConsumption4,wmhSeason4,beta,4);
 gsSeason4(:,3) = gain(wmlSeasonConsumption4,wmlSeason4,beta,4);
 gsSeason4(:,4) = gain(whmSeasonConsumption4,whmSeason4,beta,4);
 gsSeason4(:,5) = gain(whhSeasonConsumption4,whhSeason4,beta,4);
 gsSeason4(:,6) = gain(whlSeasonConsumption4,whlSeason4,beta,4);
 gsSeason4(:,7) = gain(wlmSeasonConsumption4,wlmSeason4,beta,4);
 gsSeason4(:,8) = gain(wlhSeasonConsumption4,wlhSeason4,beta,4);
 gsSeason4(:,9) = gain(wllSeasonConsumption4,wllSeason4,beta,4);
 
 
 subplot(3,1,1)
h1 = histogram(gsSeason4(:,1));
hold on
h2 = histogram(gsSeason4(:,2));
hold on
h3 = histogram(gsSeason4(:,3));
legend([h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Middle Level')

subplot(3,1,2)
h1 = histogram(gsSeason4(:,4));
hold on
h2 = histogram(gsSeason4(:,5));
hold on
h3 = histogram(gsSeason4(:,6));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is High Level')

subplot(3,1,3)
h1 = histogram(gsSeason4(:,7));
hold on
h2 = histogram(gsSeason4(:,8));
hold on
h3 = histogram(gsSeason4(:,9));
legend( [h1 h2 h3],{'Mid', 'High', 'Low'})
hold off 
title('Deterministic Seasonal Component is Low Level')
 
 
 
 
 
