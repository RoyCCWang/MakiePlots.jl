"""
```
getplotcolors(
    N_colors::Int,
    ::Type{T};
    seeds::Vector{Tuple{T,T,T}} = [(one(T),one(T),one(T)); (zero(T), zero(T), zero(T))],
    drop_seeds = true,
    ) where T <: AbstractFloat
```
The default for the optional inputs passes white (1,1,1) and black (0,0,0) as seed colours, then drop them from the generated list. This makes sure white and black and never returned in the list of colours.
"""
function getplotcolors(
    N_colors::Int,
    ::Type{T};
    seeds::Vector{Tuple{T,T,T}} = [(one(T),one(T),one(T)); (zero(T), zero(T), zero(T))],
    drop_seeds = true,
    ) where T <: AbstractFloat

    x = Colors.distinguishable_colors(N_colors,
        collect( Colors.RGB(seeds[i][1],seeds[i][2],seeds[i][3]) for i in eachindex(seeds) ),
        dropseed = true)

    plot_colours = collect( ( convert(T, Colors.red(x[n])),
        convert(T, Colors.green(x[n])),
        convert(T, Colors.blue(x[n])) ) for n in eachindex(x))

    return plot_colours
end
