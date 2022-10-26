function LS = EvaluateLS(X, example)
% 
% LS = EvaluateLS(X, example)
% LS is the value of the level set function at points X


if example == 1
    P0 = [0,0];  
    r0 = 0.5; 
    LS = sqrt((X(:,1) - P0(1)).^2 + (X(:,2) - P0(2)).^2) - r0;
else
    y1 = -0.5; y2 = 0.25;
    LS_aux = [X(:,2)-y1   X(:,2)-y2];
    n = size(X,1);
    LS = zeros(n,1);
    for i = 1:n
        if X(i,2) > y1 && X(i,2) < y2
            sgn = 1;
        else
            sgn = -1;
        end
        LS(i) = sgn*min(abs(LS_aux(i,:)));
    end
end


