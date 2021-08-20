function PlotRocketDiagram(Rocket,Forces)
%PlotRocketDiagram - Plots rocket forces on a diagram
%
% Syntax:  PlotRocketDiagram(Rocket,Forces)
%
% Inputs:
%    Rocket - Rocket parameters
%    Forces - Calculated forces
%    
% Outputs: none
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Conan Omori
% email address: conanomo@alumni.ubc.ca
% November 2020; Last revision: 21-Nov-2020
%
%------------- BEGIN CODE --------------
%% Display Image
RocketDiagram=imread('RocketDiagram.png');
set(gcf,'color','w'); 
imshow(RocketDiagram);

%% Plot Component Names
XPosition=[180 180 180 180 180 180 180 180];
YPosition=[125 262 452 848 1089 1280 1462 1571];
text(XPosition,YPosition,Forces.Components,'HorizontalAlignment','right')

%% Plot Axial Forces
text(600,60,{'Max Axial','Force'},'Color','red','FontWeight','bold','HorizontalAlignment','Center');
XPosition=[600 600 600 600 600 600 600];
YPosition=[207 262 618 1033 1089 1398 1462];
text(XPosition,YPosition,strcat(num2str(max(Forces.AxialLoad,[],2),4),' kN'),'Color','red','HorizontalAlignment','Center')

%% Plot Shear Forces
text(750,60,{'Max Shear','Force'},'Color','#EDB120','FontWeight','bold','HorizontalAlignment','Center');
XPosition=[750 750 750 750 750 750 750];
YPosition=[207 262 618 1033 1089 1398 1462];
[~,XShear]=max(abs(Forces.Shear),[],2);
text(XPosition,YPosition,strcat(num2str(diag(Forces.Shear(:,XShear))/1000,4),' kN'),'Color','#EDB120','HorizontalAlignment','Center');

%% Plot Bending Forces
text(900,60,{'Max Bending','Moment'},'Color','#77AC30','FontWeight','bold','HorizontalAlignment','Center');
XPosition=[900 900 900 900 900 900 900];
YPosition=[207 262 618 1033 1089 1398 1462];
[~,XBending]=max(abs(Forces.Bending),[],2);
text(XPosition,YPosition,strcat(num2str(diag(Forces.Bending(:,XBending)),4),' Nm'),'Color','#77AC30','HorizontalAlignment','Center');
%------------- END OF CODE --------------
