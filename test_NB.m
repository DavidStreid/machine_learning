function function_loss = test_NB(params, test_data)
    class_prior = params{1}
    [r,c] = size(test_data)
    test_results = {}
    function_loss = 0
    for instance = 1:r
        current_row = test_data(instance,:) % Selects 
        likelihood_estimators = []
        for i = 0:9
            class_conditional = params{i+2}
            l_e = 1 % likelihood estimator
            for j = 1:c-1
               v = current_row(j) 
               p = class_conditional(j)
               l_e = l_e.*((p.^v).*(1-p).^(1-v))
            end
            likelihood_estimators = [likelihood_estimators l_e]
        end
        max_l = max(likelihood_estimators)
        idx = find(likelihood_estimators==max_l)
        if current_row(257) ~= idx-1
           function_loss = function_loss + 1
        end
    end
