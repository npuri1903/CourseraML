function [theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
%   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

% theta

% h1 = (X*theta - y)'

for iter = 1:num_iters

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCostMulti) and gradient here.
    %

    % iter
    h = (X*theta - y)';
    grad =  (h * X)';
    % size(h);
    theta = theta - (alpha * (1/m) * grad );
    % pause;
    % size(theta)


    % ============================================================

    % Save the cost J in every iteration    
    cost = computeCostMulti(X, y, theta);
    J_history(iter) = cost;

end

end
