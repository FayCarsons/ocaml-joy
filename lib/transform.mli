type transformation = Primitive.primitive -> Primitive.primitive

val translate : int -> int -> transformation
val scale : float -> transformation
val rotate : int -> transformation
val compose : transformation -> transformation -> transformation
val repeat : int -> transformation -> transformation
val map_fill : (Color.color -> Color.color) -> transformation
val map_stroke : (Color.color -> Color.color) -> transformation
