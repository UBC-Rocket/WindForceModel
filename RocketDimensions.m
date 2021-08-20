function Rocket = RocketParameters(ASTOS, Feynman)

Rocket.Diameter=Feynman.Data(find(matches(Feynman.Header(:,1),'Vehicle Diameter')));
Rocket.Lengths=...
    {'Nosecone Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Nose Cone and Payload - Nose Cone - Length')))
     'Nosecone Interface Hull Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Nose Cone and Payload - Nose Cone Interface Hull - Length')))
     'Payload Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Nose Cone and Payload - Payload - Length')))
     'Payload Adapter Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Nose Cone and Payload - Payload Adapter - Length')))
     'Avionics Recovery Section Hull Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Avionics and Recovery - Avionics and Recovery Section Hull - Length')))
     'Avionics Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Avionics and Recovery - Avionics - Length')))
     'Recovery Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Avionics and Recovery - Recovery System - Length')))
     'Pressurant Section Hull Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Pressurant - Pressurant Section Hull - Length')))
     'LOX Tank Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Liquid Oxygen - Liquid Oxygen Tank - Length')))
     'LOX Kero Interface Hull Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Liquid Oxygen - LOX Kero Interface Hull - Length')))
     'Kero Tank Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Kerosene - Kerosene Tank - Length')))
     'Kero Engine Interface Hull Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Kerosene - Kero Engine Interface Hull - Length')))
     'Engine Length',Feynman.Data(find(matches(Feynman.Header(:,1),'Propulsion - Engine - Length')))};
Rocket.ComponentMasses=...
    {'Nosecone Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Nose Cone and Payload - Nose Cone - Mass')))
     'Nosecone Interface Hull Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Nose Cone and Payload - Nose Cone Interface Hull - Mass')))
     'Payload Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Nose Cone and Payload - Payload - Mass')))
     'Payload Adapter Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Nose Cone and Payload - Payload Adapter - Mass')))
     'Avionics Recovery Section Hull Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Avionics and Recovery - Avionics and Recovery Section Hull - Mass')))
     'Avionics Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Avionics and Recovery - Avionics - Mass')))
     'Recovery Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Avionics and Recovery - Recovery System - Mass')))
     'Pressurant Section Hull Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Pressurant - Pressurant Section Hull - Mass')))
     'LOX Tank Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Liquid Oxygen - Liquid Oxygen Tank - Mass')))
     'LOX Kero Interface Hull Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Liquid Oxygen - LOX Kero Interface Hull - Mass')))
     'Kero Tank Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Kerosene - Kerosene Tank - Mass')))
     'Kero Engine Interface Hull Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Kerosene - Kero Engine Interface Hull - Mass')))
     'Engine Mass',Feynman.Data(find(matches(Feynman.Header(:,1),'Propulsion - Engine - Mass')))};
 
 PropellantMassFlow=ASTOS.Data(:,find(matches(ASTOS.Header(2,:),'Propellant Mass of Main_Stage of Spaceshot')));
 OFRatio=Feynman.Data(find(matches(Feynman.Header(:,1),'OF')));
 
 Rocket.LOXMass=(PropellantMassFlow/(OFRatio+1))*OFRatio;
 Rocket.KeroMass=(PropellantMassFlow/(OFRatio+1));

     