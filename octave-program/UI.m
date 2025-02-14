classdef UI
    properties
        f;
        data_beam_width;
        data_torques;
        data_vertical_forces;
        data_horizontal_forces;
        data_supports;
        data_vertical_dist_forces;
        data_num_steps;
        young_module;
        momentum_inertia;
        shear_module;
        polar_momentum_inertia;
        yield_strength;
        section_area;
        radius1;
        radius2;
        poisson_coef;
    end

    methods
        function obj = UI(args)
            warning('off','all');

            addpath('./datatypes');
            addpath('./solver');

            % Load my data
            radius1 = 0;
            radius2 = 0;
            beam_width = 0;
            young_module = 1;
            section_area = 0;
            yield_strength = 1;
            momentum_inertia = 1;
            torques(1) = Force(0, 0);
            shear_module = 1;
            poisson_coef = 0;
            polar_momentum_inertia = 1;
            vertical_forces(1) = Force(0, 0);
            horizontal_forces(1) = Force(0, 0);
            supports(1) = Support(0, SupportType().Dummy);
            vertical_dist_forces(1) = DistForce(0, 0, "0");

            % Add the input file here
            if length(args) > 0
                run(args);
            end

            obj.poisson_coef = poisson_coef;
            obj.radius1 = radius1;
            obj.radius2 = radius2;
            obj.section_area = section_area;
            obj.yield_strength = yield_strength;
            obj.data_num_steps = 100;
            obj.data_beam_width = beam_width;
            obj.data_torques = torques;
            obj.young_module = young_module;
            obj.momentum_inertia = momentum_inertia;
            obj.data_horizontal_forces = horizontal_forces;
            obj.data_vertical_forces = vertical_forces;
            obj.data_supports = supports;
            obj.shear_module = shear_module;
            obj.polar_momentum_inertia = polar_momentum_inertia;
            obj.data_vertical_dist_forces = vertical_dist_forces;
        end

        function solve(obj)
            solve_problem(obj)
        end

        function solve_tension(obj, point_ref)
            solve_problem_tension(obj, point_ref)
        end

        function build(obj)
            close all;
            clear h;
            
            screen_size = get(0, 'ScreenSize');

            obj.f = figure('Position', screen_size);

            num_columns = 8 + 2;
            num_lines = 17 + 3;

            % Properties
            view_width = (screen_size(3) - 80) / num_columns;
            component_height = (screen_size(4) - 160) / num_lines;
            
            first_column = 10;
            second_column = first_column + view_width + 10;
            third_column = second_column + view_width + 10;
            fourth_column = third_column + view_width + 10;
            fifth_column = fourth_column + view_width + 10;
            sixth_column = fifth_column + view_width + 10;
            seventh_column = sixth_column + view_width + 10;
            eight_column = seventh_column + view_width + 10;
            ninth_column = eight_column + view_width + 10;

            zero_line = screen_size(4) - component_height - 10;
            first_line = zero_line - component_height - 10;
            second_line = first_line - component_height - 10;
            third_line = second_line - component_height - 10;
            fourth_line = third_line - component_height - 10;
            fifth_line = fourth_line - component_height - 10;
            sixth_line = fifth_line - component_height - 10;
            seventh_line = sixth_line - component_height - 10;
            eight_line = seventh_line - component_height - 10;
            ninth_line = eight_line - component_height - 10;
            tenth_line = ninth_line - component_height - 10;
            eleventh_line = tenth_line - component_height - 10;
            twelfth_line = eleventh_line - component_height - 10;
            thirteenth_line = twelfth_line - component_height - 10;
            fourteenth_line = thirteenth_line - component_height - 10;
            fifteenth_line = fourteenth_line - component_height - 10;

            text_dist_force_begin_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Conventions: ",
                "position",
                [first_column zero_line view_width component_height]
            );

            text_dist_force_begin_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Force Upward (^): positive",
                "position",
                [second_column zero_line 2 * view_width + 10 component_height]
            );

            text_dist_force_begin_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Force Downward (V): Negative",
                "position",
                [fourth_column zero_line 2 * view_width + 10 component_height]
            );

            text_dist_force_begin_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Force Pointing Right (->): Positive",
                "position",
                [sixth_column zero_line 2 * view_width component_height]
            );

            text_dist_force_begin_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Force Pointing Left (<-): Negative",
                "position",
                [eight_column zero_line 2 * view_width + 10 component_height]
            );



            % Dist forces labels
            text_dist_force_begin_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Start [m]",
                "position",
                [second_column third_line view_width component_height]
            );

            text_dist_force_end_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "End [m]",
                "position",
                [third_column third_line view_width component_height]
            );

            text_dist_force_coeficients = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Polynomial Coefficients",
                "position",
                [fourth_column third_line view_width component_height]
            );  
            
            text_dist_force_coeficients = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Distributed Forces Added",
                "position",
                [sixth_column third_line 4 * view_width + 30 component_height]
            );  

            % Dist forces input
            text_dist_force_description = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Distribuited forces: ",
                "position",
                [first_column fourth_line view_width 2 * component_height + 10]
            ); 

            edit_dist_force_begin = uicontrol (
                obj.f,
                "style",
                "edit",
                "string",
                "3",
                "position",
                [second_column fourth_line view_width component_height]
            );

            edit_dist_force_end = uicontrol (
                obj.f,
                "style",
                "edit",
                "string",
                "6",
                "position",
                [third_column fourth_line view_width component_height]
            );

            edit_dist_force_coeficients = uicontrol (
                obj.f,
                "style",
                "edit",
                "string",
                "2500, -15000",
                "position",
                [fourth_column fourth_line view_width component_height]
            );

            % Dist forces view
            view_dist_force_begin = uicontrol (
                obj.f,
                "style",
                "edit",
                "position",
                [sixth_column fourth_line view_width * 2 component_height]
            );

            % Dist forces add button
            button_add_dist_force = uicontrol(
                obj.f,
                "string",
                "Add Dist. Force",
                "callback",
                {@getDistForces, edit_dist_force_begin, edit_dist_force_end, edit_dist_force_coeficients, view_dist_force_begin},
                "position",
                [fifth_column fourth_line view_width component_height]
            );

            % Dist forces add button
            button_clear_dist_force = uicontrol(
                obj.f,
                "string",
                "Clear Distributed Forces",
                "callback",
                {@clearDistForces,edit_dist_force_begin, edit_dist_force_end, edit_dist_force_coeficients, view_dist_force_begin},
                "position",
                [eight_column fourth_line 2 * view_width + 10 component_height]
            );


            % Rectangular Beam
            text_rec_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Rectangular Beam:",
                "position",
                [first_column tenth_line view_width 2 * component_height + 10],
                "enable",
                "inactive"
            );

            text_rec_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Width [m]: ",
                "position",
                [second_column ninth_line view_width component_height],
                "enable",
                "inactive"
            );

            text_rec_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Height [m]: ",
                "position",
                [third_column ninth_line view_width component_height],
                "enable",
                "inactive"
            );

            text_rec_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Depth [m]: ",
                "position",
                [fourth_column ninth_line view_width component_height],
                "enable",
                "inactive"
            );

            text_rec_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Beam Properties",
                "position",
                [sixth_column ninth_line 4 * view_width + 30 component_height],
                "enable",
                "inactive"
            );

            edit_rec_beam_width = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "6",
                "position",
                [second_column tenth_line view_width component_height]
            );

            edit_rec_beam_height = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "0.4",
                "position",
                [third_column tenth_line view_width component_height]
            );

            edit_rec_beam_depth = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "0.2",
                "position",
                [fourth_column tenth_line view_width component_height]
            );

            text_view_rec_beam1 = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "",
              "position",
              [sixth_column tenth_line 4 * view_width + 30 component_height]
            );

            text_view_rec_beam2 = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "",
              "position",
              [sixth_column eleventh_line 4 * view_width + 30 component_height]
            );

            text_view_rec_beam3 = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "",
              "position",
              [sixth_column twelfth_line 4 * view_width + 30 component_height]
            );

            button_add_rec_beam = uicontrol(
                obj.f,
                "string",
                "Set",
                "callback",
                {@getBeamWidthRec, edit_rec_beam_width, edit_rec_beam_height, edit_rec_beam_depth, text_view_rec_beam1, text_view_rec_beam2, text_view_rec_beam3}, 
                "position",
                [fifth_column tenth_line view_width component_height]
            );


            % Radial Beam
            text_rad_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Circular Beam:",
                "position",
                [first_column twelfth_line view_width 2 * component_height + 10],
                "enable",
                "inactive"
            );

            text_rad_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Width [m]: ",
                "position",
                [second_column eleventh_line view_width component_height],
                "enable",
                "inactive"
            );

            text_rad_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Radius 1 [m]: ",
                "position",
                [third_column eleventh_line view_width component_height],
                "enable",
                "inactive"
            );

            text_rad_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Radius 2 [m]: ",
                "position",
                [fourth_column eleventh_line view_width component_height],
                "enable",
                "inactive"
            );

            edit_rad_beam_width = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "6",
                "position",
                [second_column twelfth_line view_width component_height]
            );

            edit_rad_beam_height = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "0.4",
                "position",
                [third_column twelfth_line view_width component_height]
            );

            edit_rad_beam_depth = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "0.2",
                "position",
                [fourth_column twelfth_line view_width component_height]
            );

            button_add_rad_beam = uicontrol(
                obj.f,
                "string",
                "Set",
                "callback",
                {@getBeamWidthRad, edit_rad_beam_width, edit_rad_beam_height, edit_rad_beam_depth, text_view_rec_beam1, text_view_rec_beam2, text_view_rec_beam3}, 
                "position",
                [fifth_column twelfth_line view_width component_height]
            );



            % Label
            text_position_label = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Position in X [m]",
                "position",
                [second_column fifth_line view_width component_height],
                "enable",
                "inactive"
            );

            text_magnitude_label = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Magnitude [N or Nm]",
                "position",
                [third_column fifth_line view_width component_height],
                "enable",
                "inactive"
            );

            % Vertical forces
            text_vertical_forces = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Vertical force: ",
                "position",
                [first_column sixth_line view_width 2 * component_height + 10],
                "enable",
                "inactive"
            );

            text_vertical_forces = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Forces Added",
                "position",
                [sixth_column fifth_line 4 * view_width + 30 component_height],
                "enable",
                "inactive"
            );

            edit_vertical_f_position = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "0",
                "position",
                [second_column sixth_line view_width component_height]
            );

            edit_vertical_f_mag = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "-75000",
                "position",
                [third_column sixth_line view_width component_height]
            );

            text_view_vertical_forces = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "",
              "position",
              [sixth_column sixth_line 2 * view_width component_height]
            );

            button_add_vertical_forces = uicontrol(
                obj.f,
                "string",
                "Add Force",
                "callback",
                {@getVerticalForces, edit_vertical_f_position, edit_vertical_f_mag, text_view_vertical_forces},
                "position",
                [fourth_column sixth_line 2 * view_width + 10 component_height]
            );

            % Dist forces add button
            button_clear_vertical_forces = uicontrol(
                obj.f,
                "string",
                "Clear Vertical Forces",
                "callback",
                {@clearVerticalForces, edit_vertical_f_position, edit_vertical_f_mag, text_view_vertical_forces},
                "position",
                [eight_column sixth_line 2 * view_width + 10 component_height]
            );

            % Horizontal forces
            text_horizontal_forces = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Horizontal force: ",
                "position",
                [first_column seventh_line view_width component_height],
                "enable",
                "inactive"
            );

            edit_horizontal_f_position = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "3",
                "position",
                [second_column seventh_line view_width component_height]
            );
            
            edit_horizontal_f_mag = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "10000",
                "position",
                [third_column seventh_line view_width component_height]
            );

            text_view_horizontal_forces = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "",
              "position",
              [sixth_column seventh_line 2 * view_width component_height]
            );

            button_add_horizontal_forces  = uicontrol(
                obj.f,
                "string",
                "Add Force",
                "callback",
                {@getHorizontalForces, edit_horizontal_f_position, edit_horizontal_f_mag, text_view_horizontal_forces},
                "position",
                [fourth_column seventh_line 2 * view_width + 10 component_height]
            );

            button_clear_horizontal_forces  = uicontrol(
                obj.f,
                "string",
                "Clear Horizontal Forces",
                "callback",
                {@clearHorizontalForces, edit_horizontal_f_position, edit_horizontal_f_mag, text_view_horizontal_forces, edit_horizontal_f_position},
                "position",
                [eight_column seventh_line 2 * view_width + 10 component_height]
            );



            % Torque
            text_torques = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Torque:",
                "position",
                [first_column eight_line view_width component_height],
                "enable",
                "inactive"
            );

            edit_torque_pos = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "1",
                "position",
                [second_column eight_line view_width component_height]
            );

            edit_torque = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "900",
                "position",
                [third_column eight_line view_width component_height]
            );

            text_view_torques = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "",
              "position",
              [sixth_column eight_line 2 * view_width component_height]
            );

            button_add_torques = uicontrol(
                obj.f,
                "string",
                "Add Torque",
                "callback",
                {@getTorques, edit_torque_pos, edit_torque, text_view_torques},
                "position",
                [fourth_column eight_line 2 * view_width + 10 component_height]
            );

            button_clear_torques = uicontrol(
                obj.f,
                "string",
                "Clear Torques",
                "callback",
                {@clearTorques, edit_torque, text_view_torques, edit_torque_pos},
                "position",
                [eight_column eight_line 2 * view_width + 10 component_height]
            );




            % Suport
            uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Position [m]: ",
                "position",
                [second_column first_line view_width component_height],
                "enable",
                "inactive"
            ); 

            uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Type: ",
                "position",
                [third_column first_line view_width component_height],
                "enable",
                "inactive"
            ); 

            uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Type Supports Added",
                "position",
                [sixth_column first_line 4 * view_width + 30 component_height],
                "enable",
                "inactive"
            ); 

            text_horizontal_support = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Support: ",
                "position",
                [first_column second_line view_width 2 * component_height + 10],
                "enable",
                "inactive"
            ); 

            edit_horizontal_support = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "6",
                "position",
                [second_column second_line view_width component_height]
            ); 

            listbox_horizontal_support = uicontrol(
                obj.f,
                "style",
                "listbox",
                "string",
                {"Pinned", "Fixed", "Roller"},
                "position",
                [third_column second_line view_width component_height]
            );

            text_view_horizontal_support = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "",
              "position",
              [sixth_column second_line 2 * view_width component_height]
            );

            button_add_horizontal_support = uicontrol(
                obj.f,
                "string",
                "Add Support",
                "callback",
                {@getSupports, edit_horizontal_support, listbox_horizontal_support, struct("Pinned", 1, "Fixed", 2, "Roller", 3), text_view_horizontal_support},
                "position",
                [fourth_column second_line 2 * view_width + 10 component_height]
            );

            button_clear_horizontal_support = uicontrol(
                obj.f,
                "string",
                "Clear Supports",
                "callback",
                {@clearSupports, edit_horizontal_support, listbox_horizontal_support, struct("Pinned", 1, "Fixed", 2, "Roller", 3), text_view_horizontal_support},
                "position",
                [eight_column second_line 2 * view_width + 10 component_height]
            );





            % Beam's tension properties

            uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Young's Modulus (Pa):",
                "position",
                [second_column thirteenth_line view_width component_height],
                "enable",
                "inactive"
            );

            uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Shear's Modulus (Pa):",
                "position",
                [third_column thirteenth_line view_width component_height],
                "enable",
                "inactive"
            );

            uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Material property",
                "position",
                [seventh_column thirteenth_line 3 * view_width + 20 component_height],
                "enable",
                "inactive"
            ); 

            uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Material Properties: ",
                "position",
                [first_column fourteenth_line view_width 2 * component_height + 10],
                "enable",
                "inactive"
            );

            uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Yield Strength (Pa): ",
                "position",
                [fourth_column thirteenth_line view_width component_height],
                "enable",
                "inactive"
            );

            uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Poisson Coefficient: ",
                "position",
                [fifth_column thirteenth_line view_width component_height],
                "enable",
                "inactive"
            );

            edit_young_modulus = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "69e9",
              "position",
              [second_column fourteenth_line view_width component_height]
            );

            edit_shear_modulus = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "25.5e9",
              "position",
              [third_column fourteenth_line view_width component_height]
            );

            edit_yield_strength = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "95e6",
              "position",
              [fourth_column fourteenth_line view_width component_height]
            );

            edit_poisson_coef = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "0.33",
              "position",
              [fifth_column fourteenth_line view_width component_height]
            );

            text_view_tension_properties = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "",
              "position",
              [seventh_column fourteenth_line 3 * view_width + 20 component_height]
            );

            button_set_rad_beam = uicontrol(
                obj.f,
                "string",
                "Set",
                "callback",
                {@getMaterialProperties, edit_young_modulus, edit_shear_modulus, edit_yield_strength, edit_poisson_coef, text_view_tension_properties}, 
                "position",
                [sixth_column fourteenth_line view_width component_height]
            );

            % Button
            button_tensions_point_a = uicontrol(
                obj.f,
                "string",
                "Stress Point A (y = max, z = 0)",
                "callback",
                {@show_tension_diagrams, PointType().A},
                "position",
                [second_column fifteenth_line 2 * view_width + 10 component_height]
            );

            button_tensions_point_b = uicontrol(
                obj.f,
                "string",
                "Stress Point B (y = 0, z = max)",
                "callback",
                {@show_tension_diagrams, PointType().B},
                "position",
                [fourth_column fifteenth_line 2 * view_width + 10 component_height]
            );

            button_tensions_point_c = uicontrol(
                obj.f,
                "string",
                "Stress - Point C (y = min, z = 0)",
                "callback",
                {@show_tension_diagrams, PointType().C},
                "position",
                [sixth_column fifteenth_line 2 * view_width + 10 component_height]
            );

            button_tensions_point_d = uicontrol(
                obj.f,
                "string",
                "Stress - Point D (y = 0, z = min)",
                "callback",
                {@show_tension_diagrams, PointType().D},
                "position",
                [eight_column fifteenth_line 2 * view_width + 10 component_height]
            );

            button_solve = uicontrol (
                obj.f,
                "string",
                "Show Inner Forces",
                "callback",
                {@solve_gui},
                "position",
                [first_column fifteenth_line view_width component_height]
            );

            waitfor(obj.f)
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks                                                              % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function getBeamWidthRec(hObject, eventdata, edit_rec_beam_width, edit_rec_beam_height, edit_rec_beam_depth, text_view_rec_beam1, text_view_rec_beam2, text_view_rec_beam3)
    global obj

    beam_width = get(edit_rec_beam_width, 'String');
    beam_height = get(edit_rec_beam_height, 'String');
    beam_depth = get(edit_rec_beam_depth, 'String');

    if length(beam_width) > 0 && length(beam_height) > 0 && length(beam_depth) > 0
        depth = str2double(beam_depth);
        height = str2double(beam_height);

        obj.section_area = depth * height;

        obj.momentum_inertia = (depth * height**3) / 12;

        obj.polar_momentum_inertia = 2 * obj.momentum_inertia;

        obj.data_beam_width = abs(str2double(beam_width));

        text1  = cstrcat("Width = ", num2str(obj.data_beam_width), " m");
        text2  = cstrcat("Section Area = ", num2str(obj.section_area), " m^2");
        text3  = cstrcat("Momementum Inertia = ", num2str(obj.momentum_inertia), " m^4;   ", "Momementum Polar Inertia = ", num2str(obj.polar_momentum_inertia), " m^4");

        set(text_view_rec_beam1, 'String', text1);
        set(text_view_rec_beam2, 'String', text2);
        set(text_view_rec_beam3, 'String', text3);

        set(edit_rec_beam_width, 'String', "");
        set(edit_rec_beam_height, 'String', "");
        set(edit_rec_beam_depth, 'String', "");
    end
