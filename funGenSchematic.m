%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2022-07-05(yyyy-mm-dd)
% 由网表生成原理图
%--------------------------------------------------------------------------
function [img] = funGenSchematic(iType, Value, DispEn)
img = [];
if DispEn
    x0 = 0;
    y0 = 0;
    plot(x0,y0);
    n = length(iType);
    for ii=1:n
        r = mod(ii+1, 2);
        if ii==1
            r = 1;
        elseif ii==2
            r = 0;
        end
        if r == 1
            y2 = x0;
            x2 = 0;
        else
            x2 = x0;
            y2 = y0;
            [x2, y2] = funGenLine([x2,x2+0.25], [y2,y2], 0);
        end
        % 0:V,1:I,2:R,3:L,4:C
        switch iType(ii)
            case 0 % V
                [x1, y1] = funGenV(x2, y2, r);
                funGenText(x1, y1, r, Value(ii), 'V');
                text(x1-0.15, y1+0.12, 'V_i', 'FontSize',12, 'FontWeight', 'bold');
                y0 = y1;
            case 1 % I
            case 2 % R
                if Value(ii) == 0
                    if ii ~= 3
                        if r==0
                            [x1, y1] = funGenLine([x2,x2+0.25], [y2,y2], r);
                        else
                            [x1, y1] = funGenLine([x2,x2+1], [y2,y2], r);
                        end
                    end
                else
                    [x1, y1] = funGenR(x2, y2, r);
                    funGenText(x1, y1, r, Value(ii), '\Omega');
                end
            case 3 % L
                [x1, y1] = funGenL(x2, y2, r);
                funGenText(x1, y1, r, Value(ii), 'H');
            case 4 % C
                [x1, y1] = funGenC(x2, y2, r);
                funGenText(x1, y1, r, Value(ii), 'F');
        end
        if r == 1
            funGenGND(x0, 0, r);
            if ii>1 && ii < n
                funGenPoint(x0, y0, 0);
            end
        else
            if ii < n
                [x1, y1] = funGenLine([x1,x1+0.25], [y1,y1], 0);
            end
        end
         x0 = x1;
         y0 = y1;
    end
    if Value(end) == 0
        text(x0+0.1, y0+0.1, 'I_o', 'FontSize',12, 'FontWeight', 'bold');
    else
        text(x0+0.1, y0+0.1, 'V_o', 'FontSize',12, 'FontWeight', 'bold');
    end
    axis equal;
end

function [x, y]=funGenText(x, y, r, Value, strUnit)
hold on;
if r == 0
    text(x-0.1, y+0.15, [Data2Suffix(Value, '0.2'), strUnit], 'FontSize',12, 'FontWeight', 'bold');
else
    text(x+0.1, y-0.95, [Data2Suffix(Value, '0.2'), strUnit], 'FontSize',12, 'FontWeight', 'bold');
end
hold off;

function [x, y]=funGenPoint(x, y, r)
hold on;
if r == 0
    plot(x, y, '-ok', 'LineWidth', 6);
else
    plot(y, x, '-ok', 'LineWidth', 6);
end
hold off;

function [x0,y0]=funGenLine(x, y, r)
hold on;
if r == 0
    plot(x, y, '-k', 'LineWidth', 2);
    x0 = x(end);
    y0 = y(end);
else
    plot(y, x, '-k', 'LineWidth', 2);
    x0 = y(end);
    y0 = x(end);
end
hold off;

function [x0, y0]=funGenR(x, y, r)
rb = 0.2;
ll = 1.0;
rh = 0.25;
rv = ll-2*rb;
hold on;
if r == 0
    plot([x, x+rb], [y, y], '-k', 'LineWidth', 2);
    plot([x+ll-rb, x+ll], [y, y], '-k', 'LineWidth', 2);
    plot([x+rb, x+rb, x+rb+rv, x+rb+rv, x+rb, x+rb], [y+rh/2, y-rh/2, y-rh/2, y+rh/2, y+rh/2, y-rh/2], '-k', 'LineWidth', 4);
    x0 = x+ll;
    y0 = y;
else
    plot([y, y], [x, x+rb], '-k', 'LineWidth', 2);
    plot([y, y], [x+ll-rb, x+ll], '-k', 'LineWidth', 2);
    plot([y+rh/2, y-rh/2, y-rh/2, y+rh/2, y+rh/2, y-rh/2], [x+rb, x+rb, x+rb+rv, x+rb+rv, x+rb, x+rb], '-k', 'LineWidth', 4);
    x0 = y;
    y0 = x+ll;
end
hold off;

function [x0, y0]=funGenC(x, y, r)
rb = 0.45;
ll = 1.0;
rh = 0.5;
hold on;
if r == 0
    plot([x, x+rb], [y, y], '-k', 'LineWidth', 2);
    plot([x+ll-rb, x+ll], [y, y], '-k', 'LineWidth', 2);
    plot([x+rb, x+rb], [y+rh/2, y-rh/2], '-k', 'LineWidth', 4);
    plot([x+ll-rb, x+ll-rb], [y+rh/2, y-rh/2], '-k', 'LineWidth', 4);
    x0 = x+ll;
    y0 = y;
