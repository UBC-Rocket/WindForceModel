function Rocket = RocketParameters(ASTOS, Feynman)
%RocketParameters - Extracts information about the rocket design from ASTOS
%and Feynman outputs
%
% Syntax:  Rocket = RocketParameters(ASTOS, Feynman)
%
% Inputs:
%    ASTOS - ASTOS output file
%    Feynman - Feynman output file
%    
% Outputs:
%    Rocket - Structure containing information about the rocket design
%        Rocket.Diameter - Diameter of rocket (m)
%        Rocket.Components - Each component of the rocket
%        Rocket.ComponentLengthContribution - If the corresponding
%         component contributes to the length of the rocket
%        Rocket.ComponentLengths - Length of corresponding component (m)
%        Rocket.ComponentMasses - Mass of corresponding component (kg)
%        Rocket.LOXMass - Mass of LOX as a function of time (kg)
%        Rocket.KeroMass - Mass of fuel as a function of time (kg)
%        Rocket.CG - Rocket Center of Gravity from nosecone tip (m)
%        Rocket.ComponentMassTime - Mass of each rocket component as a function of time (kg)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Conan Omori
% email address: conanomo@alumni.ubc.ca
% November 2020; Last revision: 20-Nov-2020
%
%------------- BEGIN CODE --------------

%% Set vehicle values
Rocket.Diameter=Feynman.Data(find(matches(Feynman.Header(:,1),"Vehicle Diameter")));
Rocket.FinRootChord=Feynman.Data(find(matches(Feynman.Header(:,1),"Fin Root Chord")));
Rocket.FinTipChord=Feynman.Data(find(matches(Feynman.Header(:,1),"Fin Tip Chord")));
Rocket.FinSpan=Feynman.Data(find(matches(Feynman.Header(:,1),"Fin Span")));
Rocket.FinArea=(Rocket.FinRootChord+Rocket.FinTipChord)*Rocket.FinSpan/2;
Rocket.NumberOfFins=Feynman.Data(find(matches(Feynman.Header(:,1),"Number of Fins")));

%% Create component array
Rocket.Components=[...
    "Nose Cone and Payload - Nose Cone";
    "Nose Cone and Payload - Payload Adapter";
    "Nose Cone and Payload - Payload";
    "Nose Cone and Payload - Nose Cone Interface Hull";
    "Avionics and Recovery - Avionics";
    "Avionics and Recovery - Recovery System";
    "Avionics and Recovery - Avionics and Recovery Section Hull";
    "Pressurant - Pressurant Tank";
    "Pressurant - Pressurant Section Hull";
    "Pressurant - Pressurant LOX Interface Hull";
    "Liquid Oxygen - Liquid Oxygen Tank";
    "Liquid Oxygen - LOX Kero Interface Hull";
    "Kerosene - Kerosene Tank";
    "Kerosene - Kero Engine Interface Hull";
    "Propulsion - Engine"];

%% Component length contribution array 
%'True' contributes to rocket length, 'False' does not
Rocket.ComponentLengthContribution=[...
    "True";
    "False";
    "False";
    "False"; %True
    "False";
    "False";
    "True";
    "False";
    "True";
    "False"; %True 
    "True";
    "True";
    "True";
    "True";
    "True"];
    
%% Component length array
Rocket.ComponentLengths=zeros(length(Rocket.Components),1);
for i=1:length(Rocket.Components)
    if matches(Rocket.ComponentLengthContribution(i),"True")
        Rocket.ComponentLengths(i)=Feynman.Data(find(matches(Feynman.Header(:,1),strcat(Rocket.Components(i)," - Length"))));
    end
end

%% Component mass array
Rocket.ComponentMasses=zeros(length(Rocket.Components),1);
for i=1:length(Rocket.Components)
    Rocket.ComponentMasses(i)=Feynman.Data(find(matches(Feynman.Header(:,1),strcat(Rocket.Components(i)," - Mass"))));
end
 
%Manually fix 'Nose Cone Interface Hull' and 'Pressurant LOX Interface
%Hull'

%For components that do not contribute length, add their mass onto the next
%section
for i=1:length(Rocket.ComponentMasses)
    if matches(Rocket.ComponentLengthContribution(i),"False")
        Rocket.ComponentMasses(i+1)=Rocket.ComponentMasses(i)+Rocket.ComponentMasses(i+1);
        Rocket.ComponentMasses(i)=0;
    end
end

%Delete sections that dont contribute to the length of the rocket
Rocket.Components(find(matches(Rocket.ComponentLengthContribution,"False")))=[];
Rocket.ComponentMasses(find(matches(Rocket.ComponentLengthContribution,"False")))=[];
Rocket.ComponentLengths(find(matches(Rocket.ComponentLengthContribution,"False")))=[];
Rocket.ComponentPositions=cumsum(Rocket.ComponentLengths);
Rocket.FinPosition=Rocket.ComponentPositions(find(matches(Rocket.Components,'Kerosene - Kerosene Tank'))); %Fin leading edge starts at the bottom of the Kero Tank


