# Multicore OCaml
See https://kcsrk.info/ocaml5-tutorial/ and https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml#domainslib. 

## Run

```
$ hyperfine "dune exec fib"
$ hyperfine "dune exec parallel_fib"
$ hyperfine "dune exec pool"
```