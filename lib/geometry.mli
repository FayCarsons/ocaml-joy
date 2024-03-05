type color = Color.color
type 'a point = { x : 'a; y : 'a }

type circle = {
  c : float point;
  radius : float;
  stroke : color option;
  fill : color option;
}

type ellipse = {
  c : float point;
  rx : float;
  ry : float;
  stroke : color option;
  fill : color option;
}

type polygon = {
  vertices : float point list;
  stroke : color option;
  fill : color option;
}

type line = { a : float point; b : float point; stroke : color }

type joy_shape =
  | Circle of circle
  | Ellipse of ellipse
  | Line of line
  | Polygon of polygon
  | Complex of joy_shape list

type joy_shapes = joy_shape list

val point : int -> int -> float point
val circle : ?c:float point -> int -> joy_shape
val rectangle : ?c:float point -> int -> int -> joy_shape
val ellipse : ?c:float point -> int -> int -> joy_shape
val complex : joy_shape list -> joy_shape
val line : ?a:float point -> float point -> joy_shape
val polygon : float point list -> joy_shape
val with_stroke : color -> joy_shape -> joy_shape
val with_fill : color -> joy_shape -> joy_shape
val no_stroke : joy_shape -> joy_shape
val no_fill : joy_shape -> joy_shape
