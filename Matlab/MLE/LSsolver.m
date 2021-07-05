function thERM=LSsolver(X,t)
thERM=inv(X'*X)*X'*t;

% o = mean(abs(t - X).^2)
% o = o'
% o = norm(t-X)
% o=lsqminnorm(t,X)
end