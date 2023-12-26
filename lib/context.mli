type context = {
  ctx : Cairo.context;
  surface : Cairo.Surface.t;
  size : float * float;
  filename : string;
}

val context : context option ref
val fail : unit -> unit

exception Context of string

val init_context : float -> float * float -> string -> unit
val resolution : unit -> float * float
val set_color : float * float * float -> unit
val background : float * float * float * float -> unit
val set_line_width : float -> unit
val write : context -> unit
