import gleam/dict
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import types

const whitespace = " "

pub fn main() -> Nil {
  let text = option.Some(["Hello from tui_lib_gleam!"])
  let my_first_component =
    types.Component(content: text, children: None, dimensions: #(10, 10))

  case my_first_component.content {
    Some(text) -> draw(text)
    _ -> Nil
  }
}

fn draw(lines: List(String)) {
  lines |> list.each(fn(line) { io.println(line) })
  Nil
}

fn get_grid(content: List(String), dimensions: #(Int, Int)) {
  let content_map =
    content
    |> list.index_map(fn(c, i) {
      let row_map =
        string.to_graphemes(c)
        |> list.index_map(fn(cc, i) { #(i, cc) })
        |> dict.from_list()

      #(i, row_map)
    })
    |> dict.from_list()

  let #(height, width) = dimensions
  // list.range(0, height) |> list.map()
}
