clc; clear; close all;

% --- Given parameters (SI) ---
Vx = 20;          % horizontal velocity (m/s)
Vy = 0;           % vertical velocity (m/s)
D = 3e-3;         % distance to paper (m)
Lcap = 0.5e-3;    % capacitor length (m)
gap = 1e-3;       % gap between plates (m)
x_cap_start = 1.25e-3; % capacitor starts 1.25 mm from droplet gun
x_cap_end = x_cap_start + Lcap;

% --- Simulation parameters ---
dt = 1e-6;        % time step (s) - smaller for smoother animation
t_end = D / Vx;   % total flight time (s)
t = 0:dt:t_end;

% --- Convert to mm for plotting ---
conv = 1e3;
x_cap_start_mm = x_cap_start * conv;
x_cap_end_mm = x_cap_end * conv;
D_mm = D * conv;
gap_mm = gap * conv;

% --- Figure setup ---
figure('Color','w');
hold on; grid on; axis equal;
xlabel('Horizontal position (mm)');
ylabel('Vertical position (mm)');
title('Droplet Motion (No Voltage Applied)');
set(gca,'XTick',0:0.5:3);

% --- Draw droplet gun (nozzle) in mm ---
gun_x = [-0.2 0 0 -0.2]; % mm
gun_y = [-0.2 -0.2 0.2 0.2]; % mm
fill(gun_x, gun_y, [0.3 0.3 0.3], 'EdgeColor','k');
text(-0.18, 0.25, 'Droplet Gun', 'FontSize', 9);
%{
% --- Draw capacitor plates (mm) ---
plate_thickness = 0.2; % mm
fill([x_cap_start_mm x_cap_end_mm x_cap_end_mm x_cap_start_mm], ...
     [ gap_mm/2 gap_mm/2 gap_mm/2 + plate_thickness gap_mm/2 + plate_thickness], ...
     [0.7 0.9 1], 'EdgeColor', 'k');
fill([x_cap_start_mm x_cap_end_mm x_cap_end_mm x_cap_start_mm], ...
     [ -gap_mm/2 -gap_mm/2 -gap_mm/2 - plate_thickness -gap_mm/2 - plate_thickness], ...
     [0.7 0.9 1], 'EdgeColor', 'k');
text((x_cap_start_mm + x_cap_end_mm)/2 - 0.1, gap_mm/2 + 0.6, 'Capacitor Plates', 'FontSize', 9);
%}

plate_top_y =  gap/2 * 1e3; % in mm
plate_bot_y = -gap/2 * 1e3;

fill([x_cap_start x_cap_end x_cap_end x_cap_start]*1e3, ...
     [plate_top_y plate_top_y plate_top_y+0.05 plate_top_y+0.05], ...
     [0.7 0.9 1], 'EdgeColor', 'k'); % top plate
fill([x_cap_start x_cap_end x_cap_end x_cap_start]*1e3, ...
     [plate_bot_y plate_bot_y plate_bot_y-0.05 plate_bot_y-0.05], ...
     [0.7 0.9 1], 'EdgeColor', 'k'); % bottom plate
text((x_cap_start+Lcap/2)*1e3 - 0.1, plate_top_y+0.2, 'Capacitor Plates', 'FontSize', 9);


% --- Draw paper target ---
xline(D_mm, '--k', 'Paper', 'LabelHorizontalAlignment','right','LabelVerticalAlignment','middle','FontSize',9);

% --- Axis limits ---
axis([-0.5 3.5 -2 2]);

% --- Initialize droplet (mm) ---
droplet = plot(0, 0, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 6);

% --- Animate droplet motion ---
for i = 1:length(t)
    x = Vx * t(i); % m
    y = Vy * t(i); % m
    set(droplet, 'XData', x*conv, 'YData', y*conv);
    if mod(i,10)==0
        drawnow;
    end
end

% --- Display flight time ---
fprintf('Droplet reached the paper in %.3e s (%.3f ms)\n', t_end, t_end*1e3);
