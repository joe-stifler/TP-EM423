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
    end

    methods
        function obj = UI(args)
            warning('off','all');

            addpath('./datatypes');
            addpath('./solver');

            % Load my data
            beam_width = 0;
            torques(1) = Force(0, 0);
            vertical_forces(1) = Force(0, 0);
            horizontal_forces(1) = Force(0, 0);
            supports(1) = Support(0, SupportType().Dummy);
            vertical_dist_forces(1) = DistForce(0, 0, @(x)(0), @(x)(0));

            % Add the input file here
            if length(args) > 0
                run(args{1});
            end

            obj.data_num_steps = 100;
            obj.data_beam_width = beam_width;
            obj.data_torques = torques;
            obj.data_horizontal_forces = horizontal_forces;
            obj.data_vertical_forces = vertical_forces;
            obj.data_supports = supports;
            obj.data_vertical_dist_forces = vertical_dist_forces;
        end

        function solve(obj)
            solve_problem(obj)
        end

        function build(obj)
            close all;
            clear h;
            
            % Plotting
            obj.f = figure();

            % Properties
            component_height = 40;
            left_margin = 10;
            text_width = 240;
            edit_text_x_pos = left_margin + text_width;
            edit_text_width = 70;
            edit_text2_x_pos = edit_text_x_pos + edit_text_width;
            add_button_x_position = edit_text2_x_pos + edit_text_width;
            
            add_button_width = 70;
            add_button_height = 80;

            button_width = 100;

            % Label
            text_position_label = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Position",
                "position",
                [edit_text_x_pos 370 edit_text_width 40],
                "enable",
                "inactive"
            );

            text_magnitude_label = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Magnitude",
                "position",
                [edit_text2_x_pos 370 edit_text_width 40],
                "enable",
                "inactive"
            );

            % Beam
            text_beam_width = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "Beam width [m]: ",
                "position",
                [left_margin 100 text_width 40],
                "enable",
                "inactive"
            );

            edit_beam_width = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "",
                "position",
                [edit_text_x_pos 100 edit_text_width 40]
            );

            button_add_beam = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getBeamWidth, edit_beam_width}, 
                "position",
                [add_button_x_position 100 add_button_width 40]
            );

            % Vertical forces
            text_vertical_forces = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "Vertical force [N]: ",
                "position",
                [left_margin 140 text_width 40],
                "enable",
                "inactive"
            );

            edit_vertical_f_position = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "",
                "position",
                [edit_text_x_pos 140 edit_text_width 40]
            );

            edit_vertical_f_mag = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "",
                "position",
                [edit_text2_x_pos 140 edit_text_width 40]
            );

            button_add_vertical_forces = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getVerticalForces, edit_vertical_f_position, edit_vertical_f_mag},
                "position",
                [add_button_x_position 140 add_button_width 40]
            );

            % Horizontal forces
            text_horizontal_forces = uicontrol(
                obj.f,
                "style", "edit",
                "string",
                "Horizontal force [N]: ",
                "position",
                [left_margin 180 text_width 40],
                "enable",
                "inactive"
            );

            edit_horizontal_f_position = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "",
                "position",
                [edit_text_x_pos 180 edit_text_width 40]
            );
            
            edit_horizontal_f_mag = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "",
                "position",
                [edit_text2_x_pos 180 edit_text_width 40]
            );

            button_add_horizontal_forces  = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getHorizontalForces, edit_horizontal_f_position, edit_horizontal_f_mag},
                "position",
                [add_button_x_position 180 add_button_width 40]
            );

            % Torque
            text_torques = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "Torque [Nm]: ",
                "position",
                [left_margin 220 text_width 40],
                "enable",
                "inactive"
            );

            edit_torque = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "",
                "position",
                [edit_text_x_pos 220 edit_text_width 40]
            );

            button_add_torques = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getTorques, edit_torque},
                "position",
                [add_button_x_position 220 add_button_width 40]
            );

            % Suport
            text_horizontal_support = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "Horizontal support x position [m]: ",
                "position",
                [left_margin 270 text_width add_button_height],
                "enable",
                "inactive"
            ); 

            edit_horizontal_support = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "",
                "position",
                [edit_text_x_pos 270 edit_text_width add_button_height]
            ); 

            listbox_horizontal_support = uicontrol(
                obj.f,
                "style",
                "listbox",
                "string",
                {"Pinned", "Fixed", "Roller"},
                "position",
                [edit_text2_x_pos 270 add_button_width add_button_height]
            );

            button_add_horizontal_support = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getSupports, edit_horizontal_support, listbox_horizontal_support, struct("Pinned", 1, "Fixed", 2, "Roller", 3)},
                "position",
                [add_button_x_position 270 add_button_width 40]
            );

            button_save = uicontrol(
                obj.f,
                "string",
                "Save Input",
                "callback",
                {@solve_gui},
                "position",
                [left_margin 55 button_width component_height]
            );

            button_solve = uicontrol (
                obj.f,
                "string",
                "Solve",
                "position",
                [left_margin + button_width 55 button_width component_height]
            );

            b1 = uicontrol (
                obj.f,
                "string",
                "Load Config",
                "position",
                [left_margin 370 button_width component_height]
            );

            waitfor(obj.f)
        end
    end