end

function getBeamWidthRad(hObject, eventdata, edit_rad_beam_width, edit_rad_beam_height, edit_rad_beam_depth, text_view_rec_beam1, text_view_rec_beam2, text_view_rec_beam3)
    global obj

    beam_width = get(edit_rad_beam_width, 'String');
    beam_radius1 = get(edit_rad_beam_height, 'String');
    beam_radius2 = get(edit_rad_beam_depth, 'String');

    if length(beam_width) > 0 && length(beam_radius1) > 0 && length(beam_radius2) > 0
        radius1 = str2double(beam_radius1);
        radius2 = str2double(beam_radius2);

        obj.radius1 = radius1;

        obj.radius2 = radius2;

        obj.section_area = pi * (max(radius1, radius2)**2 - min(radius1, radius2)**2);

        obj.momentum_inertia = pi * (max(radius1, radius2)**4 - min(radius1, radius2)**4) / 4;

        obj.polar_momentum_inertia = 2 * obj.momentum_inertia;

        obj.data_beam_width = abs(str2double(beam_width));

        text1  = cstrcat("Width = ", num2str(obj.data_beam_width), " m");
        text2  = cstrcat("Section Area = ", num2str(obj.section_area), " m^2");
        text3  = cstrcat("Momementum Inertia = ", num2str(obj.momentum_inertia), " m^4;   ", "Momementum Polar Inertia = ", num2str(obj.polar_momentum_inertia), " m^4");

        set(text_view_rec_beam1, 'String', text1);
        set(text_view_rec_beam2, 'String', text2);
        set(text_view_rec_beam3, 'String', text3);

        set(edit_rad_beam_width, 'String', "");
        set(edit_rad_beam_height, 'String', "");
        set(edit_rad_beam_depth, 'String', "");
    end
