import gleam/dict.{type Dict}
import gleam/option.{type Option}

pub type Component {
  Component(
    content: Option(List(String)),
    children: Option(List(Component)),
    dimensions: XY,
    position: XY,
    style: Style,
  )
}

pub type XY =
  #(Int, Int)

pub type Grid =
  Dict(Int, Dict(Int, String))

// ---- 

pub type Style {
  Style(border: Border)
}

pub type Positioning {
  Absolute(XY)
  Relative(XY)
  Static
}

pub type Border {
  // Width(Int)
  BorderColor(String)
}
