%--------------------------------------------------------------------------
% H=PLOTGRAPH(CITYLIST,TRAVELS)
% This routine draws (i) the cities and the connecting tours between them,
% (ii) the current tour length, (iii) and the best tour length so far.
%
%   Author: Dr. Kyriakos Deliparaschos <kdelip@mail.ntua.gr>
%   Initial coding: August, 2010
%--------------------------------------------------------------------------
function PlotGraph(h, cycle, number, minCost, cities, tourMatrix, bestCost, bestTour, cost)
global flag;

if flag == 1
    
    plot(h(1),minCost(:,1:cycle),'b');
    title(h(1),['Current tour length: ',num2str(min(cost))]);
    
    plot(h(2),bestCost,'m');
    title(h(2),['Best tour length so far: ',num2str(bestCost(cycle))]);
    
    plH = plot(h(3),cities(1,tourMatrix(number,:))',cities(2,tourMatrix(number,:))',...
        'c-o',cities(1,bestTour)',cities(2,bestTour)','r-o');
    set(plH,'MarkerEdgeColor','g','MarkerSize',9);
    title(h(3),['Iteration: ',num2str(cycle)]);
    text(cities(1,:)-0.6,cities(2,:)-.05,num2cell(1:length(cities(1,:))));
    
    
    
else
    
    title(h(2),['Best tour length so far: ',num2str(bestCost(cycle))]);
    
    
end

drawnow

end