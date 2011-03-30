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
function h = SetupGraph

scrsz = get(0,'ScreenSize');
fh = figure('Position',[scrsz(3)/4 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2]);
%set(fh,'renderer','opengl')
h(1) = axes('Position',[.03 .04 .44 .4]);
h(2) = axes('Position',[.03 .54 .44 .4]);
h(3) = axes('Position',[.51 .04 .47 .9]);
cbh = uicontrol(fh,'Style','checkbox',...
                'String','Animation',...
                'Value',0,'Position',[30 20 130 20],...
                'callback',@checkbox1_Callback);
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global flag;
flag = get(hObject,'Value');
end