function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%% Feedforward
% Add constant/bias node to first layer
X = [ones(m, 1) X];

% Calculate activation for second layer
z2 = X*Theta1';
a2 = sigmoid(z2);
% Add constant/bias node to second layer
a2 = [ones(m,1) a2];

% Calculate activation for third layer, a3 = h, hypothesis
z3 = a2*Theta2';
a3 = sigmoid(z3);

% Number of output nodes for final layer = number of classes.
k = size(Theta2, 1);

% Empty matrix for converting output to one-hot format.
yt = zeros(m, k);

% Convert output to one-hot format
for i = 1:k
    yt(: , i) = (y==i);
end 

% Calculate unregularized cost
J = (-1/m)*sum((yt.*log(a3) + (1 - yt).*log(1 - a3))(:));

% Regularzation
JR = (lambda/(2*m))*(sum((Theta1(:, 2:end).^2)(:)) + sum((Theta2(:, 2:end).^2)(:)) );

J += JR;


%% Backpropogation

% Error term for layer 3
d3 = a3 - yt;  % 5000 X 10

% Error term for layer 2
d2 = (d3*Theta2); % 5000 X 26
d2 = d2(:, 2:end).*sigmoidGradient(z2);   % 5000 X 25

% Gradient accumulation
Theta2_grad = (1/m)*(d3'*a2);
Theta1_grad = (1/m)*(d2'*X);

% Selectors for removing 'bias' terms.
selector2 = ones(size(Theta2));
selector2(:, 1) = 0;
selector1 = ones(size(Theta1));
selector1(:, 1) = 0;

% Regularization of gradients
Theta2_grad += (lambda/m)*(Theta2.*selector2);
Theta1_grad += (lambda/m)*(Theta1.*selector1);

% for t = 1:m
%     a1 = X(t, :);  % 1 X 401
%     z2 = a1*Theta1';  % 1 X 25
%     a2 = sigmoid(z2);  % 1 X 25
%     a2 = [1 a2]; % 1 X 26
%     z3 = a2*Theta2';   % 1 X 10 
%     a3 = sigmoid(z3);  % 1 X 10
%     yt = zeros(1, k); % 1 X 10
%     yt(:, y(t)) = 1; % 1 X 10
    
%     d3 = a3 - yt;  % 1 X 10

%     d2 = (d3*Theta2);   % 1 X 26
%     d2 = d2(:, 2:end);  % 1 X 25
%     d2 = d2.*sigmoidGradient(z2);   % 1 X 25

%     Theta2_grad += d3'*a2;  % 10 X 26
%     Theta1_grad += d2'*a1;  % 25 X 401

% end


% Theta1_grad = (1/m)*Theta1_grad;
% Theta2_grad = (1/m)*Theta2_grad;



% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
