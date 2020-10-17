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
            screen_size = get(0,'ScreenSize');

            % obj.f = figure('Position', screen_size);
            obj.f = figure('Position', screen_size);

            num_columns = 8 + 2;
            num_lines = 12 + 3;

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

            text_dist_force_begin_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Convention: ",
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
                [eight_column zero_line 2 * view_width component_height]
            );



            % Dist forces labels
            text_dist_force_begin_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Start [m]",
                "position",
                [second_column first_line view_width component_height]
            );

            text_dist_force_end_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "End [m]",
                "position",
                [third_column first_line view_width component_height]
            );

            text_dist_force_coeficients = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Polynomial Coefficients",
                "position",
                [fourth_column first_line 2 * view_width + 10 component_height]
            );  
            
            text_dist_force_coeficients = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Distributed Forces Added",
                "position",
                [sixth_column first_line 4 * view_width + 20 component_height]
            );  

            % Dist forces input
            text_dist_force_description = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Distribuited forces: ",
                "position",
                [first_column second_line view_width 2 * component_height + 10]
            ); 

            edit_dist_force_begin = uicontrol (
                obj.f,
                "style",
                "edit",
                "position",
                [second_column second_line view_width component_height]
            );

            edit_dist_force_end = uicontrol (
                obj.f,
                "style",
                "edit",
                "position",
                [third_column second_line view_width component_height]
            );

            edit_dist_force_coeficients = uicontrol (
                obj.f,
                "style",
                "edit",
                "position",
                [fourth_column second_line view_width component_height]
            );

            % Dist forces view
            view_dist_force_begin = uicontrol (
                obj.f,
                "style",
                "edit",
                "position",
                [sixth_column second_line view_width * 2 component_height]
            );

            % Dist forces add button
            button_add_dist_force = uicontrol(
                obj.f,
                "string",
                "Add Dist. Force",
                "callback",
                {@getDistForces, edit_dist_force_begin, edit_dist_force_end, edit_dist_force_coeficients, view_dist_force_begin},
                "position",
                [fifth_column second_line view_width component_height]
            );

            % Dist forces add button
            button_clear_dist_force = uicontrol(
                obj.f,
                "string",
                "Clear Distributed Forces",
                "callback",
                {@clearDistForces,edit_dist_force_begin, edit_dist_force_end, edit_dist_force_coeficients, view_dist_force_begin},
                "position",
                [eight_column second_line 2 * view_width component_height]
            );


            % Beam
            text_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Beam:",
                "position",
                [first_column fourth_line view_width 2 * component_height + 10],
                "enable",
                "inactive"
            );

            text_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Width [m]: ",
                "position",
                [second_column third_line view_width component_height],
                "enable",
                "inactive"
            );

            text_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Height [m]: ",
                "position",
                [third_column third_line 3 * view_width + 20 component_height],
                "enable",
                "inactive"
            );

            text_beam_width = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Beam Width Setted",
                "position",
                [sixth_column third_line 4 * view_width + 20 component_height],
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
                [second_column fourth_line view_width component_height]
            );

            edit_beam_height = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "0",
                "position",
                [third_column fourth_line view_width component_height],
                "enable",
                "inactive"
            );

            text_view_beam = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "",
              "position",
              [sixth_column fourth_line 4 * view_width + 20 component_height],
              "enable",
              "inactive"
            );

            button_add_beam = uicontrol(
                obj.f,
                "string",
                "Set Width",
                "callback",
                {@getBeamWidth, edit_beam_width, text_view_beam}, 
                "position",
                [fourth_column fourth_line 2 * view_width + 10 component_height]
            );


            % Label
            text_position_label = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Position [m]",
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
                [third_column fifth_line 3 * view_width + 20 component_height],
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

            % Vertical forces
            text_vertical_forces = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Forces Added",
                "position",
                [sixth_column fifth_line 4 * view_width + 20 component_height],
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
                [second_column sixth_line view_width component_height]
            );

            edit_vertical_f_mag = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "",
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
                [eight_column sixth_line 2 * view_width component_height]
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
                "0",
                "position",
                [second_column seventh_line view_width component_height],
                "enable",
                "inactive"
            );
            
            edit_horizontal_f_mag = uicontrol(
                obj.f,
                "style",
                "edit",
                "string",
                "",
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
                {@clearHorizontalForces, edit_horizontal_f_position, edit_horizontal_f_mag, text_view_horizontal_forces},
                "position",
                [eight_column seventh_line 2 * view_width component_height]
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
                "0",
                "position",
                [second_column eight_line view_width component_height],
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
                {@getTorques, edit_torque, text_view_torques},
                "position",
                [fourth_column eight_line 2 * view_width + 10 component_height]
            );

            button_clear_torques = uicontrol(
                obj.f,
                "string",
                "Clear Torques",
                "callback",
                {@clearTorques, edit_torque, text_view_torques},
                "position",
                [eight_column eight_line 2 * view_width component_height]
            );





            % Suport
            uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Position [m]: ",
                "position",
                [second_column ninth_line view_width component_height],
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
                [third_column ninth_line 3 * view_width + 20 component_height],
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
                [sixth_column ninth_line 4 * view_width + 20 component_height],
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
                [first_column tenth_line view_width 2 * component_height + 10],
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
                [second_column tenth_line view_width component_height]
            ); 

            listbox_horizontal_support = uicontrol(
                obj.f,
                "style",
                "listbox",
                "string",
                {"Pinned", "Fixed", "Roller"},
                "position",
                [third_column tenth_line view_width component_height]
            );

            text_view_horizontal_support = uicontrol(
              obj.f,
              "style",
              "edit",
              "string",
              "",
              "position",
              [sixth_column tenth_line 2 * view_width component_height]
            );

            button_add_horizontal_support = uicontrol(
                obj.f,
                "string",
                "Add Support",
                "callback",
                {@getSupports, edit_horizontal_support, listbox_horizontal_support, struct("Pinned", 1, "Fixed", 2, "Roller", 3), text_view_horizontal_support},
                "position",
                [fourth_column tenth_line 2 * view_width + 10 component_height]
            );

            button_clear_horizontal_support = uicontrol(
                obj.f,
                "string",
                "Clear Supports",
                "callback",
                {@clearSupports, edit_horizontal_support, listbox_horizontal_support, struct("Pinned", 1, "Fixed", 2, "Roller", 3), text_view_horizontal_support},
                "position",
                [eight_column tenth_line 2 * view_width component_height]
            );

            % Button
            button_save = uicontrol(
                obj.f,
                "string",
                "Save Input",
                "position",
                [sixth_column eleventh_line 4 * view_width + 20 component_height]
            );

            button_solve = uicontrol (
                obj.f,
                "string",
                "Solve",
                "callback",
                {@solve_gui},
                "position",
                [first_column eleventh_line 5 * view_width + 40 component_height]
            );

            waitfor(obj.f)
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks                                                              % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function getBeamWidth(hObject, eventdata, editTxt, view)
    global obj

    beam_str = get(editTxt, 'String');

    if length(beam_str) > 0
        obj.data_beam_width = abs(str2double(beam_str));
        beam_str = mat2str(obj.data_beam_width);

        set(view, 'String', strcat(beam_str, 'm'));
        set(editTxt, 'String', "");
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
  
