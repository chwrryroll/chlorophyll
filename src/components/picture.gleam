import lustre/element   .{type Element}
import lustre/attribute .{type Attribute, src}

pub fn svg(content: String) -> Element(t) {
  element.unsafe_raw_html("", "svg", [], content)
}

pub fn img(content: String, attr: List(Attribute(t))) -> Element(t) {
  element.unsafe_raw_html("", "img", [src(content), ..attr], "")
}
