import gleam/erlang/process

import mist
import wisp
import wisp/wisp_mist

import mala .{type BagTable}
import repeatedly

import app/web .{Context}
import app/router

const hour = 3_600_000

@external(erlang, "chlorophyll_ffi", "mala_clear")
pub fn mala_clear(table: BagTable(k, v)) -> Nil

pub fn main() {
  let bag = mala.new()
  repeatedly.call(hour, Nil, fn(_, _) {
    mala_clear(bag)
  })

  let ctx     = Context(bag)
  let secret  = wisp.random_string(64)
  let handler = router.handle_request(_, ctx)

  let assert Ok(_) =
    wisp_mist.handler(handler, secret)
    |> mist.new
    |> mist.bind("0.0.0.0")
    |> mist.port(8080)
    |> mist.start
  process.sleep_forever()
}
