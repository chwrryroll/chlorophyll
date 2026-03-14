import gleam/list

import lustre/element      .{type Element}
import lustre/element/html .{tr, td, text, table}
import lustre/attribute    .{class}

import components/picture

import pages/stats/struct .{type Card}

pub fn part(card: Card) -> Element(t) {
  table([class("content__table")],
    list.map(card.rows, fn(row) {
      tr([class("table__row")], [
        td([class("row__icon")]  , [picture.svg(row.icon)]),
        td([class("row__label")] , [text(row.label)]),
        td([class("row__value")] , [text(row.value)])
      ])
    })
  )
}
