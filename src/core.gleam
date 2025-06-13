import constants
import gleam/dict
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/result
import gleam/string
import types.{type Component, type Dimensions, type Grid}

pub fn handle_component(component: Component) -> Nil {
  let screen_dimensions = #(40, 100)

  let grid =
    component
    |> parse_component()

  let lines = grid_to_lines(grid, screen_dimensions)

  draw_lines(lines)
  Nil
}

// Not sure if this is good, but we accept the left most, which takes precidence
fn merge_grids(grids: List(Grid)) -> Grid {
  let leftmost_grid = grids |> list.first() |> result.unwrap(dict.new())
  grids
  |> list.fold(leftmost_grid, fn(acc, grid) {
    let is_leftmost_grid = grid == leftmost_grid
    case is_leftmost_grid {
      True -> acc
      _ -> {
        dict.combine(leftmost_grid, grid, fn(l_row, r_row) {
          dict.combine(l_row, r_row, fn(l, _) { l })
        })
      }
    }
  })
}

fn parse_child(child: Component, parent: Component) -> Grid {
  // we really just want to parse 
  let content = child.content |> option.unwrap([])
  let dimensions = child.dimensions
  let position = #(
    parent.position.0 + child.position.0,
    parent.position.1 + child.position.1,
  )
  gridify_content(content, position, dimensions)
}

fn parse_component(component: Component) -> Grid {
  // This should really just recursively parse children to grid
  // the final grid is printed.
  case component.content {
    Some(text) ->
      gridify_content(text, component.position, component.dimensions)
    _ ->
      case component.children {
        Some([]) -> dict.new()
        Some(children) -> {
          let grids =
            children
            |> list.map(fn(child) { parse_child(child, component) })
          merge_grids(grids)
        }
        _ -> dict.new()
      }
    // this is where we would parse the children
  }
}

fn grid_to_lines(grid: Grid, dimensions: Dimensions) -> List(String) {
  let #(height, width) = dimensions
  list.range(0, height - 1)
  |> list.map(fn(y) {
    list.range(0, width - 1)
    |> list.map(fn(x) {
      case dict.get(grid, y) {
        Ok(m) -> {
          case dict.get(m, x) {
            Ok(char) -> char
            _ -> constants.whitespace
          }
        }
        _ -> constants.whitespace
      }
    })
    |> string.join("")
  })
}

fn draw_lines(lines: List(String)) -> Nil {
  lines
  |> list.each(fn(line) { io.println(line) })
}

// This is a way to quickly access elements via a hashmap, since we can't really do this with lists
// We can likely use some other data type, but this will do for now.
fn gridify_content(
  content: List(String),
  position: Dimensions,
  dimensions: Dimensions,
) -> Grid {
  let #(base_y, base_x) = position
  let #(height, width) = dimensions

  echo dimensions

  content
  |> list.take(height)
  |> list.index_map(fn(c, y) {
    let row_map =
      string.to_graphemes(c)
      |> list.take(width)
      |> list.index_map(fn(cc, x) { #(x + base_x, cc) })
      |> dict.from_list()

    #(y + base_y, row_map)
  })
  |> dict.from_list()
}
