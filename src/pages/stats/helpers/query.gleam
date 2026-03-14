import gleam/list
import gleam/result
import gleam/option .{type Option, None, Some}

import assets/stats as asset
import assets/bg
import assets/font
import assets/lang

import app/error .{type ServiceError, AssetDoesNotExist, LanguageIsNotSupported}

import pages/stats/struct .{type Query}

fn queery() -> Query {
  struct.Query(
    locale     : lang.En,
    layout     : asset.Qiwq,
    background : bg.Spacy,
    icon       : asset.Kitten,
    decor      : None,
    frame      : None,

    title_font   : font.Lilian,
    content_font : font.CutiePatootie,

    style: struct.Style(
      title_color  : "#70564E",
      icon_color   : "#70564E",
      label_color  : "#8A746C",
      value_color  : "#806258",
      frame_color  : "#828282",
      decor_color  : "#EB00A1",
      decor_pose_x : "35%",
      decor_pose_y : "75%"
    )
  )
}

pub fn parse(params: List(#(String, String))) -> Result(Query, ServiceError) {
  let default = queery()
  let oki = fn(a: t) -> Result(Option(t), ServiceError) {
    Ok(Some(a))
  }
  use locale <- result.try(
    case list.key_find(params, "locale") {
      Error(Nil) -> Ok(default.locale)
      Ok("en") -> Ok(lang.En)
      Ok("tr") -> Ok(lang.Tr)
      Ok(ugh) -> Error(LanguageIsNotSupported(ugh))
    }
  )
  use layout <- result.try(
    case list.key_find(params, "layout") {
      Error(Nil) -> Ok(default.layout)
      Ok("qiwq") -> Ok(asset.Qiwq)
      Ok("piwp") -> Ok(asset.Piwp)
      Ok(ugh) -> Error(AssetDoesNotExist(ugh))
    }
  )
  use background <- result.try(
    case list.key_find(params, "bg") {
      Error(Nil)                -> Ok(default.background)
      Ok("light")               -> Ok(bg.Light)
      Ok("spacy")               -> Ok(bg.Spacy)
      Ok("pinky-promise-left")  -> Ok(bg.PinkyPromiseLeft)
      Ok("pinky-promise-right") -> Ok(bg.PinkyPromiseRight)
      Ok(ugh) -> Error(AssetDoesNotExist(ugh))
    }
  )
  use icon <- result.try(
    case list.key_find(params, "icon") {
      Error(Nil)   -> Ok(default.icon)
      Ok("kitten") -> Ok(asset.Kitten)
      Ok(ugh) -> Error(AssetDoesNotExist(ugh))
    }
  )
  use decor <- result.try(
    case list.key_find(params, "decor") {
      Error(Nil)   -> Ok(default.decor)
      Ok("ribbon") -> oki(asset.Ribbon)
      Ok("none")   -> Ok(None)
      Ok(ugh) -> Error(AssetDoesNotExist(ugh))
    }
  )
  use frame <- result.try(
    case list.key_find(params, "frame") {
      Error(Nil)    -> Ok(default.frame)
      Ok("catface") -> oki(asset.Catface)
      Ok("none")    -> Ok(None)
      Ok(ugh) -> Error(AssetDoesNotExist(ugh))
    }
  )
  let font = fn(key: String) {
    case list.key_find(params, key) {
      Error(Nil)                   -> Ok(default.content_font)
      Ok("cutie-patootie")         -> Ok(font.CutiePatootie)
      Ok("lilian")                 -> Ok(font.Lilian)
      Ok("please-write-me-a-song") -> Ok(font.PleaseWriteMeASong)
      Ok("slopness")               -> Ok(font.Slopness)
      Ok(ugh) -> Error(AssetDoesNotExist(ugh))
    }
  }
  use title_font   <- result.try(font("tfont"))
  use content_font <- result.try(font("cfont"))

  let title_color =
    list.key_find(params, "tcolor")
    |> result.unwrap(default.style.title_color)
  let icon_color =
    list.key_find(params, "icolor")
    |> result.unwrap(default.style.icon_color)
  let label_color =
    list.key_find(params, "lcolor")
    |> result.unwrap(default.style.label_color)
  let value_color =
    list.key_find(params, "vcolor")
    |> result.unwrap(default.style.value_color)
  let frame_color =
    list.key_find(params, "fcolor")
    |> result.unwrap(default.style.frame_color)
  let decor_color =
    list.key_find(params, "dcolor")
    |> result.unwrap(default.style.decor_color)
  let decor_pose_x =
    list.key_find(params, "dposex")
    |> result.unwrap(default.style.decor_pose_x)
  let decor_pose_y =
    list.key_find(params, "dposey")
    |> result.unwrap(default.style.decor_pose_y)

  let style = struct.Style(
    title_color:,  icon_color:,  label_color:,
    value_color:,  frame_color:, decor_color:,
    decor_pose_x:, decor_pose_y:
  )
  Ok(struct.Query(locale, layout, background, icon, decor, frame, title_font, content_font, style))
}
