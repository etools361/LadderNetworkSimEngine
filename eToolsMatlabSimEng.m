%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2022-07-05(yyyy-mm-dd)
% 简单的梯形网络仿真引擎
%--------------------------------------------------------------------------
tic;
% 0:V,1:I,2:R,3:L,4:C
% 3rd order butterworth low pass filter
%        V,R,R,C,L,C,R,R
% iType = [0,2,2,4,3,4,2,2];
% Value = [1,1,0,1,2,1,0,1];
% 0:V,1:I,2:R,3:L,4:C
%        V, R,  L,  C,  L, R
% iType = [0, 2,  3,  4,  3, 2];
% Value = [1, 1,1/2,4/3,3/2, 0];
% 0:V,1:I,2:R,3:L,4:C
%          V, R, R,   C,   L,   C
% iType = [0, 2, 2,   4,   3,   4];
% Value = [1, 1, 0, 0.5, 4/3, 1.5];
% 0:V,1:I,2:R,3:L,4:C
%        I, R, R,   C,   L,   C, R, R
iType = [1, 2, 2,   4,   3,   4, 2, 2];
Value = [1, 0, 0, 1.5, 4/3, 0.5, 0, 1];
% iType = [0,2,2,4,3,4,3,4,2,2];
% Value = [1,1,0,1*340e-3,174e-3,448e-3,174e-3,340e-3,0,1];
% iType = [0,2,2,4,3,4,3,4,2,2];
% Value = [1,1,0,98e-3,257e-3,318e-3,257e-3,98e-3,0,1];
% iType = [0,2,2,4,3,4,3,2];
% Value = [1,1,0,98e-3,257e-3,318e-3,257e-3,1];
% high pass filter
% iType = [0,2,2,3,4,3,2,2];
% Value = [1,1,0,52.433e-3,106.733e-3,52.433e-3,0,1];
% iType = [0,2,2,3,4,3,4,3,4,3,2,2];
% Value = [1,1,0,48.973e-3,95.459e-3,34.297e-3,90.415e-3,34.297e-3,95.459e-3,48.973e-3,0,1];
subplot(2, 1, 1);
[img] = funGenSchematic(iType, Value, 1);
ylim([-0.5, 1.5]);
set(gca,'ytick',[]);
set(gca,'xtick',[]);
set(gca,'Box','off');
set(gcf,'color',[1,1,1]);
set(gca,'looseInset',[0 0 0 0]);
axis off;
% set(gca,'LooseInset',get(gca,'TightInset'));
% set(gca,'PlotBoxAspectRatio', [8 2 1])
% figure(2);
f0 = 1e-2;
f1 = 1e1;
N  = 500;
freq = logspace(log10(f0), log10(f1), N);
nV = length(Value);
nZ = fix((nV-2)/2);
Zw = [];
V  = zeros(nZ, 1);
V(1) = Value(1);
Vo = [];
for ii=1:N
    f = freq(ii);
    w = 1i*2*pi*f;
    % 计算阻抗
    for jj=1:nV-1
        % 0:V,1:I,2:R,3:L,4:C
        switch iType(jj+1)
            case 0
                Zw(jj) = 0;
            case 1
                Zw(jj) = 0;
            case 2
                Zw(jj) = Value(jj+1);
            case 3
                Zw(jj) = Value(jj+1)*w;
            case 4
                if Value(jj+1) == 0
                    Zw(jj) = 1e15;
                else
                    Zw(jj) = 1/(w*Value(jj+1));
                end
        end
    end
    % 构造Z矩阵
    Z = zeros(nZ,nZ);
    for jj=1:nZ
        kk1 = jj-1;
        kk3 = jj+1;
        if iType(jj) == 1
            if kk1 >= 1
                Z(jj, kk1) = 0;
            end
            if kk3 <= nZ
                Z(jj, kk3) = 0;
            end
            Z(jj, jj) = 1;
        else
            if kk1 >= 1
                Z(jj, kk1) = -Zw(jj*2-1);
            end
            if kk3 <= nZ
                Z(jj, kk3) = -Zw(jj*2+1);
            end
            Z(jj, jj) = Zw(jj*2+1)+Zw(jj*2+0)+Zw(jj*2-1);
        end
    end
    I = Z\V;
    if Value(end) == 0
        Vo(ii) = I(end);
    else
        Vo(ii) = I(end)*Zw(end);
    end
end
dBVo = 20*log10(abs(Vo));
AgVo = angle(Vo)*180/pi;
uWVo = unwrap(AgVo, 180);
% uWVo = AgVo;
toc;
subplot(2,2,3)
semilogx(freq, dBVo, '-r', 'LineWidth', 2);
grid on;
xlabel('Freq/Hz');
if Value(end) == 0
    ylabel('I_o Mag/dB');
else
    ylabel('V_o Mag/dB');
end
title('FrequencyResponse');
xlim([min(freq),max(freq)]);
ylim([-20,0]);
subplot(2,2,4)
semilogx(freq, uWVo, '-r', 'LineWidth', 2);
xlim([min(freq),max(freq)]);
grid on;
xlabel('Freq/Hz');
if Value(end) == 0
    ylabel('I_o Angle/deg');
else
    ylabel('V_o Angle/deg');
end
title('Phase VS. Freq');
