# ppx_monad

Minimalistic monad syntax for OCaml. This extension features a syntax for monadic computations inspired by Haskell. While processing the source code, each occurence of `name <- monad; body` is converted into `monad >>= fun name -> body`. No additional validation or substitutions are performed. Pattern matching is not supported on bind site, but can be used on already bound variables.

**Example**:

```ocaml
module Option = struct
  type 'a t = 'a option

  let return x = Some x

  let (>>=) self f =
    match self with
    | Some x -> f x
    | None   -> None
end

let put_line str =
  try
    Some (output_string (str ^ "\n"))
  with e ->
    None

let get_line () =
  try
    Some (input_line stdin)
  with End_of_file ->
    None

open Option

let concat_lines () =
  begin%monad
    put_line "input two lines";
    a <- get_line ();
    b <- get_line ();
    return (a ^ b)
  end

let () =
  match concat_lines () with
  | Some line -> print_endline line
  | None      -> print_endline "error"
```

**Warning**: this extension conflicts with the syntax for mutable update of object instances. Since objects are not considered an idiomatic OCaml and are not used frequently (and even less with mutable fields), this extension can be safely used in regular projects.
