%--------------------------------------------------------------------------
% H=PLOTGRAPH(CITYLIST,TRAVELS)
% This routine draws (i) the cities and the connecting tours between them,
% (ii) the current tour length, (iii) and the best tour length so far.
%
%   Author: Dr. Kyriakos Deliparaschos <kdelip@mail.ntua.gr>
%   Initial coding: August, 2010
%--------------------------------------------------------------------------
function PlotGraph(h, options, cycle, number, minCost, cities, tourMatrix, bestCost, bestTour, cost)

if options(1) == 1
    plot(h(1),1:length(bestCost),bestCost,'m');
    title(h(1),['Best tour length so far: ',num2str(bestCost(cycle))]);
else
    title(h(1),['Best tour length so far: ',num2str(bestCost(cycle))]);
end

if options(2) == 1
    plot(h(2),minCost(:,1:cycle),'b');
    title(h(2),['Current tour length: ',num2str(min(cost))]);
else
    title(h(2),['Current tour length: ',num2str(min(cost))]);
end

if options(3) == 1
    plH = plot(h(3),cities(1,tourMatrix(number,:))',cities(2,tourMatrix(number,:))',...
        'c-o',cities(1,bestTour)',cities(2,bestTour)','r-o');
    set(plH,'MarkerEdgeColor','g','MarkerSize',10);
    title(h(3),['Iteration: ',num2str(cycle)]);
    %tH = text(cities(1,:)-0.6,cities(2,:)-.05,num2cell(1:length(cities(1,:))));
    %set(gca,'Visible','on')
    tH = text(cities(1,:)-.05,cities(2,:)-.05,num2cell(1:length(cities(1,:))));
    set(tH,'FontName','Helvetica','FontSize',8, ...
        'FontWeight','normal','FontAngle','oblique');
else
    title(h(3),['Iteration: ',num2str(cycle)]);
end

drawnow

end