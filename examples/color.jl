# visualize colours.

# I am here. try Literal.jl for both examples. fix up documentation. increase version, register.

using ElectronDisplay
ElectronDisplay.CONFIG.single_window = true


import MakiePlots

#import Colors
Makie = MakiePlots.Makie

N = 3


plot_colours = MakiePlots.getplotcolors(N, Float64)
c = collect( Makie.RGBAf(plot_colours[n][1], plot_colours[n][2], plot_colours[n][3], 1) for n in eachindex(plot_colours) )


g = Makie.Figure(backgroundcolor = :white)

for n in eachindex(c)

    Makie.Box(g[n, 1:3], color = :transparent, strokecolor = c[n])
end

g # put the figure variable on the last line to show figure.
