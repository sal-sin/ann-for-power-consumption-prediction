function [bestRMSE, bestAlgo, bestN, bestTransferFcn] = findOptNet(dataFile, numTrials, response, numHiddenLayers)
    algos = {'trainlm', 'trainbr', 'trainscg', 'trainbfg', 'trainrp', 'traincgb', 'traincgf', 'traincgp', 'trainoss', 'traingdx'};
    transferFcns = {'purelin', 'tansig', 'logsig'};
    nValues = 1:20;
    bestRMSE = 1000;
    for a = 1:length(algos)
        for t = 1:length(transferFcns)
            fprintf('\n--------\n%s\n--------\n', algos{a});
            fprintf('--------\n%s\n--------\n', transferFcns{t});
            algoBestRMSE = 1000;
            for n = nValues
                if numHiddenLayers == 1
                    hiddenLayerSize = [n];
                else
                    hiddenLayerSize = [n n];
                end
                e = annTrain(dataFile, hiddenLayerSize, algos{a}, transferFcns{t}, numTrials, response, 0);
                av_rmse = mean(e);
                if algoBestRMSE > av_rmse
                    algoBestRMSE = av_rmse;
                    algoBestN = hiddenLayerSize(1);
                end
                e = [e av_rmse];
            end
            fprintf('\nData file: %s\nOptimum RMSE = %.3f\n#Hidden Layer neurons = %d\n\n', dataFile, algoBestRMSE, algoBestN);
            if bestRMSE > algoBestRMSE
                bestRMSE = algoBestRMSE;
                bestAlgo = algos{a};
                bestTransferFcn = transferFcns{t};
                bestN = algoBestN;
            end
        end
    end
end