pub type Background {
  Light
  PinkyPromiseLeft
  PinkyPromiseRight
  Spacy
}

pub fn file(of bg: Background) -> String {
  case bg {
    Light             -> "light.jpg"
    PinkyPromiseLeft  -> "pinky-promise-right.jpg"
    PinkyPromiseRight -> "pinky-promise-right.jpg"
    Spacy             -> "spacy.jpg"
  }
}
