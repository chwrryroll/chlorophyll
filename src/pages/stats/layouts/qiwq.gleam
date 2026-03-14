import lustre/attribute    .{class, role, href, width, height}
import lustre/element      .{type Element}
import lustre/element/html .{text, div, h1}
import lustre/element/svg  .{foreign_object, image, svg}

import pages/stats/struct .{type Card}
import pages/stats/parts/avatar
import pages/stats/parts/table

import components/stylesheet

pub fn view(card: Card) -> Element(t) {
  svg([width(1380),  height(550), role("img")], [
    stylesheet.embed(card.stylesheet),
    image([class("card__background"), href(card.background), width(1380), height(550)]),
    foreign_object([width(1380), height(550)], [
      h1([class("card__title")], [text(card.title)]),
      div([class("card__content")], [table.part(card), avatar.part(card)])
    ])
  ])
}
