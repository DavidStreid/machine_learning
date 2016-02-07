% Returns 1x11 vector of [class_prior, class_conditional]
% class_prior = [1x10 double] 
% class_conditional = [[1x256 double] x 10]
function params = train_NB(train_data)
    train_size = size(train_data, 1);
    class_conditional = {}  % 2-D matrix of rows corresponding to feature probabilities for labels 0-9
    class_prior = []     	% class_prior probabilities [P(y=0), P(y=1), ... P(y=9)]

    for label = 0:9
        current_label = train_data(train_data(:,257)==label,:); % Only rows of certain label
        current_fp = []
        class_prior = [class_prior size(current_label, 1)./train_size]
        [r,c] = size(current_label);
        for i = 1:c-1
            current_fp = [current_fp sum(current_label(:,[i]))./r]
        end
        class_conditional{end+1} = current_fp
    end
    params = [class_prior, class_conditional]
  


