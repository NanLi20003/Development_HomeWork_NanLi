function y = welfare(x)
  nHousehold = 1000;
  nYear = 40;
  nMonth = 12;
  beta= 0.99;
  y = zeros(nHousehold,1);
   for h = 1:nHousehold
      for t = 1:nYear
          for m = 1:nMonth
           y(h,1) = y(h,1)+ x(h,t,m)*beta^(12*t+m-1);   
          end
      end
   end
  
  end