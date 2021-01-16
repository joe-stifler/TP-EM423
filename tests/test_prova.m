%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The beam dimentions             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You should specify the beam width %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - width in meters                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beam_width = 2;

radius1 = 0

radius2 = 0.0125

yield_strength = 250 * 1e6

poisson_coef = 0.292

section_area = 4.90874 * 1e-4

shear_module = 250 * 1e9;

polar_momentum_inertia = 3.83495 * 1e-8;

young_module = 207 * 1e9;

momentum_inertia = 1.9175 * 1e-8;

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
vertical_forces(length(vertical_forces) + 1) = Force(1, -1000);

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
supports(length(supports) + 1) = Support(0, SupportType().Fixed);
