function [A,X] = A_join_X(A,X_df)
    X_height = size(X_df, 1);
    K = size(A, 1);
    X = cell(K, 1);
    j = 1;
    for i=1:K
        while j <= X_height && ~strcmp(A{i, 1}{1}, X_df{j, 1}{1})
            j = j+1;
        end
        star = j;
        while j <= X_height && strcmp(A{i, 1}{1},X_df{j, 1}{1})
            j = j+1;
        end
        temp = X_df(star : (j-1), 1:end);
        X{i} = sparse(temp{:, 2}, temp{:, 3}, ones(size(temp, 1),1), temp{end, 2}, max(X_df{:, 3}));
    end
    A = A(:, 2:end-1);
end

