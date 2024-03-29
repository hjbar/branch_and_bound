# Stratégie de la méthode (très) gloutonne
# =================================
#
# - On trie les objets par "utilité" décroissante (valeur/cout)
# - On parcours ces objets de manière décroissante en les prennants s'ils ne font pas dépasser le poid max

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

function read_instance()
    open("entry1.txt") do f
    n = parse(Int, readline(f));
    v = parse.(Int, split(readline(f)))
    w = parse.(Int, split(readline(f)))
    w_max = parse(Int, readline(f))
    Instance(n, v, w, w_max)
    end
end

function print_solution(paire)
    sol = paire.fst
    valeur = paire.snd

    print("solution :")
    for el in sol
        print(" ", el)
    end
    println("\nvaleur : ", valeur)
end

function snd_compare(x, y)
    # compare deux paires selon la seconde composante
    x.snd > y.snd
end

function main(inst::Instance)
    # ENTREE : Instance
    # SORTIE : Paire(tableau, valeur) ; une solution assez bien calculée rapidement

    coeff_utilite = [Paire(i, inst.v[i]/inst.w[i]) for i in 1:inst.n]
    sort!(coeff_utilite, lt=snd_compare)
    coeff_utilite = [p.fst for p in coeff_utilite] # on enleve les coefficients valeur/cout


    solution = [0 for _ in 1:inst.n]
    poid = 0
    valeur = 0
    for i in coeff_utilite
        # ajout d'un objet
        if poid + inst.w[i] <= inst.w_max
            poid += inst.w[i]
            valeur += inst.v[i]
            solution[i] = 1
        end
    end
    return Paire(solution, valeur)
end

# MAIN
inst = read_instance()
sol  = main(inst)
print_solution(sol)
