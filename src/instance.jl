# DELCARATIONS
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
function read_instance()
    open("test/entry1.txt") do f

    n = parse(Int, readline(f));
    v = parse.(Int, split(readline(f)))
    w = parse.(Int, split(readline(f)))
    w_max = parse(Int, readline(f))

    Instance(n, v, w, w_max)

    end
end
