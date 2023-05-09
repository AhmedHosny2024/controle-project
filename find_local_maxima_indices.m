function max_indices = find_local_maxima_indices(input_vector)
% FIND_LOCAL_MAXIMA_INDICES Finds the indices of local maxima in a given input vector.
%
%   INPUTS:
%       input_vector - The input vector to search for local maxima.
%
%   OUTPUTS:
%       max_indices - A vector of the indices of all local maxima in the input vector.

% Find the indices of all local maxima in the input vector
max_indices = find(diff(sign(diff(input_vector)))==-2) + 1;
