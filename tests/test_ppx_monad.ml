
module Option = struct
  type 'a t = 'a option

  let return x = Some x

  let (>>=) self f =
    match self with
    | Some x -> f x
    | None   -> None
end

let get_line () =
  try
    Some (input_line stdin)
  with End_of_file ->
    None

let concat_lines () =
  let open Option in
  a <- get_line ();
  b <- get_line ();
  return (a ^ b)


let () =
  match concat_lines () with
  | Some line -> print_endline line
  | None      -> print_endline "error"

