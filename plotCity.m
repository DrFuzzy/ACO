%--------------------------------------------------------------------------
% H=PLOTCITY(CITYLIST,TRAVELS)
% This routine draws the cities and the connecting tours between them
%
%   Usage Examples:
%
%   plotCity([1 4 6 78 43 98;1 4 6 9 2 43],[1 2 3 4 5 6 1],'b')
%
%   Author: Kyriakos Deliparaschos <kdelip@mail.ntua.gr>   
%   Created: August, 2009
%
%   revisions:
%   Date  Version Description
%   08/09 1.0     created
%--------------------------------------------------------------------------
function H = plotCity(cityList, travels, routeColor)

if nargin < 2
    error('Please see help for INPUT DATA.');
elseif size(travels,2) > size(cityList,2) + 1
    error('Redundant connection tours! - Please see help for INPUT DATA.');
end;

xd = zeros(size(travels,1),size(travels,2)); % allocate size
yd = zeros(size(travels,1),size(travels,2)); % allocate size

H = plot(cityList,'o'); % draw cities
set(H,'MarkerEdgeColor','g','MarkerSize',9);

 %for i = 1:size(travels,1)
    for j = 1:size(travels,2)
        if j <= size(cityList,2)
            text(cityList(1,j)-0.6,cityList(2,j)-.05,num2str(j));
        end
        xd(:,j) = cityList(1,travels(:,j));
        yd(:,j) = cityList(2,travels(:,j));
    end
 %end

set(H,'XData',xd(1,:),'YData',yd(1,:));
H = line(xd', yd','Color', routeColor); % draw tours
