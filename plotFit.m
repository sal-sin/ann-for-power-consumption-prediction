% Plot the neural network
function plotFit(net, response)
    V = 320:1:540;
	S = 0.06:0.005:0.18;
	D = 0.5:0.002:1;
	features = {V, S, D};
	n = size(features, 2);
	for i = 1:n-1
		for k = i + 1: n
			x = size(features{i}, 2);
			y = size(features{k}, 2);
			R = zeros(x, y);
			for a = 1:x
				for b = 1:y
					if i == 1
						if k == 2
							col = [features{i}(a);features{k}(b);1];
						elseif k == 3
							col = [features{i}(a);0.16;features{k}(b)];
						end
					elseif i == 2
						col = [300;features{i}(a);features{k}(b)];
					end
					R(a,b) = net(col);
				end
			end
			figure;
			mesh(features{k}, features{i}, R);
            if i == 1
				ylabel('N', 'FontSize', 18);
				if k == 2
					xlabel('f', 'FontSize', 18);
				else
					xlabel('d', 'FontSize', 18);
				end
			else
				xlabel('d', 'FontSize', 18);
				ylabel('f', 'FontSize', 18);
            end
            if response == 'R'
                zlabel('R_a', 'FontSize', 18);
            else
                zlabel('P', 'FontSize', 18);
            end
		end
	end
end