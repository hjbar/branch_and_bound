# FUNCTIONS
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
