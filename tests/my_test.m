%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The beam dimentions             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You should specify the beam width %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - width in meters                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beam_width = 5;

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
vertical_forces(length(vertical_forces) + 1) = Force(0, -75000);

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
horizontal_forces(length(horizontal_forces) + 1) = Force(0, -10000);

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
torques(length(torques) + 1) = Force(0, 900);

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
vertical_dist_forces(length(vertical_dist_forces) + 1) = DistForce(2, 5, "2500, -12500");

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
supports(length(supports) + 1) = Support(2, SupportType().Roller);
supports(length(supports) + 1) = Support(5, SupportType().Pinned);
