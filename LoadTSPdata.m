%--------------------------------------------------------------------------
% NODECOORDS=LOADTSPDATA(CITYLIST,TRAVELS)
% This routine loads the TSP data files from TSPLIB.
% http://www.iwr.uni-heidelberg.de/groups/comopt/software/TSPLIB95/
%
%   Usage Examples:
%
%   LoadTSPdata('att48.tsp')
%
%   Author: Dr. Kyriakos Deliparaschos <kdelip@mail.ntua.gr>
%   Initial coding: July, 2010
%--------------------------------------------------------------------------
function [name,comment,dimension,type,nodeCoord] = LoadTSPdata(infile)

if ischar(infile)
    fid=fopen(infile,'r');
else
    disp('input file does not exist');
    return;
end
if fid<0
    disp('error while opening file');
    return;
end

while feof(fid)==0
    temps=fgetl(fid);
    if strcmp(temps,'')
        continue;
    elseif strncmpi('NAME',temps,4)
        k=findstr(temps,':');
        name=temps(k+1:length(temps));
    elseif strncmpi('COMMENT',temps,7)
        k=findstr(temps,':');
        comment=temps(k+1:length(temps));
    elseif strncmpi('DIMENSION',temps,9)
        k=findstr(temps,':');
        d=temps(k+1:length(temps));
        dimension=str2double(d); %str2num
    elseif strncmpi('EDGE_WEIGHT_TYPE',temps,16)
        k=findstr(temps,':');
        type=temps(k+1:length(temps));
    elseif strncmpi('NODE_COORD_SECTION',temps,18) || strncmpi('DISPLAY_DATA_SECTION',temps,20)
        nodeCoord=fscanf(fid,'%g %g %g',[3 dimension])';
    end
end

fclose(fid);

end