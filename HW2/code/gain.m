function y= gain(x1,x2,beta,eta)
% this function is used to get the welfare gain
% w((1+g)*c1) = w(c2)

betaSum = 0;
    for i = 12:491
        betaSum = betaSum+beta^i;
    end
if eta==1
    lg = (x2-x1)/betaSum;
    y = exp(lg)-1;
else
    lg = x2./x1;
    y = lg.^(1/(1-eta))-1;
end
 
end