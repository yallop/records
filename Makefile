.PHONY: all install uninstall clean check cov
PACKAGE=records
MLI=record type polid
OBJ=$(addprefix _build/, $(addsuffix .cmi, $(MLI)) $(PACKAGE).cma $(PACKAGE).cmxa $(PACKAGE).a)

all: $(OBJ)

check:
	ocamlbuild -use-ocamlfind tests.native --

tests.cov:
	rm -f tests.native
	ocamlbuild -use-ocamlfind -package bisect_ppx tests.native
	mv tests.native $@

cov: tests.cov
	./tests.cov -runner sequential
	cd _build ; bisect-ppx-report -summary-only -text /dev/stdout ../bisect000*.out ; cd ..

_build/%:
	ocamlbuild -use-ocamlfind $*

install: uninstall
	ocamlfind install $(PACKAGE) $(OBJ) META

uninstall:
	ocamlfind remove $(PACKAGE)

clean:
	ocamlbuild -clean
	rm -rf bisect*.out tests.cov
