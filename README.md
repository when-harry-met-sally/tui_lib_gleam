# tui_lib_gleam

[![Package Version](https://img.shields.io/hexpm/v/tui_lib_gleam)](https://hex.pm/packages/tui_lib_gleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/tui_lib_gleam/)

```sh
gleam add tui_lib_gleam@1
```
```gleam
import tui_lib_gleam

pub fn main() -> Nil {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/tui_lib_gleam>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```


// fn parse_child(child: Component, parent: Component) -> Grid {
//   // we really just want to parse 
//   let position = #(
//     parent.position.0 + child.position.0,
//     parent.position.1 + child.position.1,
//   )
//
//   // This is how we handle overflow
//   let child_dimension_y = case
//     { parent.dimensions.0 < position.0 + child.dimensions.0 }
//   {
//     True -> parent.dimensions.0 - position.0
//     False -> child.dimensions.0
//   }
//
//   let child_dimension_x = case
//     { parent.dimensions.1 < position.1 + child.dimensions.1 }
//   {
//     True -> parent.dimensions.1 - position.1
//     False -> child.dimensions.1
//   }
//   let dimensions = #(child_dimension_y, child_dimension_x)
// }
