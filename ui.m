addpath('datatypes')
addpath('solver');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UI                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function UI
  f = figure()
  % Properties
  component_height = 40;
  left_margin = 10;
  text_width = 240;
  edit_text_x_pos = left_margin + text_width;
  edit_text_width = 70;
  edit_text2_x_pos = edit_text_x_pos + edit_text_width
  add_button_x_position = edit_text2_x_pos + edit_text_width;
  add_button_width = 50;
  button_width = 100;

  % Label
  text_position_label          = uicontrol(f,
                                            "style", "text",
                                            "string", "Position",
                                            "position",[edit_text_x_pos 320 edit_text_width 40],
                                            "enable", "inactive");
  text_magnitude_label          = uicontrol(f,
                                            "style", "text",
                                            "string", "Magnitude",
                                            "position",[edit_text2_x_pos 320 edit_text_width 40],
                                            "enable", "inactive");
  % Beam
  text_beam_width               = uicontrol(f,
                                            "style", "edit",
                                            "string", "Beam width [m]: ",
                                            "position",[left_margin 100 text_width 40],
                                            "enable", "inactive");
  edit_beam_width               = uicontrol(f,
                                            "style", "edit",
                                            "string", "",
                                            "position", [edit_text_x_pos 100 edit_text_width 40]);
  button_add_beam               = uicontrol(f,
                                            "string", "+",
                                            "callback", {@getBeamWidth, edit_beam_width}, 
                                            "position", [add_button_x_position 100 add_button_width 40]);

  % Vertical forces
  text_vertical_forces          = uicontrol(f,
                                            "style", "edit",
                                            "string", "Vertical force [N]: ",
                                            "position",[left_margin 140 text_width 40],
                                            "enable", "inactive");
  edit_vertical_f_position      = uicontrol(f,
                                            "style", "edit",
                                            "string", "",
                                            "position",[edit_text_x_pos 140 edit_text_width 40]);
  edit_vertical_f_mag           = uicontrol(f,
                                            "style", "edit",
                                            "string", "",
                                            "position",[edit_text2_x_pos 140 edit_text_width 40]);

  button_add_vertical_forces    = uicontrol(f,
                                            "string", "+",
                                            "callback", {@getVerticalForces, edit_vertical_f_position, edit_vertical_f_mag},
                                            "position", [add_button_x_position 140 add_button_width 40]);

  % Horizontal forces
  text_horizontal_forces        = uicontrol(f,
                                            "style", "edit", "string",
                                            "Horizontal force [N]: ",
                                            "position",[left_margin 180 text_width 40], "enable", "inactive");
  edit_horizontal_f_position    = uicontrol(f,
                                            "style", "edit",
                                            "string", "",
                                            "position",[edit_text_x_pos 180 edit_text_width 40]);
  edit_horizontal_f_mag         = uicontrol(f,
                                            "style", "edit",
                                            "string", "",
                                            "position",[edit_text2_x_pos 180 edit_text_width 40]);

  button_add_horizontal_forces  = uicontrol(f,
                                            "string", "+",
                                            "callback", {@getHorizontalForces, edit_horizontal_f_position, edit_horizontal_f_mag},
                                            "position", [add_button_x_position 180 add_button_width 40]);

  % Torque
  text_torques                  = uicontrol(f,
                                            "style", "edit",
                                            "string", "Torque [Nm]: ",
                                            "position",[left_margin 220 text_width 40], "enable", "inactive");
  edit_torque                   = uicontrol(f,
                                            "style", "edit",
                                            "string", "",
                                            "position",[edit_text_x_pos 220 edit_text_width 40]);
  button_add_torques            = uicontrol(f,
                                            "string", "+",
                                            "callback", {@getTorques, edit_torque},
                                            "position", [add_button_x_position 220 add_button_width 40]);

  % Suport
  text_horizontal_support       = uicontrol(f,
                                            "style", "edit",
                                            "string", "Horizontal support x position [m]: ",
                                            "position",[left_margin 270 text_width 40], "enable", "inactive"); 
  edit_horizontal_support       = uicontrol(f,
                                            "style", "edit",
                                            "string", "",
                                            "position",[edit_text_x_pos 270 edit_text_width 40]); 
  listbox_horizontal_support                      = uicontrol(f,
                                            "style", "listbox",
                                            "string", {"Pinned", "Fixed", "Roller"},
                                            "position", [edit_text2_x_pos 270 add_button_width 40]
                                            )
  button_add_horizontal_support = uicontrol (f,
                                            "string", "+",
                                            "callback", {@getSupports, edit_horizontal_support, listbox_horizontal_support},
                                            "position", [add_button_x_position 270 add_button_width 40]);

  button_save = uicontrol (f,
                           "string",
                           "Save Input",
                           "callback", @finish,
                           "position",[left_margin 55 button_width component_height]);

  button_solve = uicontrol (f, "string", "Solve", "position",[left_margin + button_width 55 button_width component_height]);
  b1 = uicontrol (f, "string", "Load Config", "position",[left_margin 370 button_width component_height]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function getBeamWidth(hObject, eventdata, edit)
  global data_beam_width;
  data_beam_width = str2double(get(edit, 'String'))
  set(edit, 'String', "");
end

function getVerticalForces(hObject, eventdata, edit_pos, edit_mag)
  global data_vertical_forces
  position = str2double(get(edit_pos, 'String'))
  mag = str2double(get(edit_mag, 'String'))
  if (length(data_vertical_forces) == 0)
    data_vertical_forces = Force(0,0)
  end
  data_vertical_forces(length(data_vertical_forces) + 1) = Force(position, mag)
  set(edit_pos, 'String', "");
  set(edit_mag, 'String', "");
end

function getHorizontalForces(hObject,eventdata, edit_pos, edit_mag)
  global data_horizontal_forces
  position = str2double(get(edit_pos, 'String'))
  edit_mag
  mag = str2double(get(edit_mag, 'String'))
  if (length(data_horizontal_forces) == 0)
    data_horizontal_forces = Force(0,0)
  end
  data_horizontal_forces(length(data_horizontal_forces) + 1) = Force(position, mag)
  set(edit_pos, 'String', "");
  set(edit_mag, 'String', "");
end

function getTorques(hObject, eventdata, edit)
  global data_torques;
  mag = str2double(get(edit, 'String'));
  if (length(data_torques) == 0)
    data_torques = Force(0,0)
  end
  data_torques(length(data_torques) + 1) = Force(0, mag)
  set(edit, 'String', "");
end

function getSupports(hObject, eventdata, edit, listbox)
  global data_supports;
  selection = get(listbox, 'String');
  support_type_str = get(listbox, 'String')
  support_type = SupportType().Dummy
  switch (support_type_str)
    case "Pinned"
      support_type = SupportType().Pinned
    case "Fixed"
      support_type = SupportType().Fixed
    case "Roller"
      support_type = SupportType().Roller
  end

  position = str2double(get(edit, 'String'))
  if (length(data_supports) == 0)
    data_supports = Support(0, SupportType().Dummy)
  end
  data_supports(length(data_supports) + 1) = Support(position, support_type)
  set(edit, 'String', "");
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve the resmat given problem                                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function finish(hObject, eventdata)
  global data_beam_width
  global data_vertical_forces
  global data_horizontal_forces
  global data_torques
  global data_vertical_dist_forces
  global data_supports
  % TODO read this from the real component
  data_vertical_dist_forces = DistForce(0, 0, @(x)(0), @(x)(0)) 
  [v_forces, h_forces, t_forces, m_forces] = lib_resmat.res_mat_1d_solver(
    data_beam_width,
    data_vertical_forces,
    data_horizontal_forces,
    data_torques,
    data_vertical_dist_forces,
    data_supports
);

output_file(v_forces, h_forces, t_forces, m_forces)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear h
UI()