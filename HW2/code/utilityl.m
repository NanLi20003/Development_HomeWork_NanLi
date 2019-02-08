function y=utilityl(x1,x2,kappa)
  yc = log(x1);
  yl = x2.^2./2.*kappa;
  y  = yc - yl;

end