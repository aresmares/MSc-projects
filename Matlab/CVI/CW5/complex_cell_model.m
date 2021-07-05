function [Ibgout] = complex_cell_model(Ib)


orientations = [0,15,30,45,60,75,90,105,120,135,150,165];
n = length(orientations);
complex = cell(n, 1) ;
for c=1:n
    gab1 = gabor2(3,0.1,orientations(n),0.75,90);
    gab2 = gabor2(3,0.1,orientations(n),0.75,0);
    
    Ibg1 = conv2(Ib,gab1,"valid");
    Ibg2 = conv2(Ib,gab2,"valid");
    disp(size(Ibg2,2))
    
    Ibgout = zeros(size(Ibg2));
    for i=1:size(Ibg2)
        for b=1:size(Ibg2,2)
            s1 = abs(Ibg1(i,b)).^2 ; 
            s2 = abs(Ibg2(i,b)).^2 ;
            val = s1+s2;
            l2 = sqrt(sum(val));
            Ibgout(i,b) = l2;
        end
    end
    complex{c} = Ibgout;
end

Ibgo = zeros(size(complex{1}));
for i=1:n
    for x = 1:size(complex{i})
        for y = 1:size(complex{i})
            if complex{i}(x,y) > Ibgo(x,y)
               Ibgo(x,y) = complex{i}(x,y);
            end
        end
    end
end


end