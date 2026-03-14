import wisp .{type Request, type Response}
import mala .{type BagTable}

import pages/stats/struct .{type User}

pub type Context {
  Context(
    bag: BagTable(String, User)
  )
}

pub fn middleware(
  req: Request,
  next: fn(Request) -> Response,
) -> Response {
  let req = wisp.method_override(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  next(req)
}
