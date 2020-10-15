classdef UI
    properties
        f;
        data_beam_width;
        data_torques;
        data_vertical_forces;
        data_horizontal_forces;
        data_supports;
        data_vertical_dist_forces;
    end

    methods
        function obj = UI()
            addpath('datatypes');
            addpath('solver');
            addpath('tests');

            % Load my data
            beam_width = 0;
            torques(1) = Force(0, 0);
            vertical_forces(1) = Force(0, 0);
            horizontal_forces(1) = Force(0, 0);
            supports(1) = Support(0, SupportType().Dummy);
            vertical_dist_forces(1) = DistForce(0, 0, @(x)(0), @(x)(0));

            % Add the input file here
            % aula1_ex1;

            obj.data_beam_width = beam_width;
            obj.data_torques = torques;
            obj.data_horizontal_forces = horizontal_forces;
            obj.data_vertical_forces = vertical_forces;
            obj.data_supports = supports;
            obj.data_vertical_dist_forces = vertical_dist_forces;
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
            edit_text_x_pos = 250;
            edit_text_width = 70;
            edit_text2_x_pos =  320;
            add_button_x_position = 390;
            add_button_width = 70;
            add_button_height = 80;
            button_width = 100;
            view_position = add_button_x_position + add_button_width;
            view_width = 300;
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

            text_view_beam = uicontrol(
              obj.f,
              "style",
              "text",
              "string",
              "",
              "position",
              [view_position 100 view_width component_height]
            );

            button_add_beam = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getBeamWidth, edit_beam_width, text_view_beam}, 
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

            text_view_vertical_forces = uicontrol(
              obj.f,
              "style",
              "text",
              "string",
              "",
              "position",
              [view_position 140 view_width component_height]
            );

            button_add_vertical_forces = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getVerticalForces, edit_vertical_f_position, edit_vertical_f_mag, text_view_vertical_forces},
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

            text_view_horizontal_forces = uicontrol(
              obj.f,
              "style",
              "text",
              "string",
              "",
              "position",
              [view_position 180 view_width component_height]
            );

            button_add_horizontal_forces  = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getHorizontalForces, edit_horizontal_f_position, edit_horizontal_f_mag, text_view_horizontal_forces},
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

            text_view_torques = uicontrol(
              obj.f,
              "style",
              "text",
              "string",
              "",
              "position",
              [view_position 220 view_width component_height]
            );

            button_add_torques = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getTorques, edit_torque, text_view_torques},
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

            text_view_horizontal_support = uicontrol(
              obj.f,
              "style",
              "text",
              "string",
              "",
              "position",
              [view_position 270 view_width component_height]
            );

            button_add_horizontal_support = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getSupports, edit_horizontal_support, listbox_horizontal_support, struct("Pinned", 1, "Fixed", 2, "Roller", 3), text_view_horizontal_support},
                "position",
                [add_button_x_position 270 add_button_width 40]
            );

            % Button
            button_save = uicontrol(
                obj.f,
                "string",
                "Save Input",
                "position",
                [left_margin 55 button_width component_height]
            );

            button_solve = uicontrol (
                obj.f,
                "string",
                "Solve",
                "callback",
                {@solve_gui},
                "position",
                [left_margin + button_width 55 button_width component_height]
            );

            % Dist forces labels
            text_dist_force_begin_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Start [m]",
                "position",
                [edit_text_x_pos 490 button_width component_height]
            );

            text_dist_force_end_label = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "End [m]",
                "position",
                [edit_text2_x_pos 490 button_width component_height]
            );

            text_dist_force_coeficients = uicontrol (
                obj.f,
                "style",
                "text",
                "string",
                "Polynomial Coefficients",
                "position",
                [edit_text2_x_pos + button_width 490 view_width component_height]
            );            
            
            % Dist forces input
            text_dist_force_description = uicontrol(
                obj.f,
                "style",
                "text",
                "string",
                "Distribuited forces: ",
                "position",
                [left_margin 450 text_width add_button_height]
            ); 

            edit_dist_force_begin = uicontrol (
                obj.f,
                "style",
                "edit",
                "position",
                [edit_text_x_pos 450 button_width component_height]
            );

            edit_dist_force_end = uicontrol (
                obj.f,
                "style",
                "edit",
                "position",
                [edit_text2_x_pos 450 button_width component_height]
            );

            edit_dist_force_coeficients = uicontrol (
                obj.f,
                "style",
                "edit",
                "position",
                [edit_text2_x_pos + button_width 450 view_width component_height]
            );

            % Dist forces view
            view_dist_force_begin = uicontrol (
                obj.f,
                "style",
                "text",
                "position",
                [edit_text_x_pos 410 button_width component_height]
            );

            view_dist_force_end = uicontrol (
                obj.f,
                "style",
                "text",
                "position",
                [edit_text2_x_pos 410 button_width component_height]
            );

            view_dist_force_coeficients = uicontrol (
                obj.f,
                "style",
                "text",
                "position",
                [edit_text2_x_pos + button_width 410 view_width component_height]
            );

            % Dist forces add button
            button_add_dist_force = uicontrol(
                obj.f,
                "string",
                "+",
                "callback",
                {@getDistForces, edit_dist_force_begin, edit_dist_force_end, edit_dist_force_coeficients, view_dist_force_begin, view_dist_force_end, view_dist_force_coeficients},
                "position",
                [edit_text2_x_pos + button_width + view_width 450 add_button_width 40]
            );

            waitfor(obj.f)
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks                                                              % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function getBeamWidth(hObject, eventdata, edit, view)
    global obj

    obj.data_beam_width = str2double(get(edit, 'String'));

    set(view, 'String', mat2str(obj.data_beam_width, [4, 2]));
    set(edit, 'String', "");
