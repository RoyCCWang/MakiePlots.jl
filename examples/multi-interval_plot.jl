#=
# A row of subplots for multiple intervals
This is the broken axis plot for 1-D functions, except there are no broken axis tick marks.
=#

import MakiePlots

# Used to randomly generate intervals in this example. Not actually needed in practical application.
import Random
Random.seed!(25)

# # Create functions and intervals

qs = Vector{Function}(undef, 3)
qs[1] = xx->cos(3*xx)
qs[2] = xx->sin(3*xx)
qs[3] = xx->sinc(3*xx)

legend_labels = ["cos"; "sin"; "sinc"]
title = "Waveforms"
y_label = "intensity"
x_label = "time"

# Generate the intervals, a 1-D array of 2-element tuples. The first tuple element is the start of the interval, the second is the end of the interval. Purposely make the first interval much larger than the others.
intervals = collect( (i-rand()*0.5, i+rand()*0.5) for i = 1:length(qs) )
intervals[1] = (0.0, intervals[1][2]) # start at zero to make it longer.

# # Specify physical dimension

# Suppose we have a width constraint of 8.3 cm.
max_width_inches = 8.3 * 2.54

# However, we want to use a size of 8 cm. Do a sanity-check.
width_inches = 8 * 2.54
@assert width_inches < max_width_inches

# The aspect ratio of the entire row of subplots (i.e. the entire figure).
aspect_fig = 0.54


#=
# Visualization settings.
We recommend exporting to a vector-graphics format like `.svg`, then use another software to match the exact resolution and scale restriction of the publication the figure is intended for.

We won't go over self-explanatory options.

## General
=#

title_font_size = 30
grid_visible = false
line_width_list = ones(length(qs)) .* 3.0

save_folder_path = "./output"
save_name = "figure.svg"
pt_per_inch = 72

# default font size for text that isn't specified.
font_size = 12

# Options are: `:solid`, `:dot`, `:dashdot`. In the Julia REPL, type `?MakiePlots.Makie.Lines` for the API documentation for `Makie.lines`.
line_style_list = collect( :solid for _ = 1:length(qs))
line_style_list[1] = :dashdot

# See the example on colors.
plot_colours = MakiePlots.getplotcolors(length(qs), Float64)

# ## Axis
reverse_x_axis = true

x_tick_decimal_places = 2
x_label_font_size = 25
x_tick_label_size = 12

y_tick_decimal_places = 2
y_label_font_size = 25
y_tick_label_size = 12

# Controls the method to compute ticks and locations. Set this to `false` to use `Makie.LinearTicks` instead of `Makie.WilkinsonTicks`.
use_Wilkinson_for_ticks = false

# ## Legend
legend_font_size = 25
legend_orientation = :horizontal # :vertical or :horizontal
legend_line_width = 2

# ## Troubleshooting
# If clipping occurs or the figure goes off page, set this to a small non-zero value. Takes a value betwee `0` and `1`.
width_padding_proportion = 0.0

# # Generate plot

size_inches = (width_inches, aspect_fig*width_inches)

MakiePlots.plotmultiinterval1D(
    qs,
    intervals,
    legend_labels = legend_labels,
    title_font_size = title_font_size,
    title = title,
    width_padding_proportion = width_padding_proportion,
    reverse_x_axis = reverse_x_axis,
    grid_visible = grid_visible,

    color_list = plot_colours,
    line_style_list = line_style_list,
    line_width_list = line_width_list,

    x_label = x_label,
    x_tick_decimal_places = x_tick_decimal_places,
    x_label_font_size = x_label_font_size,
    x_tick_label_size = x_tick_label_size,

    y_label = y_label,
    y_tick_decimal_places = y_tick_decimal_places,
    y_label_font_size = y_label_font_size,
    y_tick_label_size = y_tick_label_size,

    use_Wilkinson_for_ticks = use_Wilkinson_for_ticks,

    legend_font_size = legend_font_size,
    legend_orientation = legend_orientation,
    legend_line_width = legend_line_width,

    save_folder_path = save_folder_path,
    save_name = save_name,
    size_inches = size_inches,
    pt_per_inch = pt_per_inch,
    font_size = font_size,
    )

#src electrondisplay(f) # display in electron display.