end

function clearVerticalForces(hObject, eventdata, edit_pos, edit_mag, view)
    global obj

    vertical_forces(1) = Force(0, 0);
    obj.data_vertical_forces = vertical_forces;

    set(view, 'String', '');
    set(edit_pos, 'String', "");
    set(edit_mag, 'String', "");
end

function getVerticalForces(hObject, eventdata, edit_pos, edit_mag, view)
    global obj

    position = get(edit_pos, 'String');
    mag = get(edit_mag, 'String');

    if length(position) > 0 && length(mag) > 0
        position = str2double(position);
        mag = str2double(mag);

        obj.data_vertical_forces(length(obj.data_vertical_forces) + 1) = Force(position, mag);

        set(view, 'String', getTextFromForces(obj.data_vertical_forces));
        set(edit_pos, 'String', "");
        set(edit_mag, 'String', "");
    end
end
  
function clearHorizontalForces(hObject, eventdata, edit_pos, edit_mag, view, view_pos)
    global obj

    horizontal_forces(1) = Force(0, 0);
    obj.data_horizontal_forces = horizontal_forces;

    set(view, 'String', '');
    set(view_pos, 'String', '');
    set(edit_pos, 'String', "");
    set(edit_mag, 'String', "");
end

function getHorizontalForces(hObject,eventdata, edit_pos, edit_mag, view)
    global obj 

    position = get(edit_pos, 'String');
    mag = get(edit_mag, 'String');

    if length(position) > 0 && length(mag) > 0
        position = str2double(position);
        mag = str2double(mag);

        obj.data_horizontal_forces(length(obj.data_horizontal_forces) + 1) = Force(position, mag);

        set(view, 'String', getTextFromForces(obj.data_horizontal_forces));
        set(edit_pos, 'String', "");
        set(edit_mag, 'String', "");
    end
