function [I] = interval_shuffling(B)



% Part1: Collectiong interval data --maybe should be a separate function
row_index = 1:size(B,2);
for ncell = 1:size(B,1)
    logmask = logical(B(ncell,:));
    index_zeros = row_index(~logmask);
    diff_zeros = diff(index_zeros);
    int_count = 0; int_length = 0;
    for n = 1:numel(diff_zeros)
        if diff_zeros(n) > 1
            int_length = int_length+1;
            int_count = int_count+1;
            I(ncell).intervals(int_count) = int_length;
            int_length = 0;
        else
            if n == numel(diff_zeros)
                int_length = int_length+2;
                int_count = int_count+1;
                I(ncell).intervals(int_count) = int_length;
            else
                int_length = int_length+1;
            end
        end
    end
    nspikes(ncell)=sum(B(ncell,:));
end

% Part2: reproduce B
B_reshuffled = [];
for ncell = 1:size(I,2)
    % initialize paramaters
    intervals = I(ncell).intervals;
    nintervals = length(intervals);
    place_for_spikes = nintervals-1;
    b_reshuffled = [];
    % randomize the beginning of each transient train and wrap around the end
    startstop = intervals(1)+intervals(end);
    start = randi([0 startstop], 1, 1);
    stop = startstop-start;
    % first round
    b_reshuffled = [b_reshuffled, zeros(1, start)];
    b_reshuffled = [b_reshuffled, 1];
    intervals = intervals(2:end-1);
    % pick random numbers to shift the transient trains
    for nint = 1:nintervals-2
        rand_index = randi([1, numel(intervals)], 1, 1);
        b_reshuffled = [b_reshuffled, zeros(1,intervals(rand_index))]; %increment with as many zeros as we have on the randomly chosen index place
        b_reshuffled = [b_reshuffled, 1];
        intervals(rand_index)=[]; %decreasing intervals vector size
    end
    % last round
    b_reshuffled = [b_reshuffled, zeros(1, stop)];
    % now we need to place extra spikes at place_for_spikes 
    
    % place reshuffled line into the big picture
    % which will only work if all the spikes are there
    B_reshuffled = [B_reshuffled; b_reshuffled]
end





