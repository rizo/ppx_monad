
open Ast_helper
open Ast_mapper
open Asttypes
open Parsetree

let noloc = Location.mknoloc

let rec expr this e =
  match e.pexp_desc with
  (*
   * Instance var set seq:
   *   `name <- monad; body` -> `monad >>= fun name -> body`
   *)
  | Pexp_sequence ({pexp_desc = Pexp_setinstvar ({txt = name}, monad)}, body) ->
    let bind  = Exp.ident (noloc (Longident.Lident ">>=")) in
    let body' = expr this body in
    let mfun  = Exp.fun_ Nolabel None (Pat.var (noloc name)) body' in
    Exp.apply bind [(Nolabel, monad); (Nolabel, mfun)]

  | _ -> default_mapper.expr this e


let () =
  register "ppx_monad" (fun argv -> { default_mapper with expr })

