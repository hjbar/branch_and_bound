default: exec

exec:
	julia src/main.jl

download:
	julia download/download.jl
