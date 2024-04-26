default: exec

exec:
	julia src/main.jl

generate_inst:
	ocaml test/generate_instance.ml

generate_sol:
	julia test/cbc.jl

download:
	julia download/download.jl
