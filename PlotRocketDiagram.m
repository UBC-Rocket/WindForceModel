function PlotRocketDiagram(Rocket,Forces,structure_safety_factor,axial_drag_uncertainty_factor)
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
RocketDiagram=imread('Wind Force Model Diagram.png');
set(gcf,'color','w'); 
imshow(RocketDiagram);

%% Plot Component Names
%XPosition=[1100 1100 1100 1100 1100 1100 1100 1100 1100 1100 1100]; %remove for no RCS
%YPosition=[170 300 340 405 510 600 770 940 1090 1230 1340]; %remove for no RCS
XPosition=[1100 1100 1100 1100 1100 1100 1100 1100 1100 1100];
YPosition=[170 300 405 510 600 770 940 1090 1230 1340];
text(XPosition,YPosition,Forces.Components,'HorizontalAlignment','right')

%% Text Placement Values
col_1 = 1450;
col_2 = 1650;
col_3 = 1900;
header_row = 140;
%rows = [280 320 370 430 565 615 910 960 1180 1260]; %remove for no RCS
rows = [280 370 430 565 615 910 960 1180 1260];

%% Plot Axial Forces
text(col_1,header_row,{'Max Axial','Force'},'Color','red','FontWeight','bold','HorizontalAlignment','Center');
%XPosition = [col_1 col_1 col_1 col_1 col_1 col_1 col_1 col_1 col_1 col_1];%remove for no RCS
XPosition = [col_1 col_1 col_1 col_1 col_1 col_1 col_1 col_1 col_1];
YPosition = rows;
forces = max(Forces.AxialLoad,[],2);
forces = forces.*axial_drag_uncertainty_factor.*structure_safety_factor;
text(XPosition,YPosition,strcat(num2str(forces,4),' kN'),'Color','red','HorizontalAlignment','Center')

%% Plot Shear Forces
text(col_2,header_row,{'Max Shear','Force'},'Color','#EDB120','FontWeight','bold','HorizontalAlignment','Center');
%XPosition=[col_2 col_2 col_2 col_2 col_2 col_2 col_2 col_2 col_2 col_2]; %remove for no RCS
XPosition=[col_2 col_2 col_2 col_2 col_2 col_2 col_2 col_2 col_2]; 
YPosition=rows;
forces=max(abs(Forces.Shear),[],2);
forces = forces.*structure_safety_factor;
text(XPosition,YPosition,strcat(num2str(forces/1000,4),' kN'),'Color','#EDB120','HorizontalAlignment','Center');

%% Plot Bending Forces
text(col_3,header_row,{'Max Bending','Moment'},'Color','#77AC30','FontWeight','bold','HorizontalAlignment','Center');
%XPosition=[col_3 col_3 col_3 col_3 col_3 col_3 col_3 col_3 col_3 col_3]; %remove for no RCS
XPosition=[col_3 col_3 col_3 col_3 col_3 col_3 col_3 col_3 col_3];
YPosition=rows;
[~,XBending]=max(abs(Forces.Bending),[],2);
forces = diag(Forces.Bending(:,XBending));
forces = forces.*structure_safety_factor;
text(XPosition,YPosition,strcat(num2str(forces,4),' Nm'),'Color','#77AC30','HorizontalAlignment','Center');
%------------- END OF CODE --------------
