import gleeunit
import utils/format

pub fn main() {
  gleeunit.main()
}

pub fn format_test() {
  assert format.number(100) == "100"
  assert format.number(500) == "500"
  assert format.number(999) == "999"

  assert format.number(1_000) == "1K"
  assert format.number(1_582) == "1.6K"
  assert format.number(9_999) == "10K"

  assert format.number(1_000_000) == "1M"
  assert format.number(1_527_000) == "1.5M"

  assert format.number(1_012_294_947) == "1B"
  assert format.number(1_500_000_124) == "1.5B"
}
