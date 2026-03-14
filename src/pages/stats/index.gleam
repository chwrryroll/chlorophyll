import gleam/result .{try}

import gleam/http/request

import lustre/element .{type Element}
import wisp           .{type Request}
import mala

import pages/stats/struct .{type Card,type Query}
import pages/stats/helpers/generate
import pages/stats/helpers/query
import pages/stats/helpers/fetch

import assets/stats as asset
import assets/lang

import app/web
import app/error

pub fn handle(req: Request, ctx: web.Context, username: String) {
  let cache = mala.get(ctx.bag, "stats/" <> username)
  let search_params = request.get_query(req)
  |> result.unwrap([])

  use query <- try(query.parse(search_params))
  use card  <- try(case cache {
    Ok([data, ..]) -> {
      use card  <- try(generate.card(from: data, with: query))
      Ok(card)
    }
    Ok([]) | Error(Nil) -> {
      use data  <- try(fetch.user(by: username))
      use card  <- try(generate.card(from: data, with: query))

      mala.insert(ctx.bag, "stats/" <> username, data)
      |> result.unwrap(Nil)
      Ok(card)
    }
  })
  let view = get_layout(query)
  render(card, using: view)
}

pub fn render(card: Card, using view: fn(Card) -> Element(t)) {
  let svg = view(card)
  Ok(
    wisp.ok()
    |> wisp.html_body(element.to_string(svg))
    |> wisp.set_header("content-type", "image/svg+xml")
    |> wisp.set_header("Cache-Control", "public, max-age=31536000")
  )
}

pub fn explain_issue(issue: error.ServiceError) -> String {
  case issue {
    error.AssetDoesNotExist(asset) ->
      "The '" <> asset <> "' asset doesn't exists in the service! Could it be a typo?"
    error.LanguageIsNotSupported(code) ->
      "Sorry, the language that uses '" <> code <> "' currently is not supported :c"
    error.AssetCouldNotLoaded(asset) ->
      "An error accrued while loading '" <> asset <> "' file, please report this issue (Pretty please)"
    error.TranslationFailed(code) ->
      "Translation of " <> lang.name(code) <> " texts failed, please report this issue."
    error.HttpRequestFailed(_) ->
      "GitHub started to be not nice! User fetching failed, maybe try it again later."
    error.ParsingFailed(_) ->
      "Parsing went wrong! That was unexpected, but maybe you could try it again later."
    error.SomethingWentWrong ->
      "Something doesn't seems right... I'm not sure."
  }
}

import pages/stats/layouts/qiwq
import pages/stats/layouts/piwp

pub fn get_layout(query: Query) {
  case query.layout {
    asset.Qiwq -> qiwq.view
    asset.Piwp -> piwp.view
  }
}
