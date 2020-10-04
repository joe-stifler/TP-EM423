addpath('datatypes');
addpath('solver');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input initial values. Do not modify them %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beam_width = 0;
torques(1) = Force(0, 0);
vertical_forces(1) = Force(0, 0);
horizontal_forces(1) = Force(0, 0);
vertical_dist_forces(1) = DistForce(0, 0, @(x)(0));
vertical_supports(1) = Support(0, SupportType().Dummy);
horizontal_supports(1) = Support(0, SupportType().Dummy);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The beam dimentions             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You should specify the beam width %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - width in meters                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beam_width = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The vertical forces             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Force(X_position, Magnitude)    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - X_position should be in meters  %
% - Magnitude should be in Newtons  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Magnitude > 0: pointing up      %
% - Magnitude < 0: pointing down    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vertical_forces(length(vertical_forces) + 1) = Force(1, 30);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The horizontal forces           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Force(0, Magnitude)             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Y_position should be in meters  %
% - Magnitude should be in Newtons  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Magnitude > 0: pointing right   %
% - Magnitude < 0: pointing left    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
horizontal_forces(length(horizontal_forces) + 1) = Force(0, 30);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The torque forces (horizontal only) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Force(0, Magnitude)               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Magnitude should be in Newtons  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Magnitude > 0: pointing right     %
% - Magnitude < 0: pointing left      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
torques(length(torques) + 1) = Force(0, 30);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  The distributed vertical forces         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - DistForce(                             %
%       X_begin_position,                  %
%       X_end_position,                    %
%       polynomial_function                %
%   )                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - X_begin_position in meters             %
% - X_end_position in meters               %
% - polynomial_function in Newtons         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - polynomial_function > 0: pointing up   %
% - polynomial_function < 0: pointing down %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vertical_dist_forces(length(vertical_dist_forces) + 1) = DistForce(1, 30, @(x)(4 * x ./ x));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  The horizontal supports         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Support(X_position, SupportType) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SupportType can be:              %
%     - SupportType().Roller       %
%     - SupportType().Pinned       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
horizontal_supports(length(horizontal_supports) + 1) = Support(10, SupportType().Roller);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  The vertical supports           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Support(X_position, SupportType) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SupportType can be:              %
%     - SupportType().Fixed        %
%     - SupportType().Pinned       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vertical_supports(length(vertical_supports) + 1) = Support(10, SupportType().Roller);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve the resmat given problem %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res_mat_1d_solver(
    beam_width,
    vertical_forces,
    horizontal_forces,
    torques,
    vertical_dist_forces,
    horizontal_supports,
    vertical_supports
)