button_width = 100;

% General properties
component_height = 40;
left_margin = 10;

% Text properties
text_width = 240;

% Edit text properties
edit_text_x_pos = left_margin + text_width;
edit_text_width = 70;

% Add button properties
add_button_x_position = edit_text_x_pos + edit_text_width;
add_button_width = 50;

% create figure and panel on it
f = figure();

% create a button (default style)
b1 = uicontrol (f, "string", "Load Config", "position",[left_margin 370 button_width component_height]);

% create an edit control
text_beam_width               = uicontrol (f, "style", "edit", "string", "Beam width [m]: ", "position",[left_margin 100 text_width 40], "enable", "inactive");
edit_beam_width               = uicontrol (f, "style", "edit", "string", "", "position", [edit_text_x_pos 100 edit_text_width 40]);
button_add_beam               = uicontrol (f, "string", "+", "position", [add_button_x_position 100 add_button_width 40]);

text_vertical_forces          = uicontrol (f, "style", "edit", "string", "Vertical force [N]: ", "position",[left_margin 140 text_width 40], "enable", "inactive");
edit_vertical_forces          = uicontrol (f, "style", "edit", "string", "", "position",[edit_text_x_pos 140 edit_text_width 40]);
button_add_vertical_forces    = uicontrol (f, "string", "+", "position", [add_button_x_position 140 add_button_width 40]);

text_horizontal_forces        = uicontrol (f, "style", "edit", "string", "Horizontal force [N]: ", "position",[left_margin 180 text_width 40], "enable", "inactive");
edit_horizontal_forces        = uicontrol (f, "style", "edit", "string", "", "position",[edit_text_x_pos 180 edit_text_width 40]);
button_add_horizontal_forces  = uicontrol (f, "string", "+", "position", [add_button_x_position 180 add_button_width 40]);

text_torque                   = uicontrol (f, "style", "edit", "string", "Torque [Nm]: ", "position",[left_margin 220 text_width 40], "enable", "inactive");
edit_torque                   = uicontrol (f, "style", "edit", "string", "", "position",[edit_text_x_pos 220 edit_text_width 40]);
button_add_torque             = uicontrol (f, "string", "+", "position", [add_button_x_position 220 add_button_width 40]);

text_horizontal_support       = uicontrol (f, "style", "edit", "string", "Horizontal support x position [m]: ", "position",[left_margin 260 text_width 40], "enable", "inactive"); 
edit_horizontal_support       = uicontrol (f, "style", "edit", "string", "", "position",[edit_text_x_pos 260 edit_text_width 40]); 
button_add_horizontal_support = uicontrol (f, "string", "+", "position", [add_button_x_position 260 add_button_width 40]);

button_save = uicontrol (f, "string", "Save Input", "position",[left_margin 55 button_width component_height]);
button_solve = uicontrol (f, "string", "Solve", "position",[left_margin + button_width 55 button_width component_height]);