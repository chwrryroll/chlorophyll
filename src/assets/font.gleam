pub type Font {
  CutiePatootie
  Lilian
  PleaseWriteMeASong
  Slopness
}

pub fn file(of font: Font) -> String {
  case font {
    CutiePatootie      -> "cutie-patootie.ttf"
    Lilian             -> "lilian.ttf"
    PleaseWriteMeASong -> "please-write-me-a-song.ttf"
    Slopness           -> "slopness.ttf"
  }
}
