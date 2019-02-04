
open Pcre

let () =
  let open Printf in
  let pat = if 1 = Array.length Sys.argv
            then (eprintf "%s: expected pattern argument\n" Sys.argv.(0); exit 2)
            else Sys.argv.(1) in
  let rex = regexp pat in
  let newWorkspace _ = Array.make 50 0 in
  let showArray arr = Array.to_list arr
                   |> List.map string_of_int
                   |> String.concat ";"
                   |> sprintf "[%s]" in
  let read_line _ = try
                      print_string "> "; Some (read_line ())
                    with End_of_file -> None in
  let rec restart _ = print_endline "\n *input & workspace reset*";
                      findmatch [`PARTIAL] (newWorkspace ()) 
  and findmatch flags workspace = 
    match read_line() with
      | None -> restart()
      | Some input ->
          try
            let ret = pcre_dfa_exec ~rex ~flags ~workspace input in
            printf "match completed: %s" @@ showArray ret;
            restart()
          with | Not_found -> printf "pattern match failed";
                              restart()
               | Error WorkspaceSize -> print_endline "need larger workspace vector";
                                        exit 2
               | Error InternalError s -> print_endline @@ "err: " ^ s;
                                          exit 2
               | Error Partial -> print_endline "partial match, provide more input:";
                                  findmatch [`RESTART; `PARTIAL] workspace in
  findmatch [`PARTIAL] (newWorkspace ())
