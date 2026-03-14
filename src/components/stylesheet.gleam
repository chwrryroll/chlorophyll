import lustre/element     .{type Element}
import lustre/element/svg .{defs, style}

pub fn embed(css: String) -> Element(t) {
  defs([], [
    style([], css)
  ])
}
