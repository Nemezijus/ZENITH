function AX = autoaxes (fig, rows, cols, borders, interspace)
% AX = autoaxes (fig, rows, cols, borders, intersapce) - automatic axes placement in
% the given figure fig.
% rows, cols - number of rows and columns of axes placement. Total number
% of axes is rows x cols.
%
%Borders - 4 element vector specifying dead zone where axes cannot be
%placed. from [left, right, top, bottom].
%intersapce - 2 element vector specifying spacing between axes
%[Wspace,Hspace]
%all axes placement is done using normalized units!
%2018-5-29 AP

if nargin < 1
    fig = figure;
    rows = 1; cols = 1;
    borders = [0 0 0 0];
%     Wspace = 0.01;
%     Hspace = 0.01;
end
if nargin < 4
    borders = [0 0 0 0];
%     Wspace = 0.01;
%     Hspace = 0.01;
end
if nargin < 5
    Wspace = 0.025;
    Hspace = 0.035;
end
if nargin == 5
    Wspace = interspace(1);
    Hspace = interspace(2);
end
un = 'normalized';

L = borders(1);
R = borders(2);
T = borders(3);
B = borders(4);

remW = 1 - L - R; %remaining width to be used
remH = 1 - T - B; %remaining height to be used



%% axes sizes

axW = (remW-((cols+1)*Wspace))./cols;
axH = (remH-((rows+1)*Hspace))./rows;

%% plotting axes
for ir = 1:rows
    cfrombot = B + remH - axH*ir - Hspace*ir;
    for ic = 1:cols
        cfromleft = L + ic*Wspace + axW*(ic-1);
        AX(ir, ic) = axes(fig,'Units', un, 'Position',[cfromleft cfrombot axW axH]);
    end
end
