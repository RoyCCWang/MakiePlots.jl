using Documenter
using MakiePlots

makedocs(
    sitename = "MakiePlots",
    format = Documenter.HTML(),
    modules = [MakiePlots]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
