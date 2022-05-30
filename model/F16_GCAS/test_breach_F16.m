%% Testing Breach interface to F16 model


%% Add all needed paths (if not manually added)
close all; clear; clc;
addpath(genpath('AeroBenchVV-master'));
warning('off', 'f16:no_analysis');

%%
sg = f16_signal_gen();
B0 = BreachSignalGen(sg);
B0.SetTime(0:.01:15);

%% Nominal simulation
B1 = B0.copy();
B1.Sim();
figure;
B1.PlotSignals();

%% Messing with initial altitude
B2 = B0.copy();
B2.SetParam('altg', 3850:10:4000);
B2.Sim();
figure;
B2.PlotSignals();

%% Checking requirement
STL_ReadFile('requirements_breach.stl');
R = BreachRequirement(phi);
R.Eval(B2);
F = BreachSamplesPlot(R); 
F.set_x_axis('altg');  % interesting how GCAS is not monotonic with initial altitude


