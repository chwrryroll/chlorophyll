import gleam/option .{type Option, Some, None}
import gleam/result .{try}
import gleam/string

import assets/font
import assets/bg
import assets/stats as asset

import app/error .{type ServiceError, AssetCouldNotLoaded}

import utils/read

import pages/stats/struct .{type Icon}

pub fn icon(icon: asset.Icon) -> Result(Icon, ServiceError) {
  let dir = case icon {
    asset.Kitten -> "kitten/"
  }
  let get = fn(file: String) {
    read.chars("/static/packs/stats/icons/" <> dir <> file)
    |> result.replace_error(AssetCouldNotLoaded(file))
  }

  use star   <- try(get("star.svg"))
  use commit <- try(get("commit.svg"))
  use pr     <- try(get("pull-request.svg"))
  use issue  <- try(get("issue.svg"))
  use repo   <- try(get("repository.svg"))
  Ok(struct.Icon(star, commit, pr, issue, repo))
}

pub fn bg(this: bg.Background) -> Result(String, ServiceError) {
  let file = bg.file(of: this)
  read.bits("/static/backgrounds/" <> file)
  |> result.replace_error(AssetCouldNotLoaded(file))
}

pub fn frame(this: Option(asset.Frame)) -> Option(Result(String, ServiceError)) {
  let file = asset.frame_file(of: this)
  case file {
    Some(file) -> Some(read.chars("/static/packs/stats/frames/" <> file)
    |> result.replace_error(AssetCouldNotLoaded(file)))
    None -> None
  }
}

pub fn decor(this: Option(asset.Decor)) -> Option(Result(String, ServiceError)) {
  let file = asset.decor_file(of: this)
  case file {
    Some(file) -> Some(read.chars("/static/packs/stats/decors/" <> file)
    |> result.replace_error(AssetCouldNotLoaded(file)))
    None -> None
  }
}

pub fn font(this: font.Font, name: String) -> Result(String, ServiceError) {
  let file = font.file(of: this)
  use source <- result.try(
    read.bits("/static/fonts/" <> file)
    |> result.replace_error(AssetCouldNotLoaded(file))
  )
  Ok(
    "@font-face { font-family: '<name>'; src: url('<src>') }\n"
    |> string.replace("<name>", name)
    |> string.replace("<src>",  source)
  )
}

pub fn stylesheet(style: struct.Style) -> Result(String, ServiceError) {
  let add = fn(head: String, tail: String, value: String) -> String {
    string.append(
      head,
      string.concat(["--", tail, ":", value, ";\n"])
    )
  }
  let root = "\n:root {"
  |> add("title-color" , style.title_color)
  |> add("icon-color"  , style.icon_color)
  |> add("label-color" , style.label_color)
  |> add("value-color" , style.value_color)
  |> add("frame-color" , style.frame_color)
  |> add("decor-color" , style.decor_color)
  |> add("decor-poseX" , style.decor_pose_x)
  |> add("decor-poseY" , style.decor_pose_y)
  |> string.append("}\n")

  use source <- result.try(
    read.chars("/static/styles/stats.css")
    |> result.replace_error(AssetCouldNotLoaded("css"))
  )
  Ok(root <> source)
}
