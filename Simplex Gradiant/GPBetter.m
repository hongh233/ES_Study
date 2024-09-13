function fTest = GPBetter(xTest, xTrain, fTrain, mu, theta)
[n, m] = size(xTrain);

% compute the covariance matrix
if n==1
    d = repmat(xTrain, 1, m)-repelem(xTrain, 1, m);
else
    d = vecnorm(repmat(xTrain, 1, m)-repelem(xTrain, 1, m));
end
K = reshape(exp(-(d/theta).^2/2), m, m);


if n==1
    d = xTrain-repelem(xTest, 1, m);
else
    d = vecnorm(xTrain-repelem(xTest, 1, m));
end
%Ks = reshape(exp(-(d/theta).^2/2), m, 1);
Ks = exp(-(d/theta).^2/2)';


%fTest = min(fTrain)+Ks'*Kinv*(fTrain'-min(fTrain));
fTest = mu+Ks'*(K\(fTrain'-mu));

end