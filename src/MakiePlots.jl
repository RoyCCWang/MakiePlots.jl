module MakiePlots

    import Colors

    using CairoMakie
    #CairoMakie.activate!()

    greet() = print("Hello World!!!")

    include("./nmr/broken_axis_1D.jl")
    include("./colors.jl")

    export plotbrokenaxis1D, getplotcolors

end # module MakiePlots
