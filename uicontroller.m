s1 = dxopenport("COM3");

if ~exist('s1','var')
    disp('  You will need to open the port first. For example')
    disp('    s1=dxopenport');
    return
end
if strcmp(s1.Status,'closed')   % If port is closed, try and open it
    try
        fopen(s1);
    catch ME                    % Report error if port cannot be opened
        disp(ME.message);
        fclose(s1);
        error('THROW: oops can''t open s1')
    end
end

%-------------------------------------------------------------------------
% Choose which Dynamixel to control
ID = 2;                         % edit this if Dynamixel ID has changed
stat = dxpingport(ID, s1);      % check that the dynamixel responds

%-------------------------------------------------------------------------

% Setup routine

dxwrite(ID, 24, 0, s1);     % turns off torque for editing control mode
dxwrite(ID, 6, 256, s1);      % min position CW 256
dxwrite(ID, 8, 768, s1);      % max position CCW 768
dxwrite(ID, 34, 1023, s1);
dxwrite(ID, 24, 1, s1);     % turns on torque for servo useage
dxwrite(ID, 32, 0, s1);     % sets velocity to 0 (precautionary step)

%--------------------------------------------------------------------------

% reset to initial position

dxwrite(ID, 32, 1000, s1);
dxwrite(ID, 30, 512, s1);
dxwrite(ID, 32, 0, s1);
pause(0.2)

%--------------------------------------------------------------------------

% creating the ui!

fig = uifigure('KeyPressFcn', @key_pressed, 'KeyReleaseFcn', @key_released);
set(fig, 'UserData', 1)

% used state buttons linked to keypresses. If we just use keypresses, the
% callback will repeat too quickly, not giving time for the function to
% complete

label_w = uibutton(fig, "state", "Text", 'W', 'Position', [230 250 100 100], ...
    BackgroundColor=[1 1 1], HorizontalAlignment= 'center');

label_s = uibutton(fig, "state", "Text", 'S', 'Position', [230 120 100 100], ...
    BackgroundColor=[1 1 1], HorizontalAlignment= 'center');

label_a = uibutton(fig, "state", "Text", 'A', 'Position', [100 120 100 100], ...
    BackgroundColor=[1 1 1], HorizontalAlignment= 'center');

label_d = uibutton(fig, "state", "Text", 'D', 'Position', [360 120 100 100], ...
    BackgroundColor=[1 1 1], HorizontalAlignment= 'center');

% while loop so that it can happen continuously, not ideal but I haven't
% found a better way yet

while true
    if label_w.Value == 1 % if w is pressed
        dxwrite(ID, 32, 1000, s1); % setting velocity
        rotate(s1); % calling the rotate button
    end

    if label_w.Value == 0
        dxwrite(ID, 32, 0, s1);
    end

end

% function linked to keypresses
function key_pressed(hObject, eventdata) %hObject stores the fig data
labels = allchild(hObject); % getting the handles for the buttons
if eventdata.Key == 'w'
    set(labels(4), 'Value', 1); % changing the state of the buttons
end
end

% function linked to key releases
function key_released(hObject, eventdata)
labels = allchild(hObject); % getting the handles for the buttons
if eventdata.Key == 'w'
    set(labels(4), 'Value', 0); % changing the state of the buttons
end
end

