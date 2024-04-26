# IMPORTS
include("instance.jl")


# FUNCTIONS
function print_solution(paire::Paire, detailed)
    sol = paire.fst
    valeur = paire.snd

    if detailed
        print("solution :")

        for el in sol
            print(" ", el)
        end
    end

    println("\nvaleur : ", valeur)
end

function snd_compare(x::Paire, y::Paire)
    # compare deux paires selon la seconde composante
    x.snd > y.snd
end

function sort_instance(inst::Instance)
    # renvoie le tableau d'entiers, trié dans l'ordre décroissant des indices associés aux objets ayant le meilleur ratio valeur/cout
    coeff_utilite = [Paire(i, inst.v[i]/inst.w[i]) for i in 1:inst.n]
    sort!(coeff_utilite, lt=snd_compare)
    coeff_utilite = [p.fst for p in coeff_utilite] # on enleve les coefficients valeur/cout

    coeff_utilite
end
