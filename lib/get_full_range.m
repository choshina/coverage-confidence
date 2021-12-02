function range_t = get_full_range(input_range, cp)
    [dim, ~] = size(input_range);
    
    range_t = [];
    for i = 1:dim
        for j = 1:cp
            range_t = [range_t; input_range(i,:)];
        end
    end
end