end

function text = getTextFromForces(data_forces)
    text = "";
    for i = 2:length(data_forces)
        text = strcat(text, "[pos = ", num2str(data_forces(i).pos), "m ; mag = ",  num2str(data_forces(i).mag), "N ], ");
    end
end

function clearTorques(hObject, eventdata, edit_mag, view, view_pos)
    global obj

    torque_forces(1) = Force(0, 0);
    obj.data_torques = torque_forces;

    set(view, 'String', '');
    set(view_pos, 'String', '');
    set(edit_mag, 'String', "");
end

function getTorques(hObject, eventdata, edit_pos, edit_mag, view)
    global obj 

    mag = get(edit_mag, 'String');
    pos = get(edit_pos, 'String');

    if length(mag) > 0 && length(pos) > 0
        mag = str2double(mag);
        pos = str2double(pos);
        
        obj.data_torques(length(obj.data_torques) + 1) = Force(pos, mag);

        set(view, 'String', getTextFromTorques(obj.data_torques));
        set(edit_mag, 'String', "");
        set(edit_pos, 'String', "");
    end
end

function text = getTextFromTorques(data_torques)
    text = "";
    for i = 2:length(data_torques)
        text = strcat(text, "[pos = ", num2str(data_torques(i).pos), "m ; mag = ",  num2str(data_torques(i).mag), "Nm ], ");
    end
