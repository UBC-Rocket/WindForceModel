function Forces = AxialForce(Rocket,Global)
%AxialForce - Calculates axial forces at the bottom of each component
%
% Syntax:  Forces = AxialForce(Rocket,Global)
%
% Inputs:
%    Rocket - Rocket parameters
%    Global - Global parameters
%    
% Outputs:
%    Forces - Forces acting on the rocket
%        Forces.Components - Components corresponding to a join in the
%         rocket where a force occurs
%        Forces.Axial - Axial force acting at the bottom of the
%         corresponding component (kN)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Conan Omori
% email address: conanomo@alumni.ubc.ca
% November 2020; Last revision: 17-Nov-2020
%
%------------- BEGIN CODE --------------

%Import values
CumComponentMasses=cumsum(Rocket.ComponentMassesTime);

%Calculate Forces
Forces.Components=Rocket.Components;
Forces.AxialLoad=Global.Drag'+(Global.AxialAcceleration'.*CumComponentMasses)./1000;

%Delete value calculated at bottom of engine, as its not a real force
Forces.AxialLoad(end,:)=[];
%------------- END OF CODE --------------