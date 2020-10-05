%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The beam dimentions             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You should specify the beam width %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - width in meters                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beam_width = 6;

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
% vertical_forces(length(vertical_forces) + 1) = Force(3, -5000);

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
% horizontal_forces(length(horizontal_forces) + 1) = Force(0, -3000);

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
% torques(length(torques) + 1) = Force(0, 30);

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
vertical_dist_forces(length(vertical_dist_forces) + 1) = DistForce(0, 1.5, @(x)(-6000), @(x)(-6000 * x));
vertical_dist_forces(length(vertical_dist_forces) + 1) = DistForce(1.5, 4.5, @(x)(-9000), @(x)(-9000 * x));
vertical_dist_forces(length(vertical_dist_forces) + 1) = DistForce(4.5, 6.0, @(x)(-3000), @(x)(-3000 * x));

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
supports(length(supports) + 1) = Support(4.5, SupportType().Roller);
supports(length(supports) + 1) = Support(1.5, SupportType().Pinned);
