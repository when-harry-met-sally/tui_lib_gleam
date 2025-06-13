import gleam/option.{type Option}

pub type Component {
  Component(
    content: Option(List(String)),
    children: Option(List(Component)),
    dimensions: #(Int, Int),
  )
}
