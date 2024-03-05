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

type primitive =
  | Circle of circle
  | Ellipse of ellipse
  | Line of line
  | Polygon of polygon
  | Complex of primitive list

type primitives = primitive list

val point : int -> int -> float point
val circle : ?c:float point -> int -> primitive
val rectangle : ?c:float point -> int -> int -> primitive
val ellipse : ?c:float point -> int -> int -> primitive
val complex : primitive list -> primitive
val line : ?a:float point -> float point -> primitive
val polygon : float point list -> primitive
val with_stroke : color -> primitive -> primitive
val with_fill : color -> primitive -> primitive
val no_stroke : primitive -> primitive
val no_fill : primitive -> primitive
