type 'a point = 'a Geometry.point
type joy_shape = Geometry.joy_shape
type joy_shapes = Geometry.joy_shapes
type transformation = Transform.transformation
type color = Color.color

val point : int -> int -> float point
val circle : ?c:float point -> int -> joy_shape
val rectangle : ?c:float point -> int -> int -> joy_shape
val ellipse : ?c:float point -> int -> int -> joy_shape
val line : ?a:float point -> float point -> joy_shape
val polygon : float point list -> joy_shape
val complex : joy_shapes -> joy_shape
val with_stroke : color -> joy_shape -> joy_shape
val with_fill : color -> joy_shape -> joy_shape
val no_stroke : joy_shape -> joy_shape
val no_fill : joy_shape -> joy_shape
val rotate : int -> transformation
val translate : int -> int -> transformation
val scale : float -> transformation
val compose : transformation -> transformation -> transformation
val repeat : int -> transformation -> transformation
val map_stroke : (color -> color) -> joy_shape -> joy_shape
val map_fill : (color -> color) -> joy_shape -> joy_shape

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

val show : joy_shapes -> unit
val write : ?filename:string -> unit -> unit
