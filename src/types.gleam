import gleam/option.{type Option}

pub type Component {
  Component(content: Option(List(String)), child: Option(Component))
}