end

function clearSupports(hObject, eventdata, edit, listbox, listboxID, view)
    global obj 
    
    supports(1) = Support(0, SupportType().Dummy);
    obj.data_supports = supports;

    set(view, 'String', '');
    set(edit, 'String', "");
end

function getSupports(hObject, eventdata, edit, listbox, listboxID, view)
    global obj 

    position = get(edit, 'String');
    selection = get(listbox, 'String');
    support_type_str = get(listbox, 'Value');

    if length(selection) > 0 && length(support_type_str) && length(position) > 0
        support_type = SupportType().Dummy;

        switch (support_type_str)
            case listboxID.Pinned
                support_type = SupportType().Pinned;
            case listboxID.Fixed
                support_type = SupportType().Fixed;
            case listboxID.Roller
                support_type = SupportType().Roller;
        end

        if support_type != SupportType().Dummy
            position = str2double(position);

            obj.data_supports(length(obj.data_supports) + 1) = Support(position, support_type);
        end

        text = "";

        for i = 2:length(obj.data_supports)
            if obj.data_supports(i).type == SupportType().Pinned
                text = strcat(text, "[pos = ", num2str(obj.data_supports(i).pos),  "m ; type = " , "Pinned", "], ");
            elseif obj.data_supports(i).type == SupportType().Roller
                text = strcat(text, "[pos = ", num2str(obj.data_supports(i).pos),  "m ; type = " , "Roller", "], ");
            elseif obj.data_supports(i).type == SupportType().Fixed
                text = strcat(text, "[pos = ", num2str(obj.data_supports(i).pos),  "m ; type = " , "Fixed", "], ");
            end
        end

        set(view, 'String', text);
        set(edit, 'String', "");
    end
end

function clearDistForces(hObject, eventdata, edit_begin, edit_end, edit_coef, view_begin)
    global obj

    % Load my data
    vertical_dist_forces(1) = DistForce(0, 0, "0");
    obj.data_vertical_dist_forces = vertical_dist_forces;

    set(view_begin, 'String', '');
    set(edit_begin, 'String', '');
    set(edit_end, 'String', '');
    set(edit_coef, 'String', '');
end

function getDistForces(hObject, eventdata, edit_begin, edit_end, edit_coef, view_begin)
    global obj

    begin_pos = str2double(get(edit_begin, 'String'));
    end_pos = str2double(get(edit_end, 'String'));
    
    fun_str = get(edit_coef, 'String');

    if length(fun_str) > 0
        beg_str = " , ";

        addTextViewText(view_begin, ["start = " num2str(begin_pos) "m ; end = " num2str(end_pos) "m ; pol = " fun_str], beg_str);

        new_dist_force = DistForce(begin_pos, end_pos, fun_str);
        
        obj.data_vertical_dist_forces(length(obj.data_vertical_dist_forces) + 1) = new_dist_force;

        set(edit_begin, 'String', '');
        set(edit_end, 'String', '');
        set(edit_coef, 'String', '');
    end
end

