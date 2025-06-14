import core
import gleam/option.{None, Some}
import types.{Component}

pub fn main() -> Nil {
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
    )

  let component_child_2 =
    Component(
      content: text2,
      children: None,
      dimensions: #(10, 10),
      position: #(1, 20),
    )

  let component_main =
    Component(
      content: None,
      children: Some([component_child_1, component_child_2]),
      dimensions: #(50, 50),
      position: #(0, 0),
    )
  core.handle_component(component_main)
}
