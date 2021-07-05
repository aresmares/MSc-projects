function thERM=LSsolver(X,t)
thERM=inv(X'*X)*X'*t;

end