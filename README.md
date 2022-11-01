# MakiePlots.jl
Plots that use the `CairoMakie.jl` backend.

Examples are in `/examples/`. View the Markdown (i.e. `.md`) files with your web browser.

Warning: This package has some heavy dependencies, and is very slow to load. If this is a big issue, compile a Julia system image for Makie.jl and CairoMakie.jl as per the instructions at minute 19 in the [Interactive data visualizations with Makie JuliaCon 2022](https://www.youtube.com/watch?v=GcrXVRpop0o) video. However, you'll need to recompile the system image if you want the latest version of `Makie.jl` and `CairoMakie.jl` to be used with this package.