% TODO
function getMaterialProperties(hObject, eventdata,
 edit_young_modulus, edit_shear_modulus, edit_yield_strength, edit_poisson_coef, text_mat_props)
    global obj
    
    poisson = get(edit_poisson_coef, 'String');
    young_module = get(edit_young_modulus, 'String');
    shear_module = get(edit_shear_modulus, 'String');
    yield_strength = get(edit_yield_strength, 'String');

    if length(young_module) > 0 && length(shear_module) > 0 && length(yield_strength) > 0 && length(poisson) > 0

        obj.poisson_coef = str2double(poisson);
        obj.young_module =  str2double(young_module);
        obj.shear_module = str2double(shear_module);
        obj.yield_strength = str2double(yield_strength);

        text  = cstrcat("Young's modulus [", num2str(obj.young_module), " Pa]  \nShear's modulus [", num2str(obj.shear_module), " Pa]  \nYield Strength [", num2str(obj.yield_strength), " Pa]  ", "Poisson [", num2str(obj.poisson_coef), "]");

        set(text_mat_props, 'String', text);

        set(edit_young_modulus, 'String', '');
        set(edit_shear_modulus, 'String', '');
        set(edit_yield_strength, 'String', '');
    end
end

function addTextViewText(view, text, beg_str)
    old_text  = get(view, 'String');
    set(view, 'String', strcat(old_text, " [", text, "]", beg_str));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve the resmat given problem                                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function solve_gui(hObject, eventdata)
    global obj

    solve_problem(obj)
end

% Because of the discretisation chosen, there might be a case when a support position
% is not ploted, therefore the bondary conditions do not apply correcty
% in this case, the x_boundary and y_boundary should be specified.
function plot_data(r, c, n, data_x, data_y, _title, x_label, y_label, x_limits, dot_color,
x_boundary=[], y_boundary=[])
    subplot(r, c, n);

    if (length(x_boundary) != 0)
        data_x = [data_x, x_boundary];
        data_y = [data_y, y_boundary];
    end
    plot(data_x, data_y, '*', "linewidth", 5, 'color', dot_color);

    xlim(x_limits);

    grid on;

    ylabel (y_label);

    xlabel (x_label);

    title(_title);

    set(gca, "linewidth", 2, "fontsize", 14);
end

