function cost = cost_welded_beam(x)
    % Khai báo 4 biến thiết kế
    h = x(1); % Bề dày đường hàn (x1)
    l = x(2); % Chiều dài đường hàn (x2)
    t = x(3); % Chiều cao dầm (x3)
    b = x(4); % Bề rộng dầm (x4)

    % Các thông số kỹ thuật cố định
    P = 6000;         % Tác dụng lực (lb)
    L = 14;           % Chiều dài dầm (in)
    E = 30e6;         % Mô đun đàn hồi Young (psi)
    G = 12e6;         % Mô đun trượt (psi)
    tau_max = 13600;  % Ứng suất cắt tối đa (psi)
    sigma_max = 30000; % Ứng suất uốn tối đa (psi)
    delta_max = 0.25; % Độ võng tối đa (in)

    % 1. Tính toán chi phí chế tạo (Hàm mục tiêu ban đầu)
    cost = 1.10471 * h^2 * l + 0.04811 * t * b * (14 + l);

    % 2. Tính toán các giá trị cơ học
    M = P * (L + l / 2);
    R = sqrt(l^2 / 4 + ((h + t) / 2)^2);
    J = 2 * sqrt(2) * h * l * (l^2 / 12 + ((h + t) / 2)^2);
    
    tau1 = P / (sqrt(2) * h * l);
    tau2 = M * R / J;
    tau = sqrt(tau1^2 + 2 * tau1 * tau2 * l / (2 * R) + tau2^2);
    
    sigma = 6 * P * L / (b * t^2);
    delta = 4 * P * L^3 / (E * b * t^3);
    Pc = (4.013 * E * sqrt(t^2 * b^6 / 36) / L^2) * (1 - t / (2 * L) * sqrt(E / (4 * G)));

    % 3. Khai báo 7 phương trình ràng buộc (g <= 0)
    g = zeros(7, 1);
    g(1) = tau - tau_max;                                      % Ràng buộc ứng suất cắt
    g(2) = sigma - sigma_max;                                  % Ràng buộc ứng suất uốn
    g(3) = P - Pc;                                             % Ràng buộc lực oằn
    g(4) = 0.125 - h;                                          % Ràng buộc kích thước h
    g(5) = delta - delta_max;                                  % Ràng buộc độ võng
    g(6) = 0.10471 * h^2 + 0.04811 * t * b * (14 + l) - 5;     % Ràng buộc chi phí cố định
    g(7) = h - b;                                              % Ràng buộc h <= b

    % 4. Áp dụng hàm phạt (Penalty) nếu vi phạm ràng buộc
    violation = max(0, g);       % Lấy các giá trị vượt quá 0
    penalty_weight = 1e10;       % Trọng số phạt cực lớn giống tài liệu
    penalty = sum(violation.^2) * penalty_weight; 
    
    % Cộng tiền phạt vào chi phí
    cost = cost + penalty;
end