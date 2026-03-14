import gleam/string
import gleam/list
import gleam/float
import gleam/int

const suffix = [
  #(1_000_000_000.0, "B"),
  #(1_000_000.0, "M"),
  #(1_000.0, "K"),
]

pub fn number(num: Int) -> String {
  let num = int.to_float(num)
  let format = suffix
  |> list.drop_while(fn(t) { num <. t.0 })
  |> list.first

  case format {
    Ok(n) -> num /. n.0
    |> float.to_precision(1)
    |> float.to_string
    |> string.append(n.1)
    Error(Nil) -> num
    |> float.floor
    |> float.to_string
  }
  |> string.replace(".0", "")
}