function solve_problem(obj)
    momentuns(1) = Force(0, 0);

    [v_forces, h_forces, t_forces, m_forces, v_dist_forces, X, support_momentuns] = lib_resmat.res_mat_1d_solver(
        obj.data_beam_width,
        obj.data_vertical_forces,
        obj.data_horizontal_forces,
        obj.data_torques,
        obj.data_vertical_dist_forces,
        obj.data_supports,
        momentuns
    );

    output_file(v_forces, h_forces, t_forces, m_forces, v_dist_forces);

    [x_pos, h_inner_forces, t_inner_forces, v_inner_forces, m_inner_forces, slope, deflection, elongation, torsion_angle] = lib_resmat.res_mat_1d_inner_solver(
        obj.data_beam_width,
        v_forces,
        h_forces,
        t_forces,
        support_momentuns,
        obj.data_vertical_dist_forces,
        obj.data_supports,
        obj.data_num_steps,
        obj.young_module,
        obj.momentum_inertia,
        obj.shear_module,
        obj.polar_momentum_inertia
    );

    screen_size = get(0,'ScreenSize');

    fig = figure('Position', screen_size);

    clf;
    r = 3;
    c = 4;

    for n = 1 : r * c
        subplot(r, c, n);
    endfor

    plot_data(
        r,
        c,
        c + 1,
        x_pos,
        v_inner_forces,
        'Vertical Internal Forces x Beam Position',
        "Beam Position (m) ",
        "Vertical Internal Force (N) ",
        [0 obj.data_beam_width],
        'red'
    );

    plot_data(
        r,
        c,
        c + 2,
        x_pos,
        m_inner_forces,
        'Internal Momentum x Beam Position',
        "Beam Position (m) ",
        "Internal Momentum (Nm) ",
        [0 obj.data_beam_width],
        'blue'
    );

    plot_data(
        r,
        c,
        c + 3,
        x_pos,
        h_inner_forces,
        'Horizontal Internal Forces x Beam Position',
        "Beam Position (m) ",
        "Horizontal Internal Force (N) ",
        [0 obj.data_beam_width],
        'black'
    );

    plot_data(
        r,
        c,
        c + 4,
        x_pos,
        t_inner_forces,
        'Internal Torque x Beam Position',
        "Beam Position (m) ",
        "Internal Torque (Nm) ",
        [0 obj.data_beam_width],
        'green'
    );

    % Boundary conditions for slope and fixed support
    plot_data(
        r,
        c,
        c + 5,
        x_pos,
        slope,
        'Slope x Beam Position',
        "Beam Position (m) ",
        "Slope (rad) ",
        [0 obj.data_beam_width],
        'red'
    );


    % Boundary conditions for deflection and supports 
    
    plot_data(
        r,
        c,
        c + 6,
        x_pos,
        deflection,
        'Deflection x Beam Position',
        "Beam Position (m) ",
        "Deflection (m) ",
        [0 obj.data_beam_width],
        'blue'
    );

    plot_data(
        r,
        c,
        c + 7,
        x_pos,
        elongation,
        'Elongation x Beam Position',
        "Beam Position (m) ",
        "Elongation (m) ",
        [0 obj.data_beam_width],
        'black'
    );

    plot_data(
        r,
        c,
        c + 8,
        x_pos,
        torsion_angle,
        'Torsion Angle x Beam Position',
        "Beam Position (m) ",
        "Torsion Angle (Nm) ",
        [0 obj.data_beam_width],
        'green'
    );

    subplot (r, c, 1:c);

    plot(x_pos, 0 * x_pos, '-', 'linewidth', 5);

    xlim([0 obj.data_beam_width]);
    ylim([-1 1]);

    hold on;

    plot_width = 0.775;
    first_plot_x = 0.13;
    first_plot_y = 0.81;

    y_pos = 1;
    y_neg = 1;

    for i = 2:length(h_forces)
        force = h_forces(i);
        
        if force.mag >= 0
            y = [first_plot_y first_plot_y] + 0.015 * y_pos;
            y_pos = y_pos + 1;

            x = first_plot_x + [-0.05 0] + force.pos * (plot_width / obj.data_beam_width);
            annotation('textarrow', x, y,'String', strcat('Fh = ', mat2str(abs(force.mag)), 'N'), 'fontsize', 14, 'linewidth', 5, 'color', 'black');
            % annotation('doublearrow', x, y);
        else
            y = [first_plot_y first_plot_y] + 0.015 * y_neg;
            y_neg = y_neg + 1;

            x = first_plot_x + [0.05 0] + force.pos * (plot_width / obj.data_beam_width);
            annotation('textarrow', x, y,'String', strcat('Fh = ', mat2str(abs(force.mag)), 'N'), 'fontsize', 14, 'linewidth', 5, 'color', 'black');
        end
    end

    y_pos = 1;
    y_neg = 1;

    for i = 2:length(t_forces)
        force = t_forces(i);
        
        if force.mag >= 0
            y = [first_plot_y first_plot_y] - 0.015 * y_pos;
            y_pos = y_pos + 1;

            x = first_plot_x + [-0.05 0] + force.pos * (plot_width / obj.data_beam_width);
            annotation('textarrow', x, y,'String', strcat('T = ', mat2str(abs(force.mag)), 'Nm'), 'fontsize', 14, 'linewidth', 5, 'color', 'green');
        else
            y = [first_plot_y first_plot_y] - 0.015 * y_neg;
            y_neg = y_neg + 1;
            
            force.pos
            force.mag

            x = first_plot_x + [0.05 0] + force.pos * (plot_width / obj.data_beam_width);
            annotation('textarrow', x, y,'String', strcat('T = ', mat2str(abs(force.mag)), 'Nm'), 'fontsize', 14, 'linewidth', 5, 'color', 'green');
        end
    end

    for i = 2:length(obj.data_supports)
        support_ = obj.data_supports(i);
        plot([support_.pos], [0], 'o', 'color', 'black', 'linewidth', 8);

        if support_.type == SupportType().Pinned
            text(support_.pos + 0.005 * obj.data_beam_width, -0.1, 'Pinned', 'fontsize', 14);
        elseif support_.type == SupportType().Fixed
            text(support_.pos + 0.005 * obj.data_beam_width, -0.1, 'Fixed', 'fontsize', 14);
        elseif support_.type == SupportType().Roller
            text(support_.pos + 0.005 * obj.data_beam_width, -0.1, 'Roller', 'fontsize', 14);
        end
    end

    for i = 2:length(v_forces)
        force = v_forces(i);
        
        x = first_plot_x + [0 0] + force.pos * (plot_width / obj.data_beam_width);

        if force.mag >= 0
            y = first_plot_y + [-0.05 0];
            annotation('textarrow', x, y,'String', strcat('Fv = ', mat2str(abs(force.mag)), 'N'), 'fontsize', 14, 'linewidth', 5, 'color', 'red');
        else
            y = first_plot_y + [0.05 0];
            annotation('textarrow', x, y,'String', strcat('Fv = ', mat2str(abs(force.mag)), 'N'), 'fontsize', 14, 'linewidth', 5, 'color', 'red');
        end
    end

    for i = 2:length(support_momentuns)
        force = support_momentuns(i);
        
        x = first_plot_x + [-0.025 -0.025] + force.pos * (plot_width / obj.data_beam_width);

        if force.mag >= 0
            y = first_plot_y + [-0.05 0.08];
        else
            y = first_plot_y + [0.05 -0.08];
        end

        annotation('line', x, y, 'linewidth', 5, 'color', 'blue');

        annotation('textarrow', [x(1) x(1) + 0.035], [y(2) y(2)], 'String', strcat('M = ', mat2str(abs(force.mag)), 'Nm'), 'fontsize', 14, 'linewidth', 5, 'color', 'blue');
    end

    for i = 2:length(v_dist_forces)
        force = v_dist_forces(i);
        
        x = first_plot_x + [0 0] + force.pos * (plot_width / obj.data_beam_width);

        if force.mag >= 0
            y = first_plot_y + [-0.05 0];
            annotation('textarrow', x, y,'String', strcat('Fdv = ', mat2str(abs(force.mag)), 'N'), 'fontsize', 14, 'linewidth', 5, 'color', 'red');
        else
            y = first_plot_y + [0.05 0];
            annotation('textarrow', x, y,'String', strcat('Fdv = ', mat2str(abs(force.mag)), 'N'), 'fontsize', 14, 'linewidth', 5, 'color', 'red');
        end
    end

    title('Force Diagram');

    set(gca, "linewidth", 2, "fontsize", 14);

    xlabel ("Beam Position (m) ");

    set(gca,'ytick',[]);

    waitfor(fig)
end


function show_tension_diagrams(hobject, eventdata, point_ref)
    global obj

    solve_problem_tension(obj, point_ref)
end


