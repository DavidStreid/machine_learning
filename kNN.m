function loss = kNN(k, train_data, test_data)
    r = size(test_data,1)
    training_error  = 0
    for i = 1:r
        test = test_data(i,1:256)
        [a,b]  = size(train_data)      
        ED = pdist2(train_data(:,1:256),test,'euclidean')   % Find NN of each test point to training_matrix
        [sorted_ED,I] = sort(ED)    % Sort EDs and preserve original indices, I
        closest_label = []
        for j = 1:k                 % Find the corresponding labels to these indices
            closest_label = [closest_label train_data(I(j),257)]
        end
        predicted = mode(closest_label) % Find plurality of kNN
        if predicted ~= test_data(i,257)% Calculate error
            training_error = training_error + 1
        end
    end
    loss = training_error