numTrials = input('#Trials: ');
response = input('Response. (R/P): ');
numHiddenLayers = input('#hidden layers (1-2): ');
dataFiles = {'al_data.csv'};
minRMSE = 100;
for c = 1:length(dataFiles)
    fprintf('\nData file --> %s', dataFiles{c});
    [rmse, algo, n, transFcn] = findOptNet(dataFiles{c}, numTrials, response, numHiddenLayers);
    fprintf('\n==========================\n');
    fprintf('Data file: %s\nOptimum RMSE = %.3f\nAlgorithm = %s\n#Hidden Layer neurons = %d\n', dataFiles{c}, rmse, algo, n);
    fprintf('==========================\n\n');
    fprintf('\nPress enter to continue.\n\n');
    fprintf('Training with %s: ', algo);
    figure;
    fprintf('\n\n');
    hold on;
    if rmse < minRMSE
        minRMSE = rmse;
        ALGO = algo;
        C = c;
        N = n;
        TRANSFCN = transFcn;
    end
end
fprintf('\nBest performance: ');

fprintf('Architecture 3-%d-1 with %s and transfer Fcn = %s, RMSE = %.3f\n', N, ALGO, TRANSFCN, minRMSE);        
fprintf('\nTraining with %s: ', ALGO);

if numHiddenLayers == 1
    [e, net1, err1] = annTrain(dataFiles{1}, N, ALGO, TRANSFCN, 1, response, 1);
else
    [e, net1, err1] = annTrain(dataFiles{1}, [N N], ALGO, TRANSFCN, 1, response, 1);
end
fprintf('\nTraining with %f: ', e);
fprintf('\n');
figure;
plot(1:size(err1, 2), -err1, '-o');
hold on;
title('Deviation graph for optimum architecture', 'FontSize', 20);
xlabel('Testing runs','FontSize', 14);
if response == 'R'
    ylabel('R_a (actual) - R_a (predicted), \mum','FontSize', 14);
else
    ylabel('P (actual) - P (predicted), kW','FontSize', 14);
end
hold off;