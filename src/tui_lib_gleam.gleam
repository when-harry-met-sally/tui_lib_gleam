import gleam/io
import gleam/list
import gleam/option.{None, Some}
import types

pub fn main() -> Nil {
  let text = option.Some(["Hello from tui_lib_gleam!"])
  let my_first_component = types.Component(content: text, child: None)

  case my_first_component.content {
    Some(text) -> draw(text)
    _ -> Nil
  }
}

fn draw(lines: List(String)) {
  lines |> list.each(fn(line) { io.println(line) })
  Nil
}
