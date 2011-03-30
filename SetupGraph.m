%--------------------------------------------------------------------------
% H=SETUPGRAPH
% This routine sets up the required figure and axes for the GraphPlot 
% function and returns the axes handles (3).
%
%   Usage Examples:
%
%   h = SetupGraph
%
%   Author: Dr. Kyriakos Deliparaschos <kdelip@mail.ntua.gr>
%   Initial coding: August, 2010
%--------------------------------------------------------------------------
function [h, options] = SetupGraph

openfig('ACOGUI.fig');

options1 = get(findobj('tag','checkbox1'),'Value');
options2 = get(findobj('tag','checkbox2'),'Value');
options3 = get(findobj('tag','checkbox3'),'Value');
options4 = get(findobj('tag','pushbutton1'),'Value');

options = [options1 options2 options3 options4];

h(1)=findobj('tag','axes1');
h(2)=findobj('tag','axes2');
h(3)=findobj('tag','axes3');

end