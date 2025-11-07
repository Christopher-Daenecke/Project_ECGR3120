clc; clear; close all;

% --- Physical & system parameters ---
Vx = 20;                  % horizontal velocity (m/s)
D = 3e-3;                 % total distance to paper (m)
L1 = 0.5e-3;              % capacitor length (m)
L2 = 1.25e-3;             % distance from capacitor to paper (m)
dpi = 300;                % resolution
pitch_mm = 25.4 / dpi;    % spacing in mm
pitch = pitch_mm / 1e3;   % spacing in meters
line_height_mm = 1;       % max height in mm
N = floor(line_height_mm / pitch_mm); % number of droplets 
dt = 1e-6;                % time step for animation (s)

% --- Capacitor timing ---
T = L1 / Vx;              % time inside capacitor
t2 = L2 / Vx;             % time after capacitor

% --- Droplet gun vertical position ---
y_gun = 0;                % Droplet gun at y = 0 meters

% --- Plot setup ---
figure('Color','w');
set(gcf, 'Position', [100, 100, 1400, 800]);  
hold on; grid on; axis equal;
xlabel('Horizontal position (mm)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Vertical position (mm)', 'FontSize', 12, 'FontWeight', 'bold');
title('Drawing Vertical "I"', 'FontSize', 14, 'FontWeight', 'bold');
set(gca,'XTick',0:0.5:4, 'FontSize', 12);
set(gca, 'GridAlpha', 0.3);
axis([-0.5 4 -2.5 2.5]); % centered view

% --- Draw droplet gun ---
gun_x = [-0.2 0 0 -0.2]; % mm
gun_y = [-0.2 -0.2 0.2 0.2]; % mm
fill(gun_x, gun_y, [0.3 0.3 0.3], 'EdgeColor','k');
text(-0.18, 0.25, 'Droplet Gun', 'FontSize', 11, 'FontWeight', 'bold');

% --- Draw capacitor plates ---
x_cap_start = 1.25; % mm
x_cap_end = 1.75;   % mm
gap_mm = 1;         % mm
plate_thickness = 0.2; % mm

fill([x_cap_start x_cap_end x_cap_end x_cap_start], ...
     [gap_mm/2 gap_mm/2 gap_mm/2 + plate_thickness gap_mm/2 + plate_thickness], ...
     [0.7 0.9 1], 'EdgeColor', 'k'); % top plate

fill([x_cap_start x_cap_end x_cap_end x_cap_start], ...
     [-gap_mm/2 -gap_mm/2 -gap_mm/2 - plate_thickness -gap_mm/2 - plate_thickness], ...
     [0.7 0.9 1], 'EdgeColor', 'k'); % bottom plate

text((x_cap_start + x_cap_end)/2 - 0.1, gap_mm/2 + 0.6, 'Capacitor Plates', 'FontSize', 11, 'FontWeight', 'bold');

% --- Draw paper target ---
xline(D*1e3, '--k', 'Paper', 'LabelHorizontalAlignment','right','LabelVerticalAlignment','middle','FontSize',11, 'FontWeight','bold');

% --- Animate droplets (centered top to bottom) ---
for i = 1:N
    y_target = ((N - i + 1) - (N+1)/2) * pitch;  % top to bottom, centered
    Vy = (y_target - y_gun) / t2;              % required vertical velocity
    ay = Vy / T;                               % required vertical acceleration

    t_flight = D / Vx;
    t = 0:dt:t_flight;
    droplet = plot(0, y_gun*1e3, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 5, 'LineWidth', 1);

    for j = 1:length(t)
        x = Vx * t(j);
        if x <= x_cap_start/1e3
            y = y_gun;
        elseif x <= x_cap_end/1e3
            t_in = t(j) - x_cap_start/1e3 / Vx;
            y = y_gun + 0.5 * ay * t_in^2;
        else
            y_cap_exit = y_gun + 0.5 * ay * T^2;
            Vy_final = ay * T;
            t_out = t(j) - x_cap_end/1e3 / Vx;
            y = y_cap_exit + Vy_final * t_out;
        end
        set(droplet, 'XData', x*1e3, 'YData', y*1e3);
        if mod(j,10)==0
            drawnow;
        end
    end
end

% --- Display total draw time ---
total_time = N * t_flight;
fprintf('Total time to draw vertical "I": %.3f ms\n', total_time*1e3);