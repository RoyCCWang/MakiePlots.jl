module MakiePlots

    using CairoMakie
    #CairoMakie.activate!()

    greet() = print("Hello World!!!")

    include("./nmr/broken_axis_1D.jl")

    export plotbrokenaxis1D

end # module MakiePlots