function solve_problem_tension(obj, point_ref)
    momentuns(1) = Force(0, 0);

    [v_forces, h_forces, t_forces, m_forces, v_dist_forces, X, support_momentuns] = lib_resmat.res_mat_1d_solver(
        obj.data_beam_width,
        obj.data_vertical_forces,
        obj.data_horizontal_forces,
        obj.data_torques,
        obj.data_vertical_dist_forces,
        obj.data_supports,
        momentuns
    );

    [x_pos, h_inner_forces, t_inner_forces, v_inner_forces, m_inner_forces, slope, deflection, elongation, torsion_angle] = lib_resmat.res_mat_1d_inner_solver(
        obj.data_beam_width,
        v_forces,
        h_forces,
        t_forces,
        support_momentuns,
        obj.data_vertical_dist_forces,
        obj.data_supports,
        obj.data_num_steps,
        obj.young_module,
        obj.momentum_inertia,
        obj.shear_module,
        obj.polar_momentum_inertia
    );

    [t_normal, t_shear, principal_1, principal_2, principal_3, shear_max_plane, shear_max_abs, tresca_coefs, von_mises_coefs, eps_x, eps_y, eps_z, gama_x, gama_y, gama_z] = lib_resmat.res_mat_1d_tension_solver(
        h_inner_forces,
        t_inner_forces,
        v_inner_forces,
        m_inner_forces,
        obj.young_module,
        obj.momentum_inertia,
        obj.shear_module,
        obj.polar_momentum_inertia,
        obj.section_area,
        obj.yield_strength,
        point_ref,
        obj.radius1,
        obj.radius2,
        obj.poisson_coef
    );

    screen_size = get(0,'ScreenSize');

    pt_name = "";

    if point_ref == PointType().A
        pt_name = "A";
    end

    if point_ref == PointType().B
        pt_name = "B";
    end

    if point_ref == PointType().C
        pt_name = "C";
    end

    if point_ref == PointType().D
        pt_name = "D";
    end

    fig = figure('name', strcat('Point: ', pt_name), 'Position', screen_size);

    clf;
    r = 4;
    c = 4;

    for n = 1 : r * c
        subplot(r, c, n);
    endfor

    pos_g = 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        t_normal,
        'Normal Stress (\sigma_x)',
        "Beam Position (m) ",
        "Stress (Pa) ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        t_shear,
        'Shear Stress (\tau_{xy})',
        "Beam Position (m) ",
        "Stress (Pa) ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        principal_1,
        'Main normal Stress 1 (\sigma_1)',
        "Beam Position (m) ",
        "Stress (Pa) ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        principal_2,
        'Main normal Stress 2 (\sigma_2)',
        "Beam Position (m) ",
        "Stress (Pa) ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        principal_3,
        'Main normal Stress 3 (\sigma_3)',
        "Beam Position (m) ",
        "Stress (Pa) ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        shear_max_plane,
        'Maximum Shear Stress on Plane (\tau_{max})',
        "Beam Position (m) ",
        "Stress (Pa) ",
        [0 obj.data_beam_width],
        'red'
    );

    hold on;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        -shear_max_plane,
        'Maximum Shear Stress on Plane (\tau_{max})',
        "Beam Position (m) ",
        "Stress (Pa) ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        shear_max_abs,
        'Absolute Maximum Shear Stress (\tau_{max-abs})',
        "Beam Position (m) ",
        "Stress (Pa) ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        tresca_coefs,
        'Tresca Coefficients',
        "Beam Position (m) ",
        "Coefficient ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        von_mises_coefs,
        'Von Mises Coefficients',
        "Beam Position (m) ",
        "Coefficient ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        eps_x,
        'Normal Deformation X (\epsilon_x)',
        "Beam Position (m) ",
        "Coefficient ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        eps_y,
        'Normal Deformation Y (\epsilon_y)',
        "Beam Position (m) ",
        "Coefficient ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        eps_z,
        'Normal Deformation Z (\epsilon_z)',
        "Beam Position (m) ",
        "Coefficient ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        gama_x,
        'Shear Deformation X (\gamma_x)',
        "Beam Position (m) ",
        "Coefficient ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        gama_y,
        'Shear Deformation Y (\gamma_y)',
        "Beam Position (m) ",
        "Coefficient ",
        [0 obj.data_beam_width],
        'red'
    );

    pos_g = pos_g + 1;

    plot_data(
        r,
        c,
        pos_g,
        x_pos,
        gama_z,
        'Shear Deformation Z (\gamma_z)',
        "Beam Position (m) ",
        "Coefficient ",
        [0 obj.data_beam_width],
        'red'
    );

    waitfor(fig)
end

function ret = output_file(v_forces, h_forces, t_forces, m_forces, v_dist_forces)
    % Output

    for i = 2:length(v_forces)
        printf("[Vertical force %d] [Applied at %.2e m] [Magnitude = %.4e N]\n", i - 1, v_forces(i).pos, v_forces(i).mag)
    end

    if length(v_dist_forces) >= 2
        printf("\n");
    end

    for i = 2:length(v_dist_forces)
        printf("[Vertical Distributed forces %d] [Applied at %.2e m] [Magnitude = %.4e N]\n", i - 1, v_dist_forces(i).pos, v_dist_forces(i).mag)
    end

    if length(h_forces) >= 2
        printf("\n");
    end

    for i = 2:length(h_forces)
        printf("[Horizontal force %d] [Applied at %.2e m] [Magnitude = %.4e N]\n", i - 1, h_forces(i).pos, h_forces(i).mag)
    end

    if length(t_forces) >= 2
        printf("\n");
    end

    for i = 2:length(t_forces)
        printf("[Torque force %d] [Due the position %.2e m] [Magnitude = %.4e N]\n", i - 1, t_forces(i).pos, t_forces(i).mag)
    end

    if length(m_forces) >= 2
        printf("\n");
    end

    for i = 2:length(m_forces)
        printf("[Momemtum force %d] [Due the position %.2e m] [Magnitude = %.4e N]\n", i - 1, m_forces(i).pos, m_forces(i).mag)
    end

end