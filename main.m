addpath('datatypes');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The beam dimentions   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You should specify the  %
% beam [width, height]    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - width in meters       %
% - height in meters      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
beam_dimention = [4, 0];

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
vertical_forces(1) = Force(1, 30);
vertical_forces(2) = Force(1, 31);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The horizontal forces           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Force(Y_position, Magnitude)    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Y_position should be in meters  %
% - Magnitude should be in Newtons  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Magnitude > 0: pointing right   %
% - Magnitude < 0: pointing left    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
horizontal_forces(1) = Force(1, 30);
horizontal_forces(2) = Force(1, 31);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    The torque forces              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Force(Y_position, Magnitude)    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Magnitude > 0: pointing right   %
% - Magnitude < 0: pointing left    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
torques(1) = Force(1, 30);
torques(2) = Force(1, 31);
torques(3) = Force(1, 32);

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
vertical_dist_forces(1) = DistForce(1, 30, @(x)(4 * x));
vertical_dist_forces(2) = DistForce(1, 31, @(x)(4 * x * x  + y));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  The horizontal supports         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Support(X_position, SupportType) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SupportType can be:              %
%     - SupportType().Fixed        %
%     - SupportType().Roller       %
%     - SupportType().Pinned       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
horizontal_supports(1) = Support(10, SupportType().Roller);
