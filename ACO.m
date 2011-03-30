% Ant Colony Optimization (ACO)
%
%   Based on ACO resources found at:
%   http://en.wikipedia.org/wiki/Ant_colony_optimization
%   http://www.scholarpedia.org/article/Ant_colony_optimization
%   http://www.mathworks.com/matlabcentral/fileexchange/15049
%
%   Author: Dr. Kyriakos Deliparaschos <kdelip@mail.ntua.gr>
%   Initial coding: August, 2009
%--------------------------------------------------------------------------
tic
clear all; clc; close all

% Load TSP data files
% -------------------
[name,comment,dimension,type,nodeCoord] = LoadTSPdata('TSP/ulysses22.tsp');
cities = nodeCoord(:,2:3)'; % cities (x,y)

% ACO parameters
% --------------
iter = 1000; % iterations
ants = length(cities); % number of artificial ants
nodes = length(cities); % number of cities
alpha = 0.1; % controls the influence of tau(i,j)
beta = 10; % controls the influence of eta(i,j) (typically 1/d(i,j) )
rho = .65; % rate of pheromone evaporation
el = .96; % coefficient of common cost elimination.

% Generate the link length (Euclidean distances) matrix (edges i,j)
% -----------------------------------------------------------------
d = squareform(pdist(cities','euclidean')); % (pdist depends on statistics toolbox)

% Main loop (ACO execution)
% -------------------------

% preallocate size (execution performance)
eta = zeros(nodes, nodes);
p = zeros(nodes);
minCost = zeros(1, iter);
bestTour = zeros(iter, nodes+1);
f = zeros(1, ants);
dtau = zeros(nodes,nodes); % amount of deposited Pheromone

% Pregenerate initial ants placement for each cycle (all)
% -------------------------------------------------------
rand('state',sum(100*clock)); % different values in different MATLAB sessions
% since path is from nest to food use nodes-1 to place ants to all
% nodes except the target (food) node
initPlaceAll = fix(1+rand(ants,iter)*(nodes-1));

% Generate sight matrix
% ---------------------
eta(d~=0)=1./d(d~=0); % eta, heuristic value

% pre-setup figures and axes - (comment for performance)
h = SetupGraph;

for cycle=1:iter % iteration cycles
    
    % Pick initial ants placement for the current cycle
    % -------------------------------------------------
    initPlace = initPlaceAll(:,cycle);
    
    % Primary Pheromone trail value (Initialize Pheromone trails)
    % -----------------------------------------------------------
    tau = 0.0001 * ones(nodes); % tau, pheromone value
    
    % Generate ants tour matrix for a cycle - ConstructAntSolutions
    % ant(i).visited(j)
    % -------------------------------------------------------------
    for i = 1:ants
        meta = eta;
        for j = 1:nodes-1 % -1, exclude the target (food) node
            c = initPlace(i,j); % c(i,j), solution component
            meta(:,c) = 0; % denotes that the city has not yet been visited
            temp = (tau(c,:).^alpha).* (meta(c,:).^beta);
            s = (sum(temp));
            p = (1/s).*temp;
            r = rand;
            s = 0; % empty partial solution
            for k = 1:nodes
                s = s + p(k); % extend partial solution
                if r <= s
                    initPlace(i,j+1) = k;
                    break
                end
            end
        end
    end
    
    tourMatrix=horzcat(initPlace,initPlace(:,1));
    tourMatrix2=sub2ind(size(d),tourMatrix(:,1:end-1),tourMatrix(:,2:end));
    
    % Ants cost (ApplyLocalSearch - daemon actions optional)
    % ------------------------------------------------------
    f = sum(d(tourMatrix2),2)';
    cost = f;
    f = f - el * min(f); % elimination of common cost.
    
    % Pheromone trail value update (MAX-MIN Ant System) - UpdatePheromones
    % --------------------------------------------------------------------
    dtau = 1 ./ f; % quantity of pheromone deposited on edge (i,j) by the i-th ant
    
    for i = 1:ants
        for j = 1:nodes
            tau(tourMatrix(i,j),tourMatrix(i,j+1)) =...
                (1 - rho) * tau(tourMatrix(i,j),tourMatrix(i,j+1)) + dtau(i);
        end
    end
    
    [minCost(cycle),number] = min(cost); % minimum cost

    % sample & hold best closed tour
    if cycle == 1
        a = min(cost);
        bestTour = tourMatrix(number,:); % best closed route/cycle
    end
    
    if a > min(cost)
        a = min(cost);
        bestTour = tourMatrix(number,:); % best closed route/cycle
    end
    bestCost(cycle) = a;

    % visualize (comment for performance)
    PlotGraph(h, cycle, number, minCost, cities, tourMatrix, bestCost, bestTour, cost);
    
end % main loop ends here

%PlotGraph(h, cycle, number, minCost, cities, tourMatrix, bestCost, bestTour, cost);

% Edge selection (Ants probability to move from node i to node j)
% ---------------------------------------------------------------
%prob = ((tau.^alpha).*(dtau^beta)) / sum(sum(((tau.^alpha).*(dtau^beta))));
toc