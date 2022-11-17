function rotate(s1)
ID = 2;

dxwrite(ID, 30, 768, s1); %setting goal position to 768 (CCW)
pause(0.3);
dxwrite(ID, 30, 512, s1); %setting goal position back to start (512)
pause(0.3);
dxwrite(ID, 30, 256, s1); %going right
pause(0.3);
dxwrite(ID, 30, 512, s1); %back to start
pause(0.3);

end

