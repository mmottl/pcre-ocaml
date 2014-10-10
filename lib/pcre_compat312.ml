module Bytes = struct
  let create = String.create
  let unsafe_set = String.unsafe_set
  let unsafe_blit = String.unsafe_blit
  let unsafe_to_string x = x
  let unsafe_of_string = unsafe_to_string
end  (* Bytes *)

let string_copy = String.copy

let buffer_add_subbytes = Buffer.add_substring
