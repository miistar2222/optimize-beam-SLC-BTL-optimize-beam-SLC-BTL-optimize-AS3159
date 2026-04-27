%% Soccer League Competition Algorithm - Ứng dụng Tối ưu Dầm Hàn
clc; clear all; close all;

%% Định nghĩa bài toán
CostFunction = @(x) cost_welded_beam(x); % Trỏ đến hàm dầm hàn vừa tạo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumberofFunctionEvaluation = 50000;
nVar = 4;                           % Dầm hàn có 4 biến: h, l, t, b

nTeam = 5;                          % Số đội bóng
nMainPlayer = 10;                   % Số cầu thủ đá chính (vì nVar=4 nhỏ nên ta fix ở 10)
nReservePlayer = 10;                % Số cầu thủ dự bị

% Giới hạn của biến [h, l, t, b]
VarMin = [0.1, 0.1, 0.1, 0.1];      % Giới hạn dưới của biến
VarMax = [2.0, 10.0, 10.0, 2.0];    % Giới hạn trên của biến
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('example');
addpath('SLC');
tedad = NumberofFunctionEvaluation;
VarSize = [1 nVar];   % Kích thước mảng biến
nEval = 0;

%% Thông số cơ bản của SLC
MaxIt = 10^8;         % Số lượng mùa giải tối đa
pMutation = 0.1;      % Xác suất đột biến
SSay = 0.2;           % Tỷ lệ đột biến
ShareSettings;

%% Khởi tạo giải đấu
League = CreateInitialLeague();

%% Vòng lặp chính của SLC
for it = 1:MaxIt
    
    %% Thi đấu (Competition)
    [League, nEval] = Competition(League, it, nEval);
   
    % Cập nhật thông số đội hình
    League = Takhsis(League);
    
    % Lưu lại thành tích tốt nhất
    BestCost(it) = League(1,1).MPlayer(1,1).Cost;
    BestSol = League(1,1).MPlayer(1,1).Position;
    
    if nEval > tedad
        break
    end
    
    % Hiển thị quá trình
    disp(['Season ' num2str(it) ': Chi phí tối ưu = ' num2str(BestCost(it))])
end

%% Vẽ đồ thị kết quả
figure;
plot(BestCost, 'LineWidth', 2); % Đổi semilogy thành plot thông thường để dễ nhìn
xlabel('Số mùa giải (Seasons)');
ylabel('Chi phí nhỏ nhất (Best Cost)');
title('Biểu đồ hội tụ - SLC cho Tối ưu Dầm Hàn');
grid on;

disp('--- Kết quả Tối ưu ---');
disp(['Biến thiết kế tối ưu [h, l, t, b]: ' num2str(BestSol)]);
disp(['Chi phí nhỏ nhất: ' num2str(BestCost(end))]);