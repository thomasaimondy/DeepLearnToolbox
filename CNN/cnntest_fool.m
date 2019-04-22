function conf = cnntest_fool(net, x, y)
    %  feedforward
    net = cnnff(net, x);
    [~, h] = max(net.o);
    conf = net.o(h(1),1);
    %[~, a] = max(y);
    %bad = find(h ~= a);

    %er = numel(bad) / size(y, 2);
end
