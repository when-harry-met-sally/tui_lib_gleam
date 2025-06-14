import gleam/dict.{type Dict}
import gleam/option.{type Option}

pub type Component {
  Component(
    content: Option(List(String)),
    children: Option(List(Component)),
    dimensions: XY,
    position: XY,
  )
}

pub type XY =
  #(Int, Int)

pub type Grid =
  Dict(Int, Dict(Int, String))

// ---- 

pub type VComponent {
  VComponent(
    content: Option(List(String)),
    children: Option(List(Component)),
    style: Style,
  )
}

pub type Style {
  Style(position: Option(Positioning))
}

pub type Positioning {
  Absolute
  Relative
}
