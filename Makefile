TARGET=ppx_monad

default: build

help:
	@echo "make help  	- this help message"
	@echo "make build   - build the syntax extension"
	@echo "make test    - run the tests"
	@echo "make code    - show the processed code of the tests"
	@echo "make tree    - show the syntax tree of the tests"
	@echo "make clean   - remove the binaries and build artifacts"

build:
	ocamlbuild -package compiler-libs.bytecomp src/$(TARGET).native

test: build
	ocamlopt -ppx ./$(TARGET).native ./tests/test_$(TARGET).ml -o ./test_$(TARGET).native
	./test_$(TARGET).native

process: build
	ocamlopt -dsource -ppx ./$(TARGET).native ./tests/test_$(TARGET).ml -o ./test_$(TARGET).native

source: build
	ocamlopt -dsource ./tests/test_$(TARGET).ml

tree: build
	ocamlopt -dparsetree -ppx ./$(TARGET).native ./tests/test_$(TARGET).ml

clean:
	ocamlbuild -clean
	rm -rf *.native

