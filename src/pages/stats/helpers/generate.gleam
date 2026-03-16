import gleam/bit_array
import gleam/result .{try}
import gleam/option .{type Option, None, Some}
import gleam/list
import gleam/string

import gleam/httpc
import gleam/http
import gleam/http/request

import app/error .{type ServiceError}

import utils/format

import pages/stats/struct .{type Query, type Card, type User, type CardRow}
import pages/stats/helpers/load

fn try_option(
  option : Option(Result(a, e)),
  do     : fn(Option(a)) -> Result(b, e)
) -> Result(b, e) {
  case option {
    Some(Ok(value))    -> do(Some(value))
    Some(Error(error)) -> Error(error)
    None               -> do(None)
  }
}

pub fn card(from data: User, with query: Query) -> Result(Card, ServiceError) {
  use bg    <- try(load.bg(query.background))
  use decor <- try_option(load.decor(query.decor))
  use frame <- try_option(load.frame(query.frame))

  use tfont <- try(load.font(query.title_font, "Title"))
  use cfont <- try(load.font(query.content_font, "Content"))
  use style <- try(load.stylesheet(query.style))

  use rows  <- try(labelize(data, query))

  let title  = string.concat([data.username, "'s Github Stats"])
  let style  = string.concat([tfont, cfont, style])

  let assert Ok(body) = request.to(data.avatar_url)
  let req = body
  |> request.set_method(http.Get)
  |> request.prepend_header("Content-Type", "image/jpeg")
  |> request.set_body(<<>>)

  use response <- try(
    httpc.send_bits(req)
    |> result.replace_error(error.SomethingWentWrong)
  )
  let avatar = response.body
  |> bit_array.base64_encode(True)
  |> string.append("data:image/jpeg;base64,", _)

  Ok(struct.Card(bg, avatar, decor, frame, title, rows, style))
}

fn labelize(data: User, query: Query) -> Result(List(CardRow), ServiceError) {
  let form = fn(num: Int) -> String {
    string.concat([
      ": ", format.number(num)
    ])
  }
  let row = fn(i: String, l: String, v: String, t: String) -> CardRow {
    struct.CardRow(i, l, string.join([v, t], " "))
  }

  let stars = data.earned_stars
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)

  let issues = form(data.closed_issues)
  |> string.append("/")
  |> string.append(format.number(data.closed_issues + data.open_issues))

  use icon <- try(load.icon(query.icon))

  Ok([
    row(icon.star   , "Earned Stars"   , form(stars)               , "Shiny Stars"),
    row(icon.commit , "Commits (2026)" , form(data.commits)        , "Commits"),
    row(icon.pr     , "Pull Requests"  , form(data.pull_requests)  , "Requests"),
    row(icon.issue  , "Total Issues"   , issues                    , "Closed"),
    row(icon.repo   , "Contributed to" , form(data.contributes)    , "Repositories")
  ])
}
