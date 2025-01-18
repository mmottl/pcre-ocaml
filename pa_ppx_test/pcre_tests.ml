(**pp -syntax camlp5o -package pa_ppx.deriving_plugins.std *)

open OUnit2

let test_special_char_regexps ctxt =
  ();
  assert_equal "\n" ([%match {|\n$|} / s exc pcre strings] "\n");
  assert_equal "" ([%subst {|\n+$|} / {||} / s pcre] "\n\n")

let test_pcre_simple_match ctxt =
  ();
  assert_equal "abc"
    (Pcre.get_substring ([%match "abc" / exc raw pcre] "abc") 0);
  assert_equal (Some "abc") ([%match "abc" / pcre] "abc");
  assert_equal (Some "abc") ([%match "abc" / strings pcre] "abc");
  assert_equal true ([%match "abc" / pred pcre] "abc");
  assert_equal false ([%match "abc" / pred pcre] "abd");
  assert_equal None ([%match "abc" / pcre] "abd");
  assert_raises Not_found (fun () -> [%match "abc" / exc pcre] "abd");
  assert_raises Not_found (fun () -> [%match "abc" / exc strings pcre] "abd");
  assert_equal None ([%match "abc" / strings pcre] "abd");
  assert_equal "abc" ([%match "abc" / exc strings pcre] "abc");
  assert_equal ("abc", Some "b") ([%match "a(b)c" / exc strings pcre] "abc");
  assert_equal ("ac", None) ([%match "a(?:(b)?)c" / exc strings pcre] "ac");
  assert_equal "abc"
    (Pcre.get_substring ([%match "ABC" / exc raw i pcre] "abc") 0);
  assert_equal
    ("abc", Some "a", Some "b", Some "c")
    ([%match "(a)(b)(c)" / exc strings pcre] "abc")

let test_pcre_selective_match ctxt =
  ();
  assert_equal ("abc", Some "b")
    ([%match "a(b)c" / exc strings (!0, 1) pcre] "abc");
  assert_equal ("abc", "b") ([%match "a(b)c" / exc strings (!0, !1) pcre] "abc");
  assert_equal "b" ([%match "a(b)c" / exc strings !1 pcre] "abc");
  assert_equal
    (Some ("abc", "b"))
    ([%match "a(b)c" / strings (!0, !1) pcre] "abc");
  assert_equal ("ac", None) ([%match "a(b)?c" / exc strings (!0, 1) pcre] "ac");
  assert_raises Not_found (fun _ ->
      [%match "a(b)?c" / exc strings (!0, !1) pcre] "ac");
  assert_equal None ([%match "a(b)?c" / strings (!0, !1) pcre] "ac")

let test_pcre_search ctxt =
  ();
  assert_equal "abc" ([%match "abc" / exc strings pcre] "zzzabc");
  assert_equal None ([%match "^abc" / strings pcre] "zzzabc")

let test_pcre_single ctxt =
  ();
  assert_equal None ([%match ".+" / pcre] "\n\n");
  assert_equal "\n\n" ([%match ".+" / s exc pcre strings] "\n\n");
  assert_equal None ([%match ".+" / m pcre strings] "\n\n");

  assert_equal None ([%match ".+" / pcre strings] "\n\n");
  assert_equal (Some "\n\n") ([%match ".+" / s pcre strings] "\n\n");
  assert_equal None ([%match ".+" / m pcre strings] "\n\n");

  assert_equal "<<abc>>\ndef" ([%subst ".+" / {|<<$0>>|} / pcre] "abc\ndef");
  assert_equal "<<abc\ndef>>" ([%subst ".+" / {|<<$0>>|} / s pcre] "abc\ndef");
  assert_equal "<<abc>>\ndef" ([%subst ".+" / {|<<$0>>|} / m pcre] "abc\ndef");

  assert_equal "<<abc>>\ndef" ([%subst ".*" / {|<<$0>>|} / pcre] "abc\ndef");
  assert_equal "<<abc>><<>>\n<<def>><<>>"
    ([%subst ".*" / {|<<$0>>|} / g pcre] "abc\ndef");
  assert_equal "<<abc>>\n<<def>>"
    ([%subst ".+" / {|<<$0>>|} / g pcre] "abc\ndef");
  assert_equal "<<abc>>a\nc<<aec>>"
    ([%subst "a.c" / {|<<$0>>|} / g pcre] "abca\ncaec");
  assert_equal "<<abc>><<a\nc>><<aec>>"
    ([%subst "a.c" / {|<<$0>>|} / g s pcre] "abca\ncaec")

