function [e, network, err] = annTrain(fileName, hidden_layer_size, algo, transFcn, numTrials, response, RplotFlag)
    data = load(fileName);
    n = size(data, 2);
    inputs = (data(:, 1:n - 1))';
    if response == 'R'
        targets = (data(:, n - 1))';
    else
        targets = (data(:, n))';
    end
    e = [];
    for trial = 1:numTrials
        network = feedforwardnet(hidden_layer_size);
        
        network.trainFcn = algo;
        if size(hidden_layer_size, 2) == 1
            network.layers{1}.transferFcn = transFcn;
            network.layers{2}.transferFcn = 'purelin';
        else
            network.layers{1}.transferFcn = transFcn;
            network.layers{2}.transferFcn = transFcn;
            network.layers{3}.transferFcn = 'purelin';
        end
        network.trainParam.showWindow = 0;
        network.divideParam.trainRatio = 0.7;
        network.divideParam.valRatio = 0.15;
        network.divideParam.testRatio = 0.15;
        network = init(network);
        network = train(network, inputs, targets);
        outputs = network(inputs);
        err = (outputs - targets);
        rmse = sqrt(sum(sum(err.*err))/(size(err, 1) * size(err, 2)));
        e = [e rmse];
        if RplotFlag == 1
            plotregression(targets, outputs);
            legend('Y = T', strcat('Fit: ','n = ', int2str(hidden_layer_size(1))), 'Data', 'Location','NorthWest');
        end
    end
end