end


function getVerticalForces(hObject, eventdata, edit_pos, edit_mag, view)
    global obj

    position = str2double(get(edit_pos, 'String'));
    mag = str2double(get(edit_mag, 'String'));

    obj.data_vertical_forces(length(obj.data_vertical_forces) + 1) = Force(position, mag);

    set(view, 'String', getTextFromForces(obj.data_vertical_forces));
    set(edit_pos, 'String', "");
    set(edit_mag, 'String', "");
end
  

function getHorizontalForces(hObject,eventdata, edit_pos, edit_mag, view)
    global obj 

    position = str2double(get(edit_pos, 'String'));
    mag = str2double(get(edit_mag, 'String'));

    obj.data_horizontal_forces(length(obj.data_horizontal_forces) + 1) = Force(position, mag);

    set(view, 'String', getTextFromForces(obj.data_horizontal_forces));
    set(edit_pos, 'String', "");
    set(edit_mag, 'String', "");
end

function text = getTextFromForces(data_forces)
    text = "";
    for i = 2:length(data_forces)
        text = strcat(text, "[pos: ", num2str(data_forces(i).pos), "m ; mag :",  num2str(data_forces(i).mag), "N ] ");
    end
end

function getTorques(hObject, eventdata, edit, view)
    global obj 

    mag = str2double(get(edit, 'String'));
    
    obj.data_torques(length(obj.data_torques) + 1) = Force(0, mag);

    set(view, 'String', getTextFromTorques(obj.data_torques));
    set(edit, 'String', "");
end

function text = getTextFromTorques(data_torques)
    text = "";
    for i = 2:length(data_torques)
        text = strcat(text, "[mag: ",  num2str(data_torques(i).mag), "Nm ] ");
    end
end

function getSupports(hObject, eventdata, edit, listbox, listboxID, view)
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

    text = "";
    options = ["Pinned"; "Fixed"; "Roller"];
    for i = 2:length(obj.data_supports)
        text = strcat(text, "[", num2str(obj.data_supports(i).pos),  ";" , options(support_type_str), "] ");
    end

    set(view, 'String', text);
    set(edit, 'String', "");
end


function getDistForces(hObject, eventdata, edit_begin, edit_end, edit_coef, view_begin, view_end, view_coef)
    get(edit_begin, 'String')
    begin_pos = str2double(get(edit_begin, 'String'))
    end_pos = str2double(get(edit_end, 'String'))
    fun_str = get(edit_coef, 'String')
    fun = inline(fun_str)

    h = guidata(hObject)
    addTextViewText(view_begin, num2str(begin_pos))
    addTextViewText(view_end, num2str(end_pos))
    addTextViewText(view_coef, fun_str)

    set(edit_begin, 'String', '')
    set(edit_end, 'String', '')
    set(edit_coef, 'String', '')
end

function addTextViewText(view, text)
    old_text  = get(view, 'String')
    set(view, 'String', strcat(old_text, "[", text, "]"))
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auxiliary function to treat input                                      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve the resmat given problem                                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function solve_gui(hObject, eventdata)
    global obj

    printf("**************************************************\n")

    [v_forces, h_forces, t_forces, m_forces] = lib_resmat.res_mat_1d_solver(
        obj.data_beam_width,
        obj.data_vertical_forces,
        obj.data_horizontal_forces,
        obj.data_torques,
        obj.data_vertical_dist_forces,
        obj.data_supports
    );

    output_file(v_forces, h_forces, t_forces, m_forces);
 
end