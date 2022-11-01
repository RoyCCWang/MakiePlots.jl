# Generate plot colors
`MakiePlots.jl` includes the `Colors.jl` as one of its dependencies. We can generate a list of colors using the `MakiePlots.getplotcolors()`, which is a wrapper to the [`Colors.distinguishable_colors()` function](https://juliagraphics.github.io/Colors.jl/stable/colormapsandcolorscales/).

Figures from `MakiePlots.jl` might not show up if you're using the Julia REPL from a shell session. In this case, enable [ElectronDisplay.jl](https://github.com/queryverse/ElectronDisplay.jl) by doing the following.

Do
```
using Pkg
Pkg.add("ElectronDisplay")
```
if you don't have `ElectronDisplay` installed.

````julia
using ElectronDisplay
ElectronDisplay.CONFIG.single_window = true # ignore this if you do not want to reuse the same window for each figure draw call.
````

## Generate colors
We will use `Makie.jl` commands in this example. Make an alias to the `Makie.jl` dependency in `MakiePlots`. This way we dont' need to install `Makie.jl` in our currently activated project environment.

````julia
import MakiePlots
Makie = MakiePlots.Makie
#Colors = MakiePlots.Colors
````

Let's generate `N` number of colors.

````julia
N = 3
````

The following returns a 1D array (type ::Vector{}) of (red,green,blue) values, each ranging from 0 to 1, and take on the floating-point data type: `Float64`. Type `?MakiePlots.getplotcolors` in the Julia REPL to see its function prototype and documentation.

````julia
plot_colours = MakiePlots.getplotcolors(N, Float64)
````

## Visualize the colors
To get `Makie.jl` to draw figures with a custom color, we need to express the colors in a tuple of `Makie.RGBf` or `Makie.RGBAf` data types. We use the latter, and pass in `1` for full opacity (i.e. no transparency) in the last slot of RGBA, which is the alpha channel.

````julia
c = collect( Makie.RGBAf(plot_colours[n][1], plot_colours[n][2], plot_colours[n][3], 1) for n in eachindex(plot_colours) )
````

Generate a figure and draw unfilled boxes. The outlines of the boxes are the colors we generated.

````julia
g = Makie.Figure(backgroundcolor = :white)

for n in eachindex(c)

    Makie.Box(g[n, 1:3], color = :transparent, strokecolor = c[n])
end
````

manually enter this into the Julia REPL or put the figure variable on the last line if you're running this as a script via `include()` to tell `ElectronDisplay.jl` to show the figure.

````julia
g
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

