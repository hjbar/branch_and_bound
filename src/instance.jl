# STRUCTS
struct Instance
    n      # nombre    d'objets
    v      # valeurs des objets
    w      # poids   des objets
    w_max  # poids maximal
end

mutable struct Paire
    fst
    snd
end


# FUNCTIONS
function parse_instance(file)
    open(file) do f
        tab = []

        for l in eachline(f)
            push!(tab, parse.(Int, split(l)))
        end

        n = tab[1][1]
        d = tab[1][2]
        sol = tab[1][3]

        v = tab[2]
        w = tab[3]

        w_max = tab[d + 3][1]

        Paire(sol, Instance(n, v, w, w_max))
    end
end
