function M = translation_matrix(p)
    M = [1 0 0 p(1);
         0 1 0 p(2);
         0 0 1 p(3);
         0 0 0 1];
end