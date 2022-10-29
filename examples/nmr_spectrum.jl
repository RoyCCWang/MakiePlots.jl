# using CairoMakie
# CairoMakie.activate!()

# using ElectronDisplay
# ElectronDisplay.CONFIG.single_window = true


import Random
Random.seed!(25)


#include("./helpers/broken_axis_1D.jl")
import MakiePlots


legend_labels = ["cos"; "sin"; "sinc"]
title = "Agmatine spectrum (real part), 600 MHz"
#y_label = "Relative intensity"
y_label = ""
x_label = "ppm"

# tuning parameter if goes off page.
width_padding_proportion = 0.0 # between 0 and 1. Recommend a small number. Increase if there are clipping issues.

###

# publication format.
# https://www.rsc.org/journals-books-databases/author-and-reviewer-hub/authors-information/prepare-and-format/figures-graphics-images/
max_width_inches = 8.3 * 2.54 # 8 cm for single column figures, 17 cm for double column figures.

## user settings.
intervals = collect( (i-rand()*0.5,i+rand()*0.5) for i = 1:4 )
intervals[1] = (0.0, intervals[1][2]) # make the first interval large.

qs = Vector{Function}(undef, 3)
qs[1] = xx->cos(3*xx)
qs[2] = xx->sin(3*xx)
qs[3] = xx->sinc(3*xx)

aspect_fig = 0.54 # as the user desires.
width_inches = 8 * 2.54
@assert width_inches < max_width_inches

line_style_list = collect( :solid for _ = 1:length(qs))
line_width_list = ones(length(qs)) .* 3.0

## end user settings.

size_inches = (max_width_inches, aspect_fig*max_width_inches)

MakiePlots.plotbrokenaxis1D(
    qs,
    intervals,
    legend_labels = legend_labels,
    title_font_size = 30,
    title = title,
    width_padding_proportion = width_padding_proportion,
    reverse_x_axis = true,
    grid_visible = false,

    line_style_list = line_style_list,
    line_width_list = line_width_list,

    x_label = "ppm",
    x_tick_decimal_places = 3,
    x_label_font_size = 25,

    y_label = "",
    y_tick_decimal_places = 3,
    y_label_font_size = 25,

    use_Wilkinson_for_ticks = false, # default is LinearTicks from Makie.
    min_total_x_ticks = 2,
    max_total_x_ticks = 10,

    legend_font_size = 25,
    legend_orientation = :horizontal, # :vertical or :horizontal
    legend_line_width = 2,

    save_folder_path = "./output",
    save_name = "figure.svg",
    size_inches = size_inches,
    pt_per_inch = 72,
    font_size = 12, # default font size for text that isn't covered.
    )

#electrondisplay(f) # display in electron display.
