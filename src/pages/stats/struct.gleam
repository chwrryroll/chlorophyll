import gleam/option .{type Option}

import assets/stats as asset
import assets/bg    .{type Background}
import assets/font  .{type Font}
import assets/lang  .{type Locale}

pub type Query {
  Query(
    locale       : Locale,
    layout       : asset.Layout,
    background   : Background,
    icon         : asset.Icon,
    decor        : Option(asset.Decor),
    frame        : Option(asset.Frame),
    title_font   : Font,
    content_font : Font,
    style        : Style
  )
}

pub type Style {
  Style(
    title_color  : String,
    icon_color   : String,
    label_color  : String,
    value_color  : String,
    frame_color  : String,
    decor_color  : String,
    decor_pose_x : String,
    decor_pose_y : String
  )
}

pub type User {
  User(
    username      : String,
    avatar_url    : String,
    earned_stars  : List(Int),
    commits       : Int,
    pull_requests : Int,
    open_issues   : Int,
    closed_issues : Int,
    contributes   : Int
  )
}

pub type Icon {
  Icon(
    star   : String,
    commit : String,
    pr     : String,
    issue  : String,
    repo   : String
  )
}

pub type CardRow {
  CardRow(
    icon  : String,
    label : String,
    value : String
  )
}

pub type Card {
  Card(
    background : String,
    avatar     : String,
    decor      : Option(String),
    frame      : Option(String),
    title      : String,
    rows       : List(CardRow),
    stylesheet : String
  )
}
