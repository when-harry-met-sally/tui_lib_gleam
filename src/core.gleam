import constants
import gleam/dict
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import types.{type Component, type Dimensions, type Grid}

pub fn handle_app(app: Component) -> Nil {
  let screen_dimensions = #(40, 100)

  let initial_position = #(0, 0)

  let grid = parse_app(app, initial_position)

  let lines = grid_to_lines(grid, screen_dimensions)

  draw_lines(lines)
  Nil
}

fn parse_app(app: Component, position: Dimensions) -> Grid {
  parse_component(None, app, position)
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
          dict.combine(l_row, r_row, fn(_, r) { r })
        })
      }
    }
  })
}

fn format_text(component: Component, lines: List(String)) -> List(String) {
  let #(width, height) = component.dimensions

  let inner_height = height - 2
  let inner_width = width - 2
  let inner_lines = list.take(lines, inner_height)

  let rows =
    inner_lines
    |> list.map(fn(row) {
      let text = string.to_graphemes(row) |> list.take(inner_width)
      let whitespace_count = inner_width - list.length(text)
      constants.column
      <> string.join(text, "")
      <> string.repeat(constants.whitespace, whitespace_count)
      <> constants.column
    })

  let top_bar =
    constants.top_left
    <> string.repeat(constants.bar, inner_width)
    <> constants.top_right

  let bot_bar =
    constants.bot_left
    <> string.repeat(constants.bar, inner_width)
    <> constants.bot_right

  // TODO: Do this differently...
  [[top_bar], rows, [bot_bar]] |> list.flatten()
}

fn parse_component(
  parent: Option(Component),
  component: Component,
  position: Dimensions,
) -> Grid {
  // TODO: Overflow issue
  let max_dimensions = case parent {
    _ -> component.dimensions
  }
  let new_position = #(
    position.0 + component.position.0,
    position.1 + component.position.1,
  )
  // This should really just recursively parse children to grid
  // the final grid is printed.
  case component.content, component.children {
    // Errors 
    Some(_), Some(_) ->
      panic as "Cannot have a component with both children and text content"
    None, None -> panic as "Component must have children or text content"
    //
    Some(text), None ->
      format_text(component, text)
      |> gridify_content(new_position, max_dimensions)
    _, Some([]) -> {
      dict.new()
    }
    _, Some(children) -> {
      let grids =
        children
        |> list.map(fn(child) {
          parse_component(Some(component), child, new_position)
        })
      merge_grids(grids)
    }
    // this is where we would parse the children
  }
}

// fn alter_dimensions(parent: Component, child: Component) {
//
// }

fn grid_to_lines(grid: Grid, dimensions: Dimensions) -> List(String) {
  let #(width, height) = dimensions
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
  let #(width, height) = dimensions

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
