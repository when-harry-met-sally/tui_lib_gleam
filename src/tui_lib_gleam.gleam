import core
import gleam/option.{None, Some}
import gleam/string
import gleam_community/ansi
import types.{Component, Style}

pub fn main() -> Nil {
  let s = ansi.bg_blue("MILES")
  echo s
  let res = string.to_graphemes(s)
  echo res
  let text1 =
    Some([
      "Hello from tui_lib_gleam, this is pretty cool don't you think!",
      "Line 2! My favorite little line", "Like 3, this line isn't as cool!",
      "Line 4",
    ])

  let text2 = Some(["Why am I making a TUI library in Gleam on a Friday"])

  let component_child_1 =
    Component(
      content: text1,
      children: None,
      dimensions: #(30, 25),
      position: #(0, 0),
      style: Style(types.BorderColor("red")),
    )

  let component_child_2 =
    Component(
      content: text2,
      children: None,
      dimensions: #(10, 10),
      position: #(1, 20),
      style: Style(types.BorderColor("red")),
    )

  let component_main =
    Component(
      content: None,
      children: Some([component_child_1, component_child_2]),
      dimensions: #(0, 0),
      position: #(0, 0),
      style: Style(types.BorderColor("red")),
    )
  core.handle_app(component_main)
}
