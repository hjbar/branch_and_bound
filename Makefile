default: exec

exec:
	julia src/main.jl

generate_sol:
	julia test/cbc.jl

download:
	julia download/download.jl
