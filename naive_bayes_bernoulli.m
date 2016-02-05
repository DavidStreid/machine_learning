load('usps.mat')
nines = test_usps(test_usps(:,257)==9,:);

[m,n] = size(nines);
for j = 1:n
    disp(num2str(sum(nines(:,[j]))));
end


