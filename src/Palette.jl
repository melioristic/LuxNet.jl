using ColorSchemes

base_palette = Dict(
    1 => "#29066B", 
    2 => "#7D3AC1",
    3 => "#AF4BCE",
    4 => "#DB4CB2",
    5 => "#EB548C",
    6 => "#EA7369",
    7 => "#F0A58F",
    8 => "#FCEAE6",

    )

base_scheme = ColorScheme([parse(Colorant, base_scheme[9-i]) for i in 2:8])