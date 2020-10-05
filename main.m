addpath('datatypes');
addpath('solver');
addpath('tests');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input initial values. Do not modify them                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beam_width = 0;
torques(1) = Force(0, 0);
vertical_forces(1) = Force(0, 0);
horizontal_forces(1) = Force(0, 0);
supports(1) = Support(0, SupportType().Dummy);
vertical_dist_forces(1) = DistForce(0, 0, @(x)(0), @(x)(0));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add the input file here
aula2_ex3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve the resmat given problem %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[v_forces, h_forces, t_forces, m_forces] = lib_resmat.res_mat_1d_solver(
    beam_width,
    vertical_forces,
    horizontal_forces,
    torques,
    vertical_dist_forces,
    supports
);

output_file(v_forces, h_forces, t_forces, m_forces);