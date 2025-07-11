(**pp -syntax camlp5o -package pa_ppx.deriving_plugins.std *)

open OUnit2

let test_special_char_regexps ctxt =
  ();
  assert_equal "\n"
    ((let __re__ = Pcre.regexp ~flags:[ `DOTALL ] "\\n$" in
      fun __subj__ ->
        (fun __g__ -> Pcre.get_substring __g__ 0)
          (Pcre.exec ~rex:__re__ __subj__))
       "\n");
  assert_equal ""
    (Pcre.substitute_substrings_first
       ~rex:(Pcre.regexp ~flags:[ `DOTALL ] "\\n+$")
       ~subst:(fun __g__ -> String.concat "" [])
       "\n\n")

let test_pcre_simple_match ctxt =
  ();
  assert_equal "abc"
    (Pcre.get_substring
       ((let __re__ = Pcre.regexp ~flags:[] "abc" in
         fun __subj__ -> Pcre.exec ~rex:__re__ __subj__)
          "abc")
       0);
  assert_equal (Some "abc")
    ((let __re__ = Pcre.regexp ~flags:[] "abc" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "abc");
  assert_equal (Some "abc")
    ((let __re__ = Pcre.regexp ~flags:[] "abc" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "abc");
  assert_equal true
    ((let __re__ = Pcre.regexp ~flags:[] "abc" in
      fun __subj__ -> Pcre.pmatch ~rex:__re__ __subj__)
       "abc");
  assert_equal false
    ((let __re__ = Pcre.regexp ~flags:[] "abc" in
      fun __subj__ -> Pcre.pmatch ~rex:__re__ __subj__)
       "abd");
  assert_equal None
    ((let __re__ = Pcre.regexp ~flags:[] "abc" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "abd");
  assert_raises Not_found (fun () ->
      (let __re__ = Pcre.regexp ~flags:[] "abc" in
       fun __subj__ ->
         (fun __g__ -> Pcre.get_substring __g__ 0)
           (Pcre.exec ~rex:__re__ __subj__))
        "abd");
  assert_raises Not_found (fun () ->
      (let __re__ = Pcre.regexp ~flags:[] "abc" in
       fun __subj__ ->
         (fun __g__ -> Pcre.get_substring __g__ 0)
           (Pcre.exec ~rex:__re__ __subj__))
        "abd");
  assert_equal None
    ((let __re__ = Pcre.regexp ~flags:[] "abc" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "abd");
  assert_equal "abc"
    ((let __re__ = Pcre.regexp ~flags:[] "abc" in
      fun __subj__ ->
        (fun __g__ -> Pcre.get_substring __g__ 0)
          (Pcre.exec ~rex:__re__ __subj__))
       "abc");
  assert_equal ("abc", Some "b")
    ((let __re__ = Pcre.regexp ~flags:[] "a(b)c" in
      fun __subj__ ->
        (fun __g__ ->
          ( Pcre.get_substring __g__ 0,
            try Some (Pcre.get_substring __g__ 1) with Not_found -> None ))
          (Pcre.exec ~rex:__re__ __subj__))
       "abc");
  assert_equal ("ac", None)
    ((let __re__ = Pcre.regexp ~flags:[] "a(?:(b)?)c" in
      fun __subj__ ->
        (fun __g__ ->
          ( Pcre.get_substring __g__ 0,
            try Some (Pcre.get_substring __g__ 1) with Not_found -> None ))
          (Pcre.exec ~rex:__re__ __subj__))
       "ac");
  assert_equal "abc"
    (Pcre.get_substring
       ((let __re__ = Pcre.regexp ~flags:[ `CASELESS ] "ABC" in
         fun __subj__ -> Pcre.exec ~rex:__re__ __subj__)
          "abc")
       0);
  assert_equal "abc"
    (Pcre.get_substring
       ((let __re__ = Pcre.regexp "abc" in
         (* Explicitly adding a dummy callout to validate PR #36 *)
         fun __subj__ -> Pcre.exec ~callout:(fun _ -> ()) ~rex:__re__ __subj__)
          "abc")
       0);
  assert_equal
    ("abc", Some "a", Some "b", Some "c")
    ((let __re__ = Pcre.regexp ~flags:[] "(a)(b)(c)" in
      fun __subj__ ->
        (fun __g__ ->
          ( Pcre.get_substring __g__ 0,
            (try Some (Pcre.get_substring __g__ 1) with Not_found -> None),
            (try Some (Pcre.get_substring __g__ 2) with Not_found -> None),
            try Some (Pcre.get_substring __g__ 3) with Not_found -> None ))
          (Pcre.exec ~rex:__re__ __subj__))
       "abc")

let test_pcre_selective_match ctxt =
  ();
  assert_equal ("abc", Some "b")
    ((let __re__ = Pcre.regexp ~flags:[] "a(b)c" in
      fun __subj__ ->
        (fun __g__ ->
          ( Pcre.get_substring __g__ 0,
            try Some (Pcre.get_substring __g__ 1) with Not_found -> None ))
          (Pcre.exec ~rex:__re__ __subj__))
       "abc");
  assert_equal ("abc", "b")
    ((let __re__ = Pcre.regexp ~flags:[] "a(b)c" in
      fun __subj__ ->
        (fun __g__ -> (Pcre.get_substring __g__ 0, Pcre.get_substring __g__ 1))
          (Pcre.exec ~rex:__re__ __subj__))
       "abc");
  assert_equal "b"
    ((let __re__ = Pcre.regexp ~flags:[] "a(b)c" in
      fun __subj__ ->
        (fun __g__ -> Pcre.get_substring __g__ 1)
          (Pcre.exec ~rex:__re__ __subj__))
       "abc");
  assert_equal
    (Some ("abc", "b"))
    ((let __re__ = Pcre.regexp ~flags:[] "a(b)c" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ ->
              (Pcre.get_substring __g__ 0, Pcre.get_substring __g__ 1))
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "abc");
  assert_equal ("ac", None)
    ((let __re__ = Pcre.regexp ~flags:[] "a(b)?c" in
      fun __subj__ ->
        (fun __g__ ->
          ( Pcre.get_substring __g__ 0,
            try Some (Pcre.get_substring __g__ 1) with Not_found -> None ))
          (Pcre.exec ~rex:__re__ __subj__))
       "ac");
  assert_raises Not_found (fun _ ->
      (let __re__ = Pcre.regexp ~flags:[] "a(b)?c" in
       fun __subj__ ->
         (fun __g__ -> (Pcre.get_substring __g__ 0, Pcre.get_substring __g__ 1))
           (Pcre.exec ~rex:__re__ __subj__))
        "ac");
  assert_equal None
    ((let __re__ = Pcre.regexp ~flags:[] "a(b)?c" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ ->
              (Pcre.get_substring __g__ 0, Pcre.get_substring __g__ 1))
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "ac")

let test_pcre_search ctxt =
  ();
  assert_equal "abc"
    ((let __re__ = Pcre.regexp ~flags:[] "abc" in
      fun __subj__ ->
        (fun __g__ -> Pcre.get_substring __g__ 0)
          (Pcre.exec ~rex:__re__ __subj__))
       "zzzabc");
  assert_equal None
    ((let __re__ = Pcre.regexp ~flags:[] "^abc" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "zzzabc")

let test_pcre_single ctxt =
  ();
  assert_equal None
    ((let __re__ = Pcre.regexp ~flags:[] ".+" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "\n\n");
  assert_equal "\n\n"
    ((let __re__ = Pcre.regexp ~flags:[ `DOTALL ] ".+" in
      fun __subj__ ->
        (fun __g__ -> Pcre.get_substring __g__ 0)
          (Pcre.exec ~rex:__re__ __subj__))
       "\n\n");
  assert_equal None
    ((let __re__ = Pcre.regexp ~flags:[ `MULTILINE ] ".+" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "\n\n");
  assert_equal None
    ((let __re__ = Pcre.regexp ~flags:[] ".+" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "\n\n");
  assert_equal (Some "\n\n")
    ((let __re__ = Pcre.regexp ~flags:[ `DOTALL ] ".+" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "\n\n");
  assert_equal None
    ((let __re__ = Pcre.regexp ~flags:[ `MULTILINE ] ".+" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "\n\n");
  assert_equal "<<abc>>\ndef"
    (Pcre.substitute_substrings_first
       ~rex:(Pcre.regexp ~flags:[] ".+")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "<<";
             (match Pcre.get_substring __g__ 0 with
             | exception Not_found -> ""
             | s -> s);
             ">>";
           ])
       "abc\ndef");
  assert_equal "<<abc\ndef>>"
    (Pcre.substitute_substrings_first
       ~rex:(Pcre.regexp ~flags:[ `DOTALL ] ".+")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "<<";
             (match Pcre.get_substring __g__ 0 with
             | exception Not_found -> ""
             | s -> s);
             ">>";
           ])
       "abc\ndef");
  assert_equal "<<abc>>\ndef"
    (Pcre.substitute_substrings_first
       ~rex:(Pcre.regexp ~flags:[ `MULTILINE ] ".+")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "<<";
             (match Pcre.get_substring __g__ 0 with
             | exception Not_found -> ""
             | s -> s);
             ">>";
           ])
       "abc\ndef");
  assert_equal "<<abc>>\ndef"
    (Pcre.substitute_substrings_first
       ~rex:(Pcre.regexp ~flags:[] ".*")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "<<";
             (match Pcre.get_substring __g__ 0 with
             | exception Not_found -> ""
             | s -> s);
             ">>";
           ])
       "abc\ndef");
  assert_equal "<<abc>><<>>\n<<def>><<>>"
    (Pcre.substitute_substrings
       ~rex:(Pcre.regexp ~flags:[] ".*")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "<<";
             (match Pcre.get_substring __g__ 0 with
             | exception Not_found -> ""
             | s -> s);
             ">>";
           ])
       "abc\ndef");
  assert_equal "<<abc>>\n<<def>>"
    (Pcre.substitute_substrings
       ~rex:(Pcre.regexp ~flags:[] ".+")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "<<";
             (match Pcre.get_substring __g__ 0 with
             | exception Not_found -> ""
             | s -> s);
             ">>";
           ])
       "abc\ndef");
  assert_equal "<<abc>>a\nc<<aec>>"
    (Pcre.substitute_substrings
       ~rex:(Pcre.regexp ~flags:[] "a.c")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "<<";
             (match Pcre.get_substring __g__ 0 with
             | exception Not_found -> ""
             | s -> s);
             ">>";
           ])
       "abca\ncaec");
  assert_equal "<<abc>><<a\nc>><<aec>>"
    (Pcre.substitute_substrings
       ~rex:(Pcre.regexp ~flags:[ `DOTALL ] "a.c")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "<<";
             (match Pcre.get_substring __g__ 0 with
             | exception Not_found -> ""
             | s -> s);
             ">>";
           ])
       "abca\ncaec")

let test_pcre_multiline ctxt =
  ();
  assert_equal (Some "bar")
    ((let __re__ = Pcre.regexp ~flags:[] ".+$" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "foo\nbar");
  assert_equal (Some "foo")
    ((let __re__ = Pcre.regexp ~flags:[ `MULTILINE ] ".+$" in
      fun __subj__ ->
        match
          Option.map
            (fun __g__ -> Pcre.get_substring __g__ 0)
            (try Some (Pcre.exec ~rex:__re__ __subj__) with Not_found -> None)
        with
        | exception Not_found -> None
        | rv -> rv)
       "foo\nbar")

let test_pcre_simple_split ctxt =
  ();
  assert_equal [ "bb" ]
    ((let __re__ = Pcre.regexp ~flags:[] "a" in
      fun __subj__ -> Pcre.split ~rex:__re__ __subj__)
       "bb")

let test_pcre_delim_split_raw ctxt =
  let open Pcre in
  ();
  assert_equal
    [ Delim "a"; Text "b"; Delim "a"; Text "b" ]
    ((let __re__ = Pcre.regexp ~flags:[] "a" in
      fun __subj__ -> Pcre.full_split ~rex:__re__ __subj__)
       "ababa");
  assert_equal
    [ Delim "a"; Text "b"; Delim "a"; Delim "a"; Text "b" ]
    ((let __re__ = Pcre.regexp ~flags:[] "a" in
      fun __subj__ -> Pcre.full_split ~rex:__re__ __subj__)
       "abaaba");
  assert_equal
    [
      Delim "a";
      NoGroup;
      Text "b";
      Delim "ac";
      Group (1, "c");
      Text "b";
      Delim "a";
      NoGroup;
    ]
    ((let __re__ = Pcre.regexp ~flags:[] "a(c)?" in
      fun __subj__ -> Pcre.full_split ~rex:__re__ __subj__)
       "abacba");
  assert_equal
    [
      Delim "ac";
      Group (1, "c");
      Text "b";
      Delim "ac";
      Group (1, "c");
      Text "b";
      Delim "ac";
      Group (1, "c");
    ]
    ((let __re__ = Pcre.regexp ~flags:[] "a(c)" in
      fun __subj__ -> Pcre.full_split ~rex:__re__ __subj__)
       "acbacbac");
  assert_equal
    [
      Delim "ac";
      Group (1, "c");
      Text "b";
      Delim "ac";
      Group (1, "c");
      Text "b";
      Delim "ac";
      Group (1, "c");
    ]
    ((let __re__ = Pcre.regexp ~flags:[] "a(c)" in
      fun __subj__ -> Pcre.full_split ~rex:__re__ __subj__)
       "acbacbac");
  assert_equal
    [
      Delim "a";
      NoGroup;
      Text "b";
      Delim "ac";
      Group (1, "c");
      Text "b";
      Delim "a";
      NoGroup;
    ]
    ((let __re__ = Pcre.regexp ~flags:[] "a(c)?" in
      fun __subj__ -> Pcre.full_split ~rex:__re__ __subj__)
       "abacba");
  assert_equal
    [ Text "ab"; Delim "x"; Group (1, "x"); NoGroup; Text "cd" ]
    ((let __re__ = Pcre.regexp ~flags:[] "(x)|(u)" in
      fun __subj__ -> Pcre.full_split ~rex:__re__ __subj__)
       "abxcd");
  assert_equal
    [
      Text "ab";
      Delim "x";
      Group (1, "x");
      NoGroup;
      Text "cd";
      Delim "u";
      NoGroup;
      Group (2, "u");
    ]
    ((let __re__ = Pcre.regexp ~flags:[] "(x)|(u)" in
      fun __subj__ -> Pcre.full_split ~rex:__re__ __subj__)
       "abxcdu")

let test_pcre_subst ctxt =
  ();
  assert_equal "$b"
    (Pcre.substitute_substrings_first
       ~rex:(Pcre.regexp ~flags:[] "a(b)c")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "$";
             "";
             (match Pcre.get_substring __g__ 1 with
             | exception Not_found -> ""
             | s -> s);
           ])
       "abc");
  assert_equal "$b"
    (Pcre.substitute_substrings_first
       ~rex:(Pcre.regexp ~flags:[ `CASELESS ] "A(B)C")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "$";
             "";
             (match Pcre.get_substring __g__ 1 with
             | exception Not_found -> ""
             | s -> s);
           ])
       "abc");
  assert_equal "$babc"
    (Pcre.substitute_substrings_first
       ~rex:(Pcre.regexp ~flags:[ `CASELESS ] "A(B)C")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "$";
             "";
             (match Pcre.get_substring __g__ 1 with
             | exception Not_found -> ""
             | s -> s);
           ])
       "abcabc");
  assert_equal "$b$b"
    (Pcre.substitute_substrings
       ~rex:(Pcre.regexp ~flags:[ `CASELESS ] "A(B)C")
       ~subst:(fun __g__ ->
         String.concat ""
           [
             "$";
             "";
             (match Pcre.get_substring __g__ 1 with
             | exception Not_found -> ""
             | s -> s);
           ])
       "abcabc");
  assert_equal "$b$b"
    (Pcre.substitute_substrings
       ~rex:(Pcre.regexp ~flags:[ `CASELESS ] "A(B)C")
       ~subst:(fun __g__ ->
         "$"
         ^
         match Pcre.get_substring __g__ 1 with
         | exception Not_found -> ""
         | s -> s)
       "abcabc");
  assert_equal "$$"
    (Pcre.substitute_substrings
       ~rex:(Pcre.regexp ~flags:[ `CASELESS ] "A(B)C")
       ~subst:(fun __g__ -> "$")
       "abcabc");
  assert_equal "$$"
    (Pcre.substitute_substrings
       ~rex:(Pcre.regexp ~flags:[ `CASELESS ] "A(B)C")
       ~subst:(fun __g__ -> String.concat "" [ "$" ])
       "abcabc")

let show_string_option = function
  | None -> "None"
  | Some s -> Printf.sprintf "Some %s" s

let test_pcre_ocamlfind_bits ctxt =
  ();
  assert_equal ~printer:show_string_option (Some "-syntax camlp5o ")
    (snd
       ((let __re__ = Pcre.regexp ~flags:[] "^\\(\\*\\*pp (.*?)\\*\\)" in
         fun __subj__ ->
           (fun __g__ ->
             ( Pcre.get_substring __g__ 0,
               try Some (Pcre.get_substring __g__ 1) with Not_found -> None ))
             (Pcre.exec ~rex:__re__ __subj__))
          "(**pp -syntax camlp5o *)\n"))

let pcre_envsubst envlookup s =
  let f s1 s2 =
    if s1 <> "" then envlookup s1
    else if s2 <> "" then envlookup s2
    else assert false
  in
  Pcre.substitute_substrings
    ~rex:(Pcre.regexp ~flags:[] "(?:\\$\\(([^)]+)\\)|\\$\\{([^}]+)\\})")
    ~subst:(fun __g__ ->
      f
        (match Pcre.get_substring __g__ 1 with
        | exception Not_found -> ""
        | s -> s)
        (match Pcre.get_substring __g__ 2 with
        | exception Not_found -> ""
        | s -> s))
    s

let test_pcre_envsubst_via_replace ctxt =
  let f = function
    | "A" -> "res1"
    | "B" -> "res2"
    | _ -> failwith "unexpected arg in envsubst"
  in
  assert_equal "...res1...res2..." (pcre_envsubst f "...$(A)...${B}...")

let suite =
  "Test pa_ppx_regexp"
  >::: [
         "pcre only_regexps" >:: test_special_char_regexps;
         "pcre simple_match" >:: test_pcre_simple_match;
         "pcre selective_match" >:: test_pcre_selective_match;
         "pcre search" >:: test_pcre_search;
         "pcre single" >:: test_pcre_single;
         "pcre multiline" >:: test_pcre_multiline;
         "pcre simple_split" >:: test_pcre_simple_split;
         "pcre delim_split raw" >:: test_pcre_delim_split_raw;
         "pcre subst" >:: test_pcre_subst;
         "pcre ocamlfind bits" >:: test_pcre_ocamlfind_bits;
         "pcre envsubst via replace" >:: test_pcre_envsubst_via_replace;
       ]

let _ = if not !Sys.interactive then run_test_tt_main suite
