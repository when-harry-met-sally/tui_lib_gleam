import gleam/dict.{type Dict}
import gleam/option.{type Option}

pub type Component {
  Component(
    content: Option(List(String)),
    children: Option(List(Component)),
    dimensions: Dimensions,
    position: Dimensions,
  )
}

pub type Dimensions =
  #(Int, Int)

pub type Grid =
  Dict(Int, Dict(Int, String))