%Calculate mass of LOX and Fuel based on OFRatio and flow rates
PropellantMassFlow=ASTOS.Data(:,find(matches(ASTOS.Header(2,:),"Propellant Mass of Main_Stage of Spaceshot")));
OFRatio=Feynman.Data(find(matches(Feynman.Header(:,1),"OF")));
Rocket.LOXMass=((PropellantMassFlow/(OFRatio+1))*OFRatio)';
Rocket.KeroMass=(PropellantMassFlow/(OFRatio+1))';

%Add on the masses of LOX and Fuel as a function of time
Rocket.ComponentMassesTime=repmat(Rocket.ComponentMasses,1,length(Rocket.LOXMass));
Rocket.ComponentMassesTime(find(matches(Rocket.Components,'Liquid Oxygen - Liquid Oxygen Tank')),:)=Rocket.ComponentMassesTime(find(matches(Rocket.Components,'Liquid Oxygen - Liquid Oxygen Tank')),:)+Rocket.LOXMass;
Rocket.ComponentMassesTime(find(matches(Rocket.Components,'Kerosene - Kerosene Tank')),:)=Rocket.ComponentMassesTime(find(matches(Rocket.Components,'Kerosene - Kerosene Tank')),:)+Rocket.KeroMass;

%% Center of Gravity
%Individual component Center of Gravity (Nosecone tip reference)
Rocket.ComponentCG=cumsum(Rocket.ComponentLengths)-Rocket.ComponentLengths/2;
Rocket.ComponentCG=repmat(Rocket.ComponentCG,1,length(Rocket.LOXMass));

%Find CG of fluids as they drain
LOXCGLimits=[Rocket.ComponentCG(find(matches(Rocket.Components,'Liquid Oxygen - Liquid Oxygen Tank'))) Rocket.ComponentCG(find(matches(Rocket.Components,'Liquid Oxygen - Liquid Oxygen Tank')))+Rocket.ComponentLengths(find(matches(Rocket.Components,'Liquid Oxygen - Liquid Oxygen Tank')))/2];
LOXMassLimits=[max(Rocket.LOXMass) 0];
LOXCG=interp1(LOXMassLimits,LOXCGLimits,Rocket.LOXMass);

KeroCGLimits=[Rocket.ComponentCG(find(matches(Rocket.Components,'Kerosene - Kerosene Tank'))) Rocket.ComponentCG(find(matches(Rocket.Components,'Kerosene - Kerosene Tank')))+Rocket.ComponentLengths(find(matches(Rocket.Components,'Kerosene - Kerosene Tank')))/2];
KeroMassLimits=[max(Rocket.KeroMass) 0];
KeroCG=interp1(KeroMassLimits,KeroCGLimits,Rocket.KeroMass);

Rocket.LOXCG=LOXCG;
Rocket.KeroCG=KeroCG;

%Combine fluids and tanks
LOXTankMass=Rocket.ComponentMassesTime(find(matches(Rocket.Components,'Liquid Oxygen - Liquid Oxygen Tank')),:);
LOXTankCG=Rocket.ComponentCG(find(matches(Rocket.Components,'Liquid Oxygen - Liquid Oxygen Tank')),:);
Rocket.ComponentCG(find(matches(Rocket.Components,'Liquid Oxygen - Liquid Oxygen Tank')),:)=(LOXTankMass.*LOXTankCG+Rocket.LOXMass.*LOXCG)./(LOXTankMass+Rocket.LOXMass);

KeroTankMass=Rocket.ComponentMassesTime(find(matches(Rocket.Components,'Kerosene - Kerosene Tank')),:);
KeroTankCG=Rocket.ComponentCG(find(matches(Rocket.Components,'Kerosene - Kerosene Tank')),:);
Rocket.ComponentCG(find(matches(Rocket.Components,'Kerosene - Kerosene Tank')),:)=(KeroTankMass.*KeroTankCG+Rocket.KeroMass.*KeroCG)./(KeroTankMass+Rocket.KeroMass);

%Calculate Total CG
Rocket.CG=sum(Rocket.ComponentCG.*Rocket.ComponentMassesTime)./sum(Rocket.ComponentMassesTime);

%% Moment of Inertia
AllLengths=repmat(Rocket.ComponentLengths,1,length(Rocket.LOXMass));
ComponentCGDistance=Rocket.ComponentCG-Rocket.CG; %Distance from Component CG to Rocket CG
ComponentI=(1/4)*Rocket.ComponentMassesTime.*((Rocket.Diameter/2).^2+(1/3)*AllLengths.^2);
GlobalComponentI=ComponentI+Rocket.ComponentMassesTime.*ComponentCGDistance.^2; %Parallel Axis Theorem
Rocket.Ixx=sum(GlobalComponentI);
%------------- END OF CODE --------------