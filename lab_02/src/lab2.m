function lab2()
    X = [...
        -7.50,-6.61,-7.85,-7.72,-8.96,-6.55,-7.82,-6.55,-6.87,-5.95,...
        -5.05,-4.56,-6.14,-6.83,-6.33,-7.67,-4.65,-6.30,-8.01,-5.88,...
        -5.38,-7.06,-6.85,-5.53,-7.83,-5.89,-7.57,-6.76,-6.02,-4.62,...
        -8.55,-6.37,-7.52,-5.78,-6.12,-8.82,-5.14,-7.68,-6.14,-6.48,...
        -7.14,-6.25,-7.32,-5.51,-6.97,-7.86,-7.04,-6.24,-6.41,-6.00,...
        -7.46,-6.00,-6.06,-5.94,-5.39,-5.06,-6.91,-8.06,-7.24,-6.42,...
        -8.73,-6.20,-7.35,-5.90,-5.02,-5.93,-7.56,-7.49,-6.26,-6.06,...
        -7.35,-5.10,-6.52,-7.97,-5.71,-7.62,-7.33,-5.31,-6.21,-7.28,...
        -7.99,-4.65,-7.07,-7.31,-7.72,-5.22,-7.00,-7.17,-6.64,-7.00,...
        -6.12,-6.57,-6.07,-6.65,-7.60,-6.92,-6.78,-6.85,-7.90,-7.40,...
        -5.32,-6.58,-6.71,-5.07,-5.80,-4.87,-5.90,-7.43,-7.03,-6.67,...
        -7.72,-5.83,-7.49,-6.68,-6.71,-7.31,-7.83,-7.92,-5.97,-6.34 ...
    ];

    gamma = 0.9;

    [Mu, S2] = pointEstimate(X);
    fprintf("Mu = %.2f\n", Mu);
    fprintf("S^2 = %.2f\n", S2);

    [bottomMu, topMu] = bordersMu(X, gamma);
    fprintf("mu in (%.2f; %.2f)\n", bottomMu, topMu);

    [bottomS, topS] = bordersS(X, gamma);
    fprintf("sigma in (%.2f; %.2f)\n", bottomS, topS);

    graph(X, gamma, @mean, @bordersMu, ...
        'Mu(N)', 'Mu(n)', 'Bottom Mu(n)', 'Top Mu(n)');
    graph(X, gamma, @var, @bordersS, ...
        'Sigma(N)', 'Sigma(n)', 'Bottom Sigma(n)', 'Top Sigma(n)');
end

% �������� ������
% [in] X - ����������� ������������
% [out] Mu - �������� ������ ��������������� ��������
% [out] S2 - �������� ������ ���������
function [Mu, S2] = pointEstimate(X)
    Mu = mean(X);
    S2 = var(X);
end

% ������� �������������� ��������� ��� ��������������� ��������
% [in] X - ����������� ������������
% [in] gamma - ������� �������������� ���������
% [out] bottom - ������ ������� �������������� ���������
% [out] top - ������� ������� �������������� ���������
function [bottom, top] = bordersMu(X, gamma)
    n = length(X);
    average = mean(X);
    S = sqrt(var(X));
    alpha = (1 + gamma) / 2;
    interval = S / sqrt(n) * tinv(alpha, n - 1);

    bottom = average - interval;
    top    = average + interval;
end

% ������� �������������� ��������� ��� ���������
% [in] X - ����������� ������������
% [in] gamma - ������� �������������� ���������
% [out] bottom - ������ ������� �������������� ���������
% [out] top - ������� ������� �������������� ���������
function [bottom, top] = bordersS(X, gamma)
    n = length(X);
    S2 = var(X);

    bottom = (n - 1) * S2 / chi2inv((1 + gamma) / 2, n - 1);
    top    = (n - 1) * S2 / chi2inv((1 - gamma) / 2, n - 1);
end

% ���������� ��������
% [in] X - ����������� ������������
% [in] gamma - ������� �������������� ���������
% [in] pointEst - ������� �������� ������
% [in] borders - ������� ���������� ������ �������������� ���������
% [in] label1 - ������� � ������� �������� ������ �� N
% [in] label2 - ������� � ������� �������� ������ �� n
% [in] label3 - ������� � ������� ������� ������� �� n
% [in] label4 - ������� � ������� ������ ������� �� n
function graph(X, gamma, pointEst, borders, label1, label2, label3, label4)
    n = length(X);

    figure
    plot([10, n], [pointEst(X), pointEst(X)]);
    hold on;
    grid on;

    arr = zeros(1, n);
    arrBottom = zeros(1, n);
    arrTop = zeros(1, n);

    for i = 10:n
        arr(i) = pointEst(X(1:i));
        [arrBottom(i), arrTop(i)] = borders(X(1:i), gamma);
    end

    plot(10:n, arr(10:n));
    plot(10:n, arrBottom(10:n));
    plot(10:n, arrTop(10:n));

    legend(label1, label2, label3, label4);
    hold off;
end