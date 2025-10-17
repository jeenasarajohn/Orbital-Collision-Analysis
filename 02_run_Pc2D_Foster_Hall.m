%% ==========================================================
%  NASA CARA Probability of Collision Analysis
%  Real Satellite Case: ISS (ZARYA) vs FENGYUN 1C DEBRIS
%  Author: Jeena John
%  Date: 2025-10-17
% ===========================================================

clear; clc; close all;

%% === Real Satellite Data (from Python SGP4 Propagation) ===
r1 = [361072.01742653, -5855825.03228035, -3439662.56463015]; % ISS (m)
v1 = [5331.5014451, 3023.3758248, -4586.259421];               % ISS (m/s)
r2 = [3585850.10346469, -1430848.27747341, 6546042.25607649]; % FY-1C Debris (m)
v2 = [-6165.11115826, -6.09129248, 3842.8220797];              % FY-1C Debris (m/s)

%% === Convert meters to kilometers (CARA uses km) ===
r1 = r1 / 1000;
v1 = v1 / 1000;
r2 = r2 / 1000;
v2 = v2 / 1000;

%% === Define Covariances (assumed, km²) ===
C1 = diag([0.3, 0.3, 0.3, 0.05, 0.05, 0.05]).^2;  % ISS
C2 = diag([0.5, 0.5, 0.5, 0.05, 0.05, 0.05]).^2;  % FY-1C debris

HBR = 0.01;      % Combined hard-body radius (10 m = 0.01 km)
RelTol = 1e-8;

%% === Run Pc2D Foster ===
[Pc_Foster, ~, ~, ~] = Pc2D_Foster(r1, v1, C1(1:3,1:3), r2, v2, C2(1:3,1:3), HBR, RelTol, 'circle');

%% === Run Pc2D Hall ===
params = struct();
[Pc_Hall, ~] = Pc2D_Hall(r1, v1, C1, r2, v2, C2, HBR, params);

%% === Display Results ===
fprintf('=== Collision Probability (ISS vs FENGYUN 1C DEB) ===\n');
fprintf('Pc (Foster 2D): %.3e\n', Pc_Foster);
fprintf('Pc (Hall 2D):   %.3e\n', Pc_Hall);

%% === Visualize Close Approach Geometry ===
figure;
hold on; grid on; axis equal;

% Covariance ellipse (combined uncertainty)
cov_combined = C1(1:3,1:3) + C2(1:3,1:3);
[vec, val] = eig(cov_combined(1:2,1:2));
theta = linspace(0, 2*pi, 200);
ellipse = (vec * sqrt(val)) * [cos(theta); sin(theta)];
fill(ellipse(1,:), ellipse(2,:), [0.6 0.7 1], 'FaceAlpha', 0.4, 'EdgeColor', 'b', 'LineWidth', 1.2);

% Hard body radius
viscircles([0,0], HBR, 'Color', 'r', 'LineWidth', 1);

title('Close Approach Geometry: ISS vs FENGYUN 1C DEBRIS');
xlabel('Radial (km)');
ylabel('Cross-track (km)');
legend('Uncertainty Ellipse (Combined Covariance)', 'Hard-Body Radius', 'Location', 'best');

