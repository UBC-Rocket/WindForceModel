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

%% Import SIM and Feynman Outputs
%Ensure you delete the first row with the random number in Feynman
Feynman.Version='14';
[Feynman.Data,Feynman.Header,Feynman.Raw]=xlsread('required_files/Feynman Outputs.xlsx',Feynman.Version,'A:C');
%[ASTOS.Data,ASTOS.Header,ASTOS.Raw]=xlsread('required_files/F14_ASTOS_output.xlsx');
[SIM.Data,SIM.Header,SIM.RAW] = xlsread('required_files/F15_sim_results.xlsx');
%% Rocket Dimensions and Lengths
Rocket=RocketParameters(SIM,Feynman);

%% Global Parameters
Global.Altitude=SIM.Data(:,find(matches(SIM.Header(1,:),'Altitude (m)')));
Global.Time=SIM.Data(:,find(matches(SIM.Header(1,:),'Times (s)')));
Global.Thrust=SIM.Data(:,find(matches(SIM.Header(1,:),'Thrust (N)')));
Global.Drag=SIM.Data(:,find(matches(SIM.Header(1,:),'Drag (N)')));
Global.AxialAcceleration=SIM.Data(:,find(matches(SIM.Header(1,:),'Acceleration (m/s**2)')));
Global.Density=SIM.Data(:,find(matches(SIM.Header(1,:),'Air Density (kg/m**3)')));
Global.Velocity=SIM.Data(:,find(matches(SIM.Header(1,:),'Velocity (m/s)')));
Global.MachNumber=SIM.Data(:,find(matches(SIM.Header(1,:),'Mach Number')));

%% Axial Loads
Forces=AxialForce(Rocket,Global);

%% Bending Loads
Global.WindGustAssumption=9; %Assumed maximum wind gust at any altitude (m/s). See https://docs.google.com/document/d/1Wv5SpJzUQg2zge78pJnqNIuGVdg3IigyAu3tGeo02Qg/edit#
Forces=BendingForce(Rocket,Global,Forces);

%% Plot Values on Image
axial_drag_uncertainty_factor = 1.0;
structure_safety_factor = 1.0;
PlotRocketDiagram(Rocket,Forces, structure_safety_factor, axial_drag_uncertainty_factor)
%------------- END OF CODE --------------
