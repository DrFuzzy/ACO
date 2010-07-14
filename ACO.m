% Ant Colony Optimization (ACO)
%
%   Based on ACO resources found at:
%   http://en.wikipedia.org/wiki/Ant_colony_optimization
%   http://www.scholarpedia.org/article/Ant_colony_optimization
%   http://www.mathworks.com/matlabcentral/fileexchange/15049
%
%   Author: Dr. Kyriakos Deliparaschos <kdelip@mail.ntua.gr>
%   August, 2009
%--------------------------------------------------------------------------
tic
clear all; clc; close all

% Load TSP city files
% -------------------
infile='TSP/att48.tsp';
if ischar(infile)
    fid=fopen(infile,'r');
else
    disp('input file no exist');
    return;
end
if fid<0
    disp('error while open file');
    return;
end

nodeWeight = [];
while feof(fid)==0
    temps=fgetl(fid);
    if strcmp(temps,'')
        continue;
    elseif strncmpi('NAME',temps,4)
        k=findstr(temps,':');
        Name=temps(k+1:length(temps));
    elseif strncmpi('dimension',temps,9)
        k=findstr(temps,':');
        d=temps(k+1:length(temps));
        dimension=str2double(d); %str2num
    elseif strncmpi('EDGE_WEIGHT_SECTION',temps,19)
        formatstr = [];
        for i=1:dimension
            formatstr = [formatstr,'%g '];
        end
        nodeWeight=fscanf(fid,formatstr,[dimension,dimension]);
        nodeWeight=nodeWeight';
    elseif strncmpi('NODE_COORD_SECTION',temps,18) || strncmpi('DISPLAY_DATA_SECTION',temps,20)
        nodeCoord=fscanf(fid,'%g %g %g',[3 dimension])';
    end
end
fclose(fid);

cities = nodeCoord(:,2:3)'; % cities (x,y)

% ACO parameters
% --------------
iter = 2000; % iterations
ants = 200; % number of artificial ants
nodes = length(cities); % number of cities
alpha = 1; % controls the influence of tau(i,j)
beta = 5; % controls the influence of eta(i,j) (typically 1/d(i,j) )
rho = .1; % rate of pheromone evaporation
el = .96; % coefficient of common cost elimination.

% Generate the link length (Euclidean distances) matrix (edges i,j)
% -----------------------------------------------------------------
d = zeros(nodes, nodes); % allocate size
for i = 1:nodes
    for j = 1:nodes
        d(i,j) = sqrt((cities(1,i)-cities(1,j))^2+(cities(2,i)-cities(2,j))^2);
    end
end

% Main loop (ACO execution)
% -------------------------

% preallocate size (execution performance)
initPlace = zeros(ants,1);
eta = zeros(nodes, nodes);
p = zeros(nodes);
meanCost = zeros(1, iter);
minCost = zeros(1, iter);
bestTour = zeros(iter, nodes+1);
iteration = zeros(iter); 
f = zeros(1, ants);
 
for cycle=1:iter % iteration cycles
    
    % Generate initial ants placement
    % -------------------------------
    rand('state',sum(100*clock)); % different values in different MATLAB sessions
    
    for i=1:ants
        % since path is from nest to food use cities-1 to place ants to all
        % nodes except the target (food) node
        initPlace(i) = fix(1+rand*(length(cities)-1));
    end
    
    % Amount of deposited Pheromone
    % -----------------------------
    dtau = zeros(length(cities),length(cities)); % allocate size
    
    % Generate sight matrix
    % ---------------------
    for i = 1:nodes
        for j = 1:nodes
            if d(i,j) == 0
                eta(i,j) = 0;
            else
                eta(i,j) = 1 / d(i,j); % eta, heuristic value
            end
        end
    end
     
    % Primary Pheromone trail value
    % -----------------------------
    tau = 0.0001 * ones(nodes); % tau, pheromone value
    
    % Generate ants tour matrix for a cycle
    % -------------------------------------
    for i = 1:ants
        meta = eta;
        for j = 1:nodes-1 % -1, exclude the target (food) node
            c = initPlace(i,j); % c(i,j), solution component
            meta(:,c) = 0;
            temp = (tau(c,:).^beta).* (meta(c,:).^alpha);
            s = (sum(temp));
            p = (1/s).*temp;
            r = rand;
            s = 0;
            for k = 1:nodes
                s = s + p(k);
                if r <= s
                    initPlace(i,j+1) = k;
                    break
                end
            end
        end
    end
    
    tourMatrix=horzcat(initPlace,initPlace(:,1));
    
    % Ants cost
    % ---------
    for i = 1:ants
        s = 0;
        for j = 1:nodes
            s = s + d(tourMatrix(i,j),tourMatrix(i,j+1));
        end
        f(i) = s;
    end
    cost = f;
    f = f - el * min(f); % elimination of common cost.
    
    % Pheromone trail value update (MAX-MIN Ant System)
    % -------------------------------------------------
    for i = 1:ants
        for j = 1:nodes
            dtau = 1 / f(i); % quantity of pheromone deposited on edge (i,j) by the i-th ant
            tau(tourMatrix(i,j),tourMatrix(i,j+1)) =...
                (1 - rho) * tau(tourMatrix(i,j),tourMatrix(i,j+1)) + dtau;
        end
    end
    
    meanCost(cycle) = mean(cost); % average cost
    [minCost(cycle),number] = min(cost); % minimum cost
    bestTour(cycle,:) = tourMatrix(number,:); % best closed route
    iteration(cycle) = cycle; % log cycles

    % visualize (comment for performance)
    plotCity(cities, tourMatrix(number,:),'r');
    title(['cycle: ',num2str(cycle), ' optimum tour length: ',num2str(min(cost))]);
    pause(0.005) % delay

end % main loop ends here

% visualize

subplot(2,1,2); plot(iteration,meanCost);
title('average of cost (distance) vs. number of cycles');
xlabel('iteration');
ylabel('distance');
[k,l] = min(minCost);
subplot(2,1,1); plotCity(cities, bestTour(l,:),'r');
xlabel('x');ylabel('y');axis('equal');
title(['optimum tour length: ',num2str(k)]);

% Edge selection (Ants probability to move from node i to node j)
% ---------------------------------------------------------------
%prob = ((tau.^alpha).*(dtau^beta)) / sum(sum(((tau.^alpha).*(dtau^beta))));
toc
