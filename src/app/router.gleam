import wisp .{type Request, type Response}

import app/web
import app/error .{report}

import pages/stats/index as stats

pub fn handle_request(
  req: Request,
  ctx: web.Context,
) -> Response {
  case wisp.path_segments(req) {
    ["stats", username] ->
      case stats.handle(req, ctx, username) {
        Ok(res) -> res
        Error(err) -> report(stats.explain_issue(err))
      }
    _ -> report("The page you are looking for couldn't found!")
  }
}