end


function getBeamWidth(hObject, eventdata, edit)
    global obj

    obj.data_beam_width = str2double(get(edit, 'String'));
    
    set(edit, 'String', "");
end


function getVerticalForces(hObject, eventdata, edit_pos, edit_mag)
    global obj

    position = str2double(get(edit_pos, 'String'));
    mag = str2double(get(edit_mag, 'String'));

    obj.data_vertical_forces(length(obj.data_vertical_forces) + 1) = Force(position, mag);

    set(edit_pos, 'String', "");
    set(edit_mag, 'String', "");
end
  

function getHorizontalForces(hObject,eventdata, edit_pos, edit_mag)
    global obj 

    position = str2double(get(edit_pos, 'String'));
    mag = str2double(get(edit_mag, 'String'));

    obj.data_horizontal_forces(length(obj.data_horizontal_forces) + 1) = Force(position, mag);

    set(edit_pos, 'String', "");
    set(edit_mag, 'String', "");
end

function getTorques(hObject, eventdata, edit)
    global obj 

    mag = str2double(get(edit, 'String'));
    
    obj.data_torques(length(obj.data_torques) + 1) = Force(0, mag);

    set(edit, 'String', "");
end

function getSupports(hObject, eventdata, edit, listbox, listboxID)
    global obj 

    selection = get(listbox, 'String');
    support_type_str = get(listbox, 'Value');

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
        position = str2double(get(edit, 'String'))

        obj.data_supports(length(obj.data_supports) + 1) = Support(position, support_type);
    end
        
    set(edit, 'String', "");    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve the resmat given problem                                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function solve_gui(hObject, eventdata)
    global obj

    solve_problem(obj)
end

function solve_problem(obj)
    printf("**************************************************\n")

    [v_forces, h_forces, t_forces, m_forces, v_dist_forces, X] = lib_resmat.res_mat_1d_solver(
        obj.data_beam_width,
        obj.data_vertical_forces,
        obj.data_horizontal_forces,
        obj.data_torques,
        obj.data_vertical_dist_forces,
        obj.data_supports
    );

    output_file(v_forces, h_forces, t_forces, m_forces, v_dist_forces);

    [x_pos, v_inner_forces, m_inner_forces] = lib_resmat.res_mat_1d_inner_solver(
        obj.data_beam_width,
        v_forces,
        h_forces,
        t_forces,
        m_forces,
        obj.data_vertical_dist_forces,
        obj.data_num_steps
    );

    fig = figure();

    ax1 = subplot (2, 1, 1);

    plot(x_pos, v_inner_forces, 'o');

    plot(x_pos, v_inner_forces, 'o');

    ax2 = subplot(2, 1, 2);

    plot(x_pos, m_inner_forces, 'o');

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