let test_pcre_multiline ctxt =
  ();
  assert_equal (Some "bar") ([%match ".+$" / strings pcre] "foo\nbar");
  assert_equal (Some "foo") ([%match ".+$" / m strings pcre] "foo\nbar")

let test_pcre_simple_split ctxt =
  ();
  assert_equal [ "bb" ] ([%split "a" / pcre] "bb")

let test_pcre_delim_split_raw ctxt =
  let open Pcre in
  ();
  assert_equal
    [ Delim "a"; Text "b"; Delim "a"; Text "b" ]
    ([%split "a" / pcre raw] "ababa");
  assert_equal
    [ Delim "a"; Text "b"; Delim "a"; Delim "a"; Text "b" ]
    ([%split "a" / pcre raw] "abaaba");
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
    ([%split "a(c)?" / pcre raw] "abacba");
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
    ([%split "a(c)" / pcre raw] "acbacbac");
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
    ([%split "a(c)" / pcre raw] "acbacbac");
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
    ([%split "a(c)?" / pcre raw] "abacba");
  assert_equal
    [ Text "ab"; Delim "x"; Group (1, "x"); NoGroup; Text "cd" ]
    ([%split {|(x)|(u)|} / raw pcre] "abxcd");
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
    ([%split {|(x)|(u)|} / raw pcre] "abxcdu")

let test_pcre_subst ctxt =
  ();
  assert_equal "$b" ([%subst "a(b)c" / {|$$$1|} / pcre] "abc");
  assert_equal "$b" ([%subst "A(B)C" / {|$$$1|} / i pcre] "abc");
  assert_equal "$babc" ([%subst "A(B)C" / {|$$$1|} / i pcre] "abcabc");
  assert_equal "$b$b" ([%subst "A(B)C" / {|$$$1|} / g i pcre] "abcabc");
  assert_equal "$b$b" ([%subst "A(B)C" / {|"$" ^ $1$|} / e g i pcre] "abcabc");
  assert_equal "$$" ([%subst "A(B)C" / {|"$"|} / e g i pcre] "abcabc");
  assert_equal "$$" ([%subst "A(B)C" / {|$$|} / g i pcre] "abcabc")

let show_string_option = function
  | None -> "None"
  | Some s -> Printf.sprintf "Some %s" s

let test_pcre_ocamlfind_bits ctxt =
  ();
  assert_equal ~printer:show_string_option (Some "-syntax camlp5o ")
    (snd
       ([%match {|^\(\*\*pp (.*?)\*\)|} / exc strings pcre]
          {|(**pp -syntax camlp5o *)
|}))

let pcre_envsubst envlookup s =
  let f s1 s2 =
    if s1 <> "" then envlookup s1
    else if s2 <> "" then envlookup s2
    else assert false
  in

  [%subst {|(?:\$\(([^)]+)\)|\$\{([^}]+)\})|} / {| f $1$ $2$ |} / g e pcre] s

let test_pcre_envsubst_via_replace ctxt =
  let f = function
    | "A" -> "res1"
    | "B" -> "res2"
    | _ -> failwith "unexpected arg in envsubst"
  in
  assert_equal "...res1...res2..." (pcre_envsubst f {|...$(A)...${B}...|})

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

let _ = if not !Sys.interactive then run_test_tt_main suite else ()
