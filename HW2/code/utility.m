function y = utility(x,eta)
 if eta == 1
   y = log(x);
 else
   y = x.^(1-eta)/(1-eta);
 end
  end