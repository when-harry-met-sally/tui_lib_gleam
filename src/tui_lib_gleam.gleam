import gleam/dict
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import types.{type Component, type Dimensions, type Grid, Component}

const whitespace = " "

pub fn main() -> Nil {
  let text =
    option.Some([
      "Hello from tui_lib_gleam, this is pretty cool don't you think!",
      "Line 2! My favorite little line", "Like 3, this line isn't as cool",
    ])
  let dimensions = #(10, 30)
  let position = #(0, 0)

  let my_component =
    Component(content: text, children: None, dimensions:, position:)

  parse_component(my_component)

  Nil
}

fn parse_child(parent: Component, child: Component) -> Grid {
  // we really just want to parse 
  let content = child.content |> option.unwrap([])
  let position = #(
    parent.position.0 + child.position.0,
    parent.position.1 + child.position.1,
  )
  gridify_content(content, position)
}

fn parse_component(component: Component) -> Nil {
  // This should really just recursively parse children to grid
  // the final grid is printed.
  let content = case component.content {
    Some(c) -> c
    _ -> []
    // this is where we would parse the children
  }
  let dimensions = component.dimensions
  let grid = gridify_content(content, component.position)
  draw_grid(grid, dimensions)
}

fn draw_grid(grid: Grid, dimensions: Dimensions) -> Nil {
  let #(height, width) = dimensions
  list.range(0, height - 1)
  |> list.map(fn(y) {
    let row =
      list.range(0, width - 1)
      |> list.map(fn(x) {
        case dict.get(grid, y) {
          Ok(m) -> {
            case dict.get(m, x) {
              Ok(char) -> char
              _ -> whitespace
            }
          }
          _ -> whitespace
        }
      })
      |> string.join("")
    io.println(row)
  })
  Nil
}

// This is a way to quickly access elements via a hashmap, since we can't really do this with lists
// We can likely use some other data type, but this will do for now.
fn gridify_content(content: List(String), position: Dimensions) -> Grid {
  let #(base_y, base_x) = position
  content
  |> list.index_map(fn(c, y) {
    let row_map =
      string.to_graphemes(c)
      |> list.index_map(fn(cc, x) { #(x + base_x, cc) })
      |> dict.from_list()

    #(y + base_y, row_map)
  })
  |> dict.from_list()
}
