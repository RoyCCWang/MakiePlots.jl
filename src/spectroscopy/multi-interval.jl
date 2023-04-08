###

# internal minimal data structure for 1D closed interval, for easier development.
mutable struct IntervalType{T<:AbstractFloat}
    min::T
    max::T
end

function intervallength(x::IntervalType{T})::T where T
    return x.max-x.min
end



"""
```
plotmultiinterval1D(
    qs::Vector,
    intervals::Vector{Tuple{T,T}};

    legend_labels = collect( string(i) for i in 1:length(qs) ),

    title_font_size = 30,
    title::String = "Figure",
    width_padding_proportion = 0.0,

    reverse_x_axis = false,
    grid_visible = true,
    color_list::Vector = [],
    background_color = :white,

    line_style_list = collect( :solid for _ = 1:length(qs)),
    line_width_list = collect( 3.0 for _ = 1:length(qs)),

    x_label = "",
    x_tick_decimal_places::Int = 3,
    x_tick_label_size = 20,
    x_label_font_size = 25,

    y_label = "",
    y_tick_decimal_places::Int = 3,
    y_tick_label_size = 20,
    y_label_font_size = 25,

    use_Wilkinson_for_ticks = false, # default is LinearTicks from Makie.
    min_total_x_ticks = 2,
    max_total_x_ticks = 10,

    legend_font_size = 25,
    legend_orientation = :horizontal, # :vertical or :horizontal
    legend_frame_visible = false,
    legend_line_width = 2,
    legend_placement = :lower_right,
    max_legend_per_line = 6,
    
    save_folder_path::String = "",
    save_name::String = "figure.svg",
    size_inches::Tuple{Real,Real} = (4,3),
    pt_per_inch::Int = 72,
    font_size = 12,
    resize_before_saving::Bool = true,

    ) where {T <: AbstractFloat, TC <: AbstractFloat}
```

Creates intermediate folders to the path indicated in `save_folder_path`, and saves a plot figure in it.

Most of the options are self-explanatory. Notes for the others:

- `qs` is a Vector of functions, anonymous functions, or callable object.

- `line_style_list::Vector{Symbol}`
Options are: `:solid`, `:dot`, `:dashdot`. See the documentation on `MakiePlots.Makie.lines` or visit the `Makie.jl` API documentation website.

- `color_list::Vector`
Should be a returned `Vector` data type of 3 or 4-element type values. Each tuple element should be a floating-point number between `0` and `1`. Such a variable can be created using `MakiePlots.getplotcolors()` for opaque lines.

- `use_Wilkinson_for_ticks::Bool`
Controls the method to compute ticks and locations. Set this to `false` to use `Makie.LinearTicks` instead of `Makie.WilkinsonTicks`.

- `legend_orientation::Bool`
Options are `:vertical`, `horizontal`.

- `legend_placement::Symbol`
If you want to have a legend, the options are `:lower_right` for just right of the x label text, `:bottom` for a new dedicated row under the x label text.
If you don't want a legend, enter any other symbol here, for example, `:none`.

- `max_legend_per_line::Int`
In effect only if `lengend_placement` is set to `:bottom`.
    
- `width_padding_proportion`
A floating-point number between `0` and `1`. Set to non-zero only if clipping occurs. The white spaces around the border should increase when this increases.

- `intervals`
An example is:
```
julia> intervals
4-element Vector{Tuple{Float64, Float64}}:
 (-0.18, 0.18)
 (0.8579726783855377, 1.1549433310182984)
 (2.1202980270631864, 2.4139284713717926)
 (3.4219504772166216, 3.7758634384778023)
```

"""
function plotmultiinterval1D(
    #qs::Vector{Function},
    qs::Vector,
    intervals::Vector{Tuple{T,T}};

    legend_labels = collect( string(i) for i in 1:length(qs) ),

    title_font_size = 30,
    title::String = "Figure",
    width_padding_proportion = 0.0,

    reverse_x_axis = false,
    grid_visible = true,
    color_list::Vector = [],
    background_color = :white,

    line_style_list = collect( :solid for _ = 1:length(qs)),
    line_width_list = collect( 3.0 for _ = 1:length(qs)),

    x_label = "",
    x_tick_decimal_places::Int = 3,
    x_tick_label_size = 20,
    x_label_font_size = 25,

    y_label = "",
    y_tick_decimal_places::Int = 3,
    y_tick_label_size = 20,
    y_label_font_size = 25,

    use_Wilkinson_for_ticks = false, # default is LinearTicks from Makie.
    min_total_x_ticks = 2,
    max_total_x_ticks = 10,

    legend_font_size = 25,
    legend_orientation = :horizontal, # :vertical or :horizontal
    legend_frame_visible = false,
    legend_line_width = 2,
    max_legend_per_line = 6,

    save_folder_path::String = "",
    save_name::String = "figure.svg",
    size_inches::Tuple{Real,Real} = (4,3),
    pt_per_inch::Int = 72,
    font_size = 12,
    resize_before_saving::Bool = true,

    legend_placement = :lower_right,

    ) where T <: AbstractFloat

    #canvas_size = (2018, 1090),

    ### checks.
    # the following seems hardcorded into Makie.jl's WilkinsonTicks().
    @assert 2 <= min_total_x_ticks < max_total_x_ticks <= 10.


    # convert to Makie's terminology for easier development.
    total_x_label_string = x_label
    title_string = title
    N = length(intervals)

    ### setup.

    plot_colors = Vector{Makie.RGBAf}(undef, 0)
    if length(color_list) == length(qs)

        resize!(plot_colors, length(qs))

        alpha = 1.0 # default alpha to opaque.
        for n in eachindex(color_list)

            if length(color_list[n]) > 3
                alpha = color_list[n][4]
            end

            plot_colors[n] = Makie.RGBAf(color_list[n][1],
                color_list[n][2],
                color_list[n][3],
                alpha)
        end
    end

    x_tick_decimal_places_format = "{:.$(x_tick_decimal_places)f}"
    y_tick_decimal_places_format = "{:.$(y_tick_decimal_places)f}"
    canvas_size = collect( round(Int, pt_per_inch*size_inches[d]) for d = 1:2)

    tickfunc = LinearTicks # more ticks?
    if use_Wilkinson_for_ticks
        tickfunc = WilkinsonTicks
    end

    canvas_aspect_ratio = canvas_size[1]/canvas_size[2]
    row_ind = 2 # first row for title, second row for plots, third for x-axis label.

    Q = collect( IntervalType(intervals[i][1], intervals[i][2]) for i in eachindex(intervals) )

    ### get aspect ratio for each interval.

    # TODO perhaps one can automatically find `width_padding_proportion` via f.layout.default_colgap.x * N_regions to determine width_padding_proportion, but not sure if Makie.jl will change in the future.
    y_min, y_max, aspects = getplotproperties(Q, qs;
        canvas_aspect_ratio = canvas_aspect_ratio,
        width_padding_proportion = width_padding_proportion) # with alignmode outside(), just need a small number for edge tick marks.


    ### create figure, layout, axes.
    f = Figure(backgroundcolor = background_color, fontsize = font_size)

    if reverse_x_axis
        Q = reverse(Q)
        aspects = reverse(aspects)
    end

    axes = Vector{Axis}(undef, N)

    # spine on left-most (first column) plot.
    axes[1] = Axis(
        f[row_ind,1],
        ylabel = y_label,
        ytickformat = y_tick_decimal_places_format,
        xtickformat = x_tick_decimal_places_format,
        #xminorticksize = 100.0, #if you want to force a certain size.
    )
    hidespines!(axes[1], :t, :r) # remove spine for top and right.

    for n in eachindex(axes)[begin+1:end-1]
        axes[n] = Axis(
            f[row_ind,n],
            yticklabelsvisible = false,
            yticksvisible = false,
            xtickformat = x_tick_decimal_places_format,
            #xminorticksize = 10.0, #if you want to force a certain size.
        )
        hidespines!(axes[n], :t, :r, :l)
    end

    axes[end] = Axis(
        f[row_ind,N],
        ylabel = y_label,
        yaxisposition = :right,
        ytickformat = y_tick_decimal_places_format,
        xtickformat = x_tick_decimal_places_format,
        #xminorticksize = 100.0, #if you want to force a certain size.
    )
    hidespines!(axes[end], :t, :l)

    # if need reverse x axis.
    if reverse_x_axis
        for n in eachindex(axes)
            axes[n].xreversed = true
        end
    end

    ### plot the lines using the functions in `qs`.
    # add the function lines.
    line_handles = Vector{Vector{Lines}}(undef, length(Q))
    for n in eachindex(Q)
        #lines!(axes[n], Q[n].min..Q[n].max, cos, color = 1:12)

        line_handles[n] = Vector{Lines}(undef, length(qs))
        for m in eachindex(qs)
            if !isempty(plot_colors)
                line_handles[n][m] = lines!(
                    axes[n],
                    Q[n].min..Q[n].max,
                    qs[m],
                    color = plot_colors[m],
                    linestyle = line_style_list[m],
                    linewidth = line_width_list[m],
                )
            else
                line_handles[n][m] = lines!(
                    axes[n],
                    Q[n].min..Q[n].max,
                    qs[m],
                    linestyle = line_style_list[m],
                    linewidth = line_width_list[m],
                )
            end
        end

        #ylims!(axes[n], min_limits[n], max_limits[n]) # default.
        ylims!(axes[n], y_min, y_max)
    end

    ### enforce the input settings.

    ## aspect ratio.
    for n in eachindex(axes)
        colsize!(f.layout, n, Aspect(row_ind, aspects[n])) # make sure each interval is allocated its proportional horizontal viewing space.
        axes[n].alignmode = Outside() # all plot ticks go inside the bounding box for each Makie.jl grid cell.
    end

    ## ticks.
    proportionality_of_intervals = aspects ./ sum(aspects)
    for n in eachindex(axes)

        num_ticks = max_total_x_ticks *proportionality_of_intervals[n]
        #@show num_ticks

        num_ticks = round(Int, clamp(num_ticks, min_total_x_ticks, max_total_x_ticks))

        #axes[n].xticks = WilkinsonTicks(num_ticks)
        #axes[n].xticks = LinearTicks(num_ticks)
        axes[n].xticks = tickfunc(num_ticks)

        axes[n].xticklabelsize = x_tick_label_size
        # xlabel for each subplot is not used. Make an entire row for the x label later in this function.

        axes[n].yticklabelsize = y_tick_label_size
        axes[n].ylabelsize = y_label_font_size
    end

    ## visibility.

    # not working.
    # if grid_visible == false
    #     for n in eachindex(axes)
    #         hidexdecorations!(axes[n],
    #             grid = false,
    #             minorgrid = false,
    #             ticklabels = true,
    #             ticks = true,
    #         )
    #     end
    # end
    if grid_visible == false
        for n in eachindex(axes)
            axes[n].xgridvisible = false
            axes[n].ygridvisible = false
        end
    end

    ### labels.
    supertitle = Label(f[1, :], title_string, fontsize = title_font_size, justification = :center )
    supertitle = Label(f[3, :], total_x_label_string, fontsize = x_label_font_size, justification = :center )


    @assert length(line_handles[end]) == length(qs)
    if legend_placement == :lower_right
        Legend(
            f[3,end],
            line_handles[end],
            legend_labels,
            orientation = legend_orientation,
            tellwidth = false,
            tellheight = true,
            framevisible = legend_frame_visible,
            labelsize = legend_font_size,
            linewidth = legend_line_width,
        )
    elseif legend_placement == :bottom
        lh = line_handles[end]

        #@show lh # debug.
        if length(lh) > max_legend_per_line
            N_rows = ceil(Int, length(lh)/max_legend_per_line)

            fin_ind = 0
            for r = 1:N_rows
                
                st_ind = max_legend_per_line*(r-1) + 1
                fin_ind = min(max_legend_per_line+st_ind-1, length(lh))
                #@show 3+r, st_ind, fin_ind, lh[st_ind:fin_ind] # debug.

                Legend(
                f[3+r,:],
                lh[st_ind:fin_ind],
                legend_labels[st_ind:fin_ind],
                orientation = legend_orientation,
                tellwidth = false,
                tellheight = true,
                framevisible = legend_frame_visible,
                labelsize = legend_font_size,
                linewidth = legend_line_width,
            )
            end
        else
            Legend(
                f[4,:],
                line_handles[end],
                legend_labels,
                orientation = legend_orientation,
                tellwidth = false,
                tellheight = true,
                framevisible = legend_frame_visible,
                labelsize = legend_font_size,
                linewidth = legend_line_width,
            )
        end
    end

    ### save.

    if resize_before_saving
        resize_to_layout!(f)
    end

    # make dir if doesn't exist.
    save_path = save_name
    if !isempty(save_folder_path)
        t = @task begin; isdir(save_folder_path) || mkpath(save_folder_path); end
        schedule(t); wait(t)
        save_path = joinpath(save_folder_path, save_name)
    end
    save(save_path, f, pt_per_unit = 1)

    return f
