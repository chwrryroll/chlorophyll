pub type Locale {
  Tr En
}

pub fn name(of code: Locale) -> String {
  case code {
    En -> "English"
    Tr -> "Turkish"
  }
}

pub fn file(of code: Locale) -> String {
  case code {
    En -> ".pot"
    Tr -> "tr.po"
  }
}
