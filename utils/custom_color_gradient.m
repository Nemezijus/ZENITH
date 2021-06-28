function COL = custom_color_gradient(start_color, end_color, Ncolors)
% COL = custom_color_gradient(start_color, end_color, Ncolors) - creates a
% custom color gradient scheme between start and end colors, with
% equidistant spacing of Ncolors size
if sum(start_color) > 3
    start_color = start_color/255;
end

if sum(end_color) > 3
    end_color = end_color/255;
end
COL = [linspace(start_color(1),end_color(1),Ncolors)', ...
    linspace(start_color(2),end_color(2),Ncolors)', ...
    linspace(start_color(3),end_color(3),Ncolors)'];