else
    plot([y, y], [x, x+rb], '-k', 'LineWidth', 2);
    plot([y, y], [x+ll-rb, x+ll], '-k', 'LineWidth', 2);
    plot([y+rh/2, y-rh/2], [x+rb, x+rb], '-k', 'LineWidth', 4);
    plot([y+rh/2, y-rh/2], [x+ll-rb, x+ll-rb], '-k', 'LineWidth', 4);
    x0 = y;
    y0 = x+ll;
end
hold off;

function [x0, y0]=funGenL(x, y, r)
rb = 0.18;
ll = 1.0;
r0 = ll-rb*2;
lx = linspace(x+rb, x+ll-rb, 49);
hold on;
if r == 0
    plot([x, x+rb], [y, y], '-k', 'LineWidth', 2);
    plot([x+ll-rb, x+ll], [y, y], '-k', 'LineWidth', 2);
    plot(lx, y+0.2.*abs(sin((lx-rb-x)./r0.*4.*pi)).^0.5-0.005, '-k', 'LineWidth', 4);
    x0 = x+ll;
    y0 = y;
else
    plot([y, y], [x, x+rb], '-k', 'LineWidth', 2);
    plot([y, y], [x+ll-rb, x+ll], '-k', 'LineWidth', 2);
    plot(y+0.2.*abs(sin((lx-rb-x)./r0.*4.*pi)).^0.5-0.005, lx, '-k', 'LineWidth', 4);
    x0 = y;
    y0 = x+ll;
end
hold off;

function [x0, y0]=funGenGND(x, y, r)
rb = 0.18;
dy = 0.1;
dx0 = 0.4;
dx1 = 0.25;
dx2 = 0.1;
hold on;
if r == 0
    plot([y, y-rb], [x, x], '-k', 'LineWidth', 2);
    plot([y-rb, y-rb], [x-dx0/2, x+dx0/2], '-k', 'LineWidth', 4);
    plot([y-rb-dy, y-rb-dy], [x-dx1/2, x+dx1/2], '-k', 'LineWidth', 4);
    plot([y-rb-dy*2, y-rb-dy*2], [x-dx2/2, x+dx2/2], '-k', 'LineWidth', 4);
    x0 = y;
    y0 = x;
else
    plot([x, x], [y, y-rb], '-k', 'LineWidth', 2);
    plot([x-dx0/2, x+dx0/2], [y-rb, y-rb], '-k', 'LineWidth', 4);
    plot([x-dx1/2, x+dx1/2], [y-rb-dy, y-rb-dy], '-k', 'LineWidth', 4);
    plot([x-dx2/2, x+dx2/2], [y-rb-dy*2, y-rb-dy*2], '-k', 'LineWidth', 4);
    x0 = x;
    y0 = y;
end
hold off;

function [x0, y0]=funGenV(x, y, r)
rb = 0.18;
ll = 1.0;
d0 = ll-rb*2;
d1 = 0.2;
d2 = 0.15;
lx = linspace(0, 2*pi, 41);
hold on;
if r == 0
    plot([x, x+rb], [y, y], '-k', 'LineWidth', 2);
    plot([x+ll-rb, x+ll], [y, y], '-k', 'LineWidth', 2);
    plot(d0/2.*cos(lx)+x+ll/2, d0/2.*sin(lx)+y, '-k', 'LineWidth', 4);
    plot([x+ll-rb-d1+d2, x+ll-rb-d1], [y, y], '-k', 'LineWidth', 4);
    plot([x+ll-rb-d1+d2/2, x+ll-rb-d1+d2/2], [y-d2/2, y+d2/2], '-k', 'LineWidth', 4);
    plot([x+rb+d1-d2/2, x+rb+d1-d2/2], [y-d2/2, y+d2/2], '-k', 'LineWidth', 4);
    x0 = x+ll;
    y0 = y;
else
    plot([y, y], [x, x+rb], '-k', 'LineWidth', 2);
    plot([y, y], [x+ll-rb, x+ll], '-k', 'LineWidth', 2);
    plot(d0/2.*sin(lx)+y, d0/2.*cos(lx)+x+ll/2, '-k', 'LineWidth', 4);
    plot([y, y], [x+ll-rb-d1+d2, x+ll-rb-d1], '-k', 'LineWidth', 4);
    plot([y-d2/2, y+d2/2], [x+ll-rb-d1+d2/2, x+ll-rb-d1+d2/2], '-k', 'LineWidth', 4);
    plot([y-d2/2, y+d2/2], [x+rb+d1-d2/2, x+rb+d1-d2/2], '-k', 'LineWidth', 4);
    x0 = x;
    y0 = y+ll;
end
hold off;

