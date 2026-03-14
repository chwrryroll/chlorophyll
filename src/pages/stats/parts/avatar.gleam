import gleam/option .{Some,None}

import lustre/element      .{type Element}
import lustre/element/html .{div}
import lustre/attribute    .{class}

import components/picture

import pages/stats/struct .{type Card}

pub fn part(card: Card) -> Element(t) {
  div([class("card__avatar")], [
    picture.img(card.avatar, [class("avatar__source")]),
    case card.frame {
      Some(source) -> div([class("avatar__frame")], [picture.svg(source)])
      None -> element.none()
    },
    case card.decor {
      Some(source) -> div([class("avatar__decor")], [picture.svg(source)])
      None -> element.none()
    }
  ])
}