end

function searchmax(q::Function, N_search_positions::Int, Q::Vector{IntervalType{T}})::Tuple{T,T} where T

    y_min = minimum( minimum(q.(LinRange(Q[n].min, Q[n].max, N_search_positions))) for n in eachindex(Q) )
    y_max = maximum( maximum(q.(LinRange(Q[n].min, Q[n].max, N_search_positions))) for n in eachindex(Q) )

    return y_min, y_max
end

# N_search_positions is used to estimate the extrema of q on each interval in Q.
function getplotproperties(
    Q::Vector{IntervalType{T}},
    qs::Vector{Function};
    N_search_positions = 3000,
    canvas_aspect_ratio = 16/9, # width/height
    width_padding_proportion = 0.2, # estimated proportion of canvas width that is used by Makie for non-plots, like spacing between plots. # in crease to reduce overall weidth content of plot.
    ) where T

    @assert canvas_aspect_ratio > 0
    @assert N_search_positions > 0
    @assert 0 <= width_padding_proportion <= 1

    ## prepare total distance covered by all intervals `interval_lengths` and total distance covered in the vertical direction `y_length`.
    tmp = collect( searchmax(qs[m], N_search_positions, Q) for m in eachindex(qs) )
    y_max = maximum( tmp[m][2] for m in eachindex(qs) )
    y_min = minimum( tmp[m][1] for m in eachindex(qs) )
    y_length = y_max - y_min

    interval_lengths = intervallength.(Q)


    ## modyfy `scale` such that `plot_aspect_ratio` is the same as `canvas_aspect_ratio`.
    # i.e., plot_aspect_ratio = scale*sum(interval_lengths) / y_length == canvas_aspect_ratio

    # p is used to reduce the horizontal coverage because there are spaces around the plot for each interval.
    # don't know that exact amount, so it isn't added to `interval_lengths`.
    # in the current implementation, assumes `width_padding_proportion` describes that amount in terms of total proportions.
    p = clamp(1-width_padding_proportion, 0, 1)
    scale = p*canvas_aspect_ratio*y_length/sum(interval_lengths)

    x_length = interval_lengths .* scale
    aspects = x_length ./ y_length

    return y_min, y_max, aspects
end
