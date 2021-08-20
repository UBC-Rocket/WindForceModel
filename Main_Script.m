%Main_Script - Derives force model of rocket
%
% Inputs:
%    Feynman.Version - Selects most up to date Feynman version
%    Global.WindGustAssumption - Sets wind gust assumption
%
% Other m-files required: none
% Subfunctions: RocketParameters, AxialForce, BendingForce, PlotRocketDiagram
% MAT-files required: none
% Other files required: Feynman Outputs.xlsx, ASTOS Outputs.xlsx
%
% Adapted from: AspireSpace - Rocket Vehicle Loads and Airframe Design
%
% Author: Conan Omori
% email address: conanomo@alumni.ubc.ca
% November 2020; Last revision: 23-Nov-2020
%
%------------- BEGIN CODE --------------
%% Setup workspace
clear;
clc;
close all;

%% Import ASTOS and Feynman Outputs
%Ensure you delete the first row with the random number in Feynman
Feynman.Version='10';
[Feynman.Data,Feynman.Header,Feynman.Raw]=xlsread('required_files/Feynman Outputs.xlsx',Feynman.Version,'A:C');
[ASTOS.Data,ASTOS.Header,ASTOS.Raw]=xlsread('required_files/ASTOS Outputs.xlsx');

%% Rocket Dimensions and Lengths
Rocket=RocketParameters(ASTOS,Feynman);

%% Global Parameters
Global.Altitude=ASTOS.Data(:,find(matches(ASTOS.Header(2,:),'Altitude of Spaceshot at Earth')));
Global.Time=ASTOS.Data(:,find(matches(ASTOS.Header(2,:),'Time')));
Global.Thrust=ASTOS.Data(:,find(matches(ASTOS.Header(2,:),'Total Thrust of Spaceshot')));
Global.Drag=ASTOS.Data(:,find(matches(ASTOS.Header(2,:),'Drag Force of Spaceshot')));
Global.AxialAcceleration=ASTOS.Data(:,find(matches(ASTOS.Header(2,:),'Thrust Acceleration of Spaceshot')));
Global.Density=ASTOS.Data(:,find(matches(ASTOS.Header(2,:),'Atmospheric Density of Spaceshot')));
Global.Velocity=ASTOS.Data(:,find(matches(ASTOS.Header(2,:),'Flight Path Speed of Spaceshot')))*1000;
Global.MachNumber=ASTOS.Data(:,find(matches(ASTOS.Header(2,:),'Mach Number of Spaceshot')));

%% Axial Loads
Forces=AxialForce(Rocket,Global);

%% Bending Loads
Global.WindGustAssumption=10; %Assumed maximum wind gust at any altitude (m/s)
Forces=BendingForce(Rocket,Global,Forces);

%% Plot Values on Image
PlotRocketDiagram(Rocket,Forces)
%------------- END OF CODE --------------