function clearHorizontalForces(hObject, eventdata, edit_pos, edit_mag, view)
    global obj

    horizontal_forces(1) = Force(0, 0);
    obj.data_horizontal_forces = horizontal_forces;

    set(view, 'String', '');
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
        % set(edit_pos, 'String', "");
        set(edit_mag, 'String', "");
    end
end

function text = getTextFromForces(data_forces)
    text = "";
    for i = 2:length(data_forces)
        text = strcat(text, "[pos = ", num2str(data_forces(i).pos), "m ; mag = ",  num2str(data_forces(i).mag), "N ], ");
    end
end

function clearTorques(hObject, eventdata, edit_pos, edit_mag, view)
    global obj

    torque_forces(1) = Force(0, 0);
    obj.data_torques = torque_forces;

    set(view, 'String', '');
    set(edit_mag, 'String', "");
end

function getTorques(hObject, eventdata, edit_mag, view)
    global obj 

    mag = get(edit_mag, 'String')


    if length(mag) > 0
        mag = str2double(mag);
        
        obj.data_torques(length(obj.data_torques) + 1) = Force(0, mag);

        set(view, 'String', getTextFromTorques(obj.data_torques));
        set(edit_mag, 'String', "");
    end
end

function text = getTextFromTorques(data_torques)
    text = "";
    for i = 2:length(data_torques)
        text = strcat(text, "[mag = ",  num2str(data_torques(i).mag), "Nm ] ");
    end
end

function clearSupports(hObject, eventdata, edit, listbox, listboxID, view)
    global obj 

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
            text = strcat(text, "[pos = ", num2str(obj.data_supports(i).pos),  "m ; type = " , selection(support_type_str), "], ");
        end

        set(view, 'String', text);
        set(edit, 'String', "");
    end
end

function clearDistForces(hObject, eventdata, edit_begin, edit_end, edit_coef, view_begin)
    global obj

    % Load my data
    vertical_dist_forces(1) = DistForce(0, 0, @(x)(0), @(x)(0));
    obj.data_vertical_dist_forces = vertical_dist_forces;

    set(view_begin, 'String', '');
    set(edit_begin, 'String', '');
    set(edit_end, 'String', '');
    set(edit_coef, 'String', '');
end

function getDistForces(hObject, eventdata, edit_begin, edit_end, edit_coef, view_begin)
    global obj

    get(edit_begin, 'String');

    begin_pos = str2double(get(edit_begin, 'String'));
    end_pos = str2double(get(edit_end, 'String'));
    
    fun_str = get(edit_coef, 'String');

    if length(fun_str) > 0
        fun = inline(fun_str);

        beg_str = '';

        % if length(obj.data_vertical_dist_forces) > 1
        beg_str = " , ";
        % end

        addTextViewText(view_begin, [num2str(begin_pos) "m ; " num2str(end_pos) "m ; " fun_str], beg_str);

        new_dist_force = DistForce(begin_pos, end_pos, fun, @(x) x .* fun(x));
        
        obj.data_vertical_dist_forces(length(obj.data_vertical_dist_forces) + 1) = new_dist_force;

        set(edit_begin, 'String', '');
        set(edit_end, 'String', '');
        set(edit_coef, 'String', '');
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