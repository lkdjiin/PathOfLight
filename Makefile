.PHONY: test
test:
	julia test/runtests.jl

.PHONY: file
file:
	touch src/$(f).jl test/$(f)_test.jl
