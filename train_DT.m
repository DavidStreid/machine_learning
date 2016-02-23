% Tree is a cell_array of size = 2^(depth+1) - 1
function tree = hw2_train_DT(train_data, depth)
    if or(depth == 0,size(train_data,1) == 1)           % Handle base case - leaf node
        num0 = sum(train_data(:,58) == 0)
        num1 = size(train_data,1) - num0

        [plurality, idx] = max([num0,num1])             % Find the max error
        if(depth==0)
            tree = [idx-1]                              % Return label, 1 or 0, of leaf node
        else
            tree = [{idx-1} cell(1,2^(depth+1)-2)]      % Return label followed by voided children
        end
    else
        num_entries = size(train_data, 1)
        num_features = size(train_data, 2)
        min_classification_error = [1,1,-1]             % Tracks lowest error [feature, uncertainty, t_value]
        for i = 1:num_features-1                        % cycle through features
            sorted = sortrows(train_data, i)            % TODO - Possible reason for error (Excluding the LAST ENTRY)
            f_v = sorted(1,i)
            for j = 1:num_entries
                if f_v ~= sorted(j,i)                   % j = number of entries less than
                    f_v = sorted(j,i)
                    
                    Left_size = j-1
                    Right_size = num_entries - j + 1
                    
                    prop_left = Left_size./num_entries
                    prop_right = Right_size./num_entries
                    
                    Left_Spam = sum(sorted(1:Left_size,58))
                    Right_Spam = sum(sorted(j:num_entries,58))
                    
                    % UNCERTAINTY NOTION I - Classification Error
%                     U_Left = (1-Left_Spam/Left_size).*prop_left + (1-(Right_size-Right_Spam)/Right_size).*prop_right
%                     U_Right = (1-Right_Spam/Right_size).*prop_right + prop_left.*(1-(Left_size-Left_Spam)/Left_size)
%                     min_U = min([U_Left, U_Right])
                    
                    % UNCERTAINTY NOTION II - Gini Index
%                     U_Left = (1 - (Left_Spam/Left_size)^2 - ((Left_size-Left_Spam)/Left_size)^2).*prop_left
%                     U_Right = (1 - (Right_Spam/Right_size)^2 - ((Right_size-Right_Spam)/Right_size)^2.*prop_right)
%                     min_U = U_Left + U_Right
                    
                    % UNCERTAINTY NOTION III - Entropy
                    U_Left = (log10(1./(Left_Spam/Left_size)).*(Left_Spam/Left_size)...
                    +log10(1./((Left_size - Left_Spam)/Left_size)).*(Left_size - Left_Spam)/Left_size).*prop_left
                    U_Right = (log10(1./(Right_Spam/Right_size)).*(Right_Spam/Right_size)...
                    +log10(1./((Right_size - Right_Spam)/Right_size)).*(Right_size - Right_Spam)/Right_size).*prop_right
                    min_U = U_Left + U_Right
                    
                    if min_U < min_classification_error(2) %[feature, uncertainty, t_value]
                        min_classification_error = [i, min_U, f_v]
                    end
                end
            end  
        end
        split_feature = train_data(:,min_classification_error(1))
        Left = {}
        Right = {}

        greater_than_t = train_data(:,min_classification_error(1))>min_classification_error(3)
        Right = train_data(greater_than_t,:)
        Left = train_data(logical(1-greater_than_t),:)

        % Handle case if Left or Right is empty, == [] - TODO: WHY is this the case?
        if or(isempty(Left),isempty(Right))
            if isempty(Left)
                label = hw2_train_DT(Right, 0)
            elseif isempty(Right)
                label = hw2_train_DT(Left, 0)
            end
            tree = [label, cell(1,2^(depth+1)-2)]
        else
            node_rule = {[min_classification_error(1), min_classification_error(3), depth]} %[feature, t, depth]
            tree = [node_rule hw2_train_DT(Left, depth-1) hw2_train_DT(Right, depth-1)]
        end
    end
    



