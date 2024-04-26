let c = 1000
let _ = Random.self_init()

let generate nvar =
  Printf.sprintf "%i 1 %i" nvar 0
  (* objectif *)
  ^ (List.init nvar (fun _ -> Printf.sprintf "%i " (c + Random.int c)) |> List.fold_left (^) "\n")
  (* contrainte *)
  ^ (List.init nvar (fun _ -> Printf.sprintf "%i " (Random.int c)) |> List.fold_left (^) "\n")
  (* poid *)
  ^ (Printf.sprintf "\n%i" (c / 2 + Random.int c))

let _ = generate 50000 |> Printf.printf "%s"
