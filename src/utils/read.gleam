import gleam/result .{try}
import gleam/list
import gleam/string
import gleam/bit_array

import wisp
import simplifile

fn prefix(file: String) -> String {
  let extension = file
  |> string.split(".")
  |> list.last
  |> result.unwrap("txt")

  case extension {
    "svg" -> "data:image/svg+xml;base64,"
    "ttf" -> "data:application/font-ttf;base64,"
    "png" -> "data:image/png;base64,"
    "jpg" | "jpeg" -> "data:image/jpeg;base64,"
    _ -> "data:text/plain;base64,"
  }
}

pub fn bits(path: String) -> Result(String, Nil) {
  use priv <- try(wisp.priv_directory("chlorophyll"))
  use src  <- try(simplifile.read_bits(priv <> path) |> result.replace_error(Nil))
  let base64 = bit_array.base64_encode(src, True)
  Ok(prefix(path) <> base64)
}

pub fn chars(path: String) -> Result(String, Nil) {
  use priv <- try(wisp.priv_directory("chlorophyll"))
  simplifile.read(priv <> path)
  |> result.replace_error(Nil)
}
