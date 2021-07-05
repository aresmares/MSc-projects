function f = polynomialclassifier(x)
f = (classifier(0,0,x)-1)^2 + (classifier(1,1,x)-1)^2 + (classifier(0,1,x)+1)^2 + (classifier(1,0,x)+1)^2;

function y = classifier(y1,y2,c) 
y = c(1)*y1 + c(2)*y2 + c(3)*y1*y2 + c(4);