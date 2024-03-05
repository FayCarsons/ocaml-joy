type 'a point = 'a Primitive.point
type primitive = Primitive.primitive
type primitives = Primitive.primitives
type transformation = Transform.transformation
type color = Color.color

val point : int -> int -> float point
val circle : ?c:float point -> int -> primitive
val rectangle : ?c:float point -> int -> int -> primitive
val ellipse : ?c:float point -> int -> int -> primitive
val line : ?a:float point -> float point -> primitive
val polygon : float point list -> primitive
val complex : primitives -> primitive
val with_stroke : color -> primitive -> primitive
val with_fill : color -> primitive -> primitive
val no_stroke : primitive -> primitive
val no_fill : primitive -> primitive
val rotate : int -> transformation
val translate : int -> int -> transformation
val scale : float -> transformation
val compose : transformation -> transformation -> transformation
val repeat : int -> transformation -> transformation
val map_stroke : (color -> color) -> primitive -> primitive
val map_fill : (color -> color) -> primitive -> primitive

val random : ?min:int -> int -> int 
val frandom : ?min:float -> float -> float 
val noise : float list -> float 
val fractal_noise : ?octaves:int -> float list -> float

val context : Context.context option ref
val set_line_width : int -> unit
val black : color
val white : color
val red : color
val green : color
val blue : color
val yellow : color
val transparent : int * int * int * int
val opaque : color -> int * int * int * int

val init :
  ?background:color ->
  ?line_width:int ->
  ?size:int * int ->
  ?axes:bool ->
  unit ->
  unit

val show : primitives -> unit
val write : ?filename:string -> unit -> unit
