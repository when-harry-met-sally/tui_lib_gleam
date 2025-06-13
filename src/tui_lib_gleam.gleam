import core
import gleam/option.{None, Some}
import types.{Component}

pub fn main() -> Nil {
  let text =
    Some([
      "Hello from tui_lib_gleam, this is pretty cool don't you think!",
      "Line 2! My favorite little line", "Like 3, this line isn't as cool!",
      "Line 4",
    ])

  let component_child_1 =
    Component(content: text, children: None, dimensions: #(10, 10), position: #(
      5,
      5,
    ))

  let component_child_2 =
    Component(
      content: Some(["_ _"]),
      children: None,
      dimensions: #(5, 5),
      position: #(0, 0),
    )

  let component_main =
    Component(
      content: None,
      children: Some([component_child_1, component_child_2]),
      dimensions: #(2, 2),
      position: #(0, 0),
    )
  core.handle_component(component_main)
}
