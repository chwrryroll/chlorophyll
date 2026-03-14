import gleam/option .{type Option, Some, None}

pub type Layout {
  Qiwq
  Piwp
}

pub type Decor {
  Ribbon
}

pub type Frame {
  Catface
}

pub type Icon {
  Kitten
}

pub fn decor_file(of decor: Option(Decor)) -> Option(String) {
  case decor {
    Some(Ribbon) -> Some("ribbon.svg")
    None -> None
  }
}

pub fn frame_file(of frame: Option(Frame)) -> Option(String) {
 case frame {
    Some(Catface) -> Some("catface.svg")
    None -> None
  }
}

pub fn icon_file(of icon: Icon) -> String {
  case icon {
    Kitten -> "ribbon.svg"
  }
}
