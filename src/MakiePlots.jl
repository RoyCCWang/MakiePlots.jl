module MakiePlots

    import Colors

    using CairoMakie
    #CairoMakie.activate!()

    #greet() = print("Hello World!!!")

    include("./spectroscopy/multi_interval_1D.jl")
    include("./colors.jl")

    export plotmultiinterval1D, getplotcolors

end # module MakiePlots
