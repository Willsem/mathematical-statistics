function lab2()
    X = dlmread('sample.txt');
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
% [in] gamma - ������������� ������������ ������
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
% [in] gamma - ������������� ������������ ������
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
% [in] gamma - ������������� ������������ ������
% [in] pointEst - ������� �������� ������
% [in] borders - ������� ���������� ������ �������������� ���������
% [in] label1 - ������� � ������� �������� ������ �� N
% [in] label2 - ������� � ������� �������� ������ �� n
% [in] label3 - ������� � ������� ������� ������� �� n
% [in] label4 - ������� � ������� ������ ������� �� n
function graph(X, gamma, pointEst, borders, label1, label2, label3, label4)
    n = length(X);

    figure
    plot([1, n], [pointEst(X), pointEst(X)]);
    hold on;
    grid on;

    arr = zeros(1, n);
    arrBottom = zeros(1, n);
    arrTop = zeros(1, n);

    for i = 1:n
        arr(i) = pointEst(X(1:i));
        [arrBottom(i), arrTop(i)] = borders(X(1:i), gamma);
    end

    plot(1:n, arr);
    plot(1:n, arrBottom);
    plot(1:n, arrTop);

    legend(label1, label2, label3, label4);
    hold off;
end