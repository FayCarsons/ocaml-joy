(* JS deps *)
module Html = Js_of_ocaml.Dom_html
module Dom = Js_of_ocaml.Dom
module Js = Js_of_ocaml.Js
module G = Graphics_js

type point = { x : float; y : float }

let ( -! ) { x; y } scalar = { x = x -. scalar; y = y -. scalar }

type circle = { c : point; radius : float }
type ellipse = { c : point; rx : float; ry : float }
type rectangle = { c : point; width : float; height : float }
type line = { a : point; b : point }
type polygon = point list

type shape =
  | Circle of circle
  | Ellipse of ellipse
  | Rectangle of rectangle
  | Line of line
  | Polygon of polygon
  | Complex of shape list

(* JS type conversion helpers *)
let str = Js.string
let bl = Js.bool

(* aliases for globals *)
let doc = Html.document
let window = Html.window

(* Context *)
type joy_context = {
  context : Html.canvasRenderingContext2D Js.t;
  canvas : Html.canvasElement Js.t;
}

let context : joy_context option ref = ref None
let fail () = window##alert (str "Context not initialized!")

let init_context canvas =
  if Option.is_some !context then
    window##alert (str "Context cannot be initialized twice!")
  else (
    G.open_canvas canvas;
    Dom.appendChild doc##.body canvas;
    let ctx = canvas##getContext Html._2d_ in
    context := Some { context = ctx; canvas })

let get_window_size () =
  let w = float_of_int window##.innerWidth in
  let h = float_of_int window##.innerHeight in
  (w, h)

let maximize_canvas () =
  match !context with
  | Some ctx ->
      let w, h = get_window_size () in
      ctx.canvas##.width := int_of_float w;
      ctx.canvas##.height := int_of_float h
  | None -> fail ()

let create_canvas () =
  let w, h = get_window_size () in
  let canvas = Html.createCanvas doc in
  canvas##.width := int_of_float w;
  canvas##.height := int_of_float h;
  canvas

let color_str (r, g, b) =
  str (Printf.sprintf "rgb(%f, %f, %f)" (r *. 255.) (g *. 255.) (b *. 255.))

(* Sets global color *)
let set_color color =
  match !context with
  | Some { context; canvas = _canvas } ->
      let color_string = color_str color in
      context##.fillStyle := color_string
  | None -> fail ()

(* sets background color *)
let background color =
  match !context with
  | Some { context; canvas = _canvas } ->
      let w, h = get_window_size () in
      let _color_string = color_str color in
      context##.fillStyle := str "white";
      context##fillRect 0. 0. w h
  | None -> fail ()

let draw_circle ctx { c; radius } =
  let { x; y } = c in
  ctx##beginPath;
  ctx##arc x y radius 0. (2. *. Float.pi) (bl false);
  ctx##stroke

(* 'Normalize' values so that API matches native implementation *)
let draw_rect ctx { c; width; height } =
  let width, height = (width *. 2., height *. 2.) in
  let c = c -! ((width +. height) /. 4.) in
  ctx##strokeRect c.x c.y width height

let draw_line ctx { a = { x = x1; y = y1 }; b = { x = x2; y = y2 } } =
  ctx##moveTo x1 y1;
  ctx##lineTo x2 y2;
  ctx##stroke;
  ctx##moveTo 0. 0.

(* Ellipse helper fn & rendering fn
   currently just multiplying radii by 2 to offset scaling issue
   feels hacky *)
let calculate_control_points ({ c = { x; y }; rx; ry } : ellipse) =
  let rx, ry = (rx *. 2., ry *. 2.) in
  let half_height = ry /. 2. in
  let width_two_thirds = rx *. (2. /. 3.) in
  ( { x; y = y -. half_height },
    ( x +. width_two_thirds,
      y -. half_height,
      x +. width_two_thirds,
      y +. half_height,
      x,
      y +. half_height ),
    ( x -. width_two_thirds,
      y +. half_height,
      x -. width_two_thirds,
      y -. half_height,
      x,
      y -. half_height ) )

let draw_ellipse ctx (ellipse : ellipse) =
  let start, curve_one, curve_two = calculate_control_points ellipse in
  ctx##moveTo start.x start.y;
  let x1, y1, x2, y2, x3, y3 = curve_one in
  ctx##bezierCurveTo x1 y1 x2 y2 x3 y3;
  let x1, y1, x2, y2, x3, y3 = curve_two in
  ctx##bezierCurveTo x1 y1 x2 y2 x3 y3;
  ctx##stroke;
  ctx##moveTo 0. 0.

(* Polygon helper fns and rendering fn *)
let rec take n lst =
  match (n, lst) with
  | 0, _ -> ([], lst)
  | _, [] -> ([], [])
  | n, x :: xs ->
      let taken, rest = take (n - 1) xs in
      (x :: taken, rest)

let rec partition n ?step lst =
  match lst with
  | [] -> []
  | _ ->
      let taken, _ = take n lst in
      if List.length taken = n then
        taken
        ::
        (match step with
        | Some s -> partition n ~step:s (List.tl lst)
        | None -> partition n ~step:0 (List.tl lst))
      else []

let draw_polygon ctx (polygon : polygon) =
  let points = partition 2 ~step:1 (polygon @ [ List.hd polygon ]) in
  List.iter
    (fun pair ->
      let { x = x1; y = y1 }, { x = x2; y = y2 } =
        (List.nth pair 0, List.nth pair 1)
      in
      ctx##moveTo x1 y1;
      ctx##lineTo x2 y2)
    points;
  ctx##stroke;
  ctx##moveTo 0. 0.

let rec render_shape ctx shape =
  match shape with
  | Circle circle -> draw_circle ctx circle
  | Rectangle rectangle -> draw_rect ctx rectangle
  | Ellipse ellipse -> draw_ellipse ctx ellipse
  | Line line -> draw_line ctx line
  | Polygon polygon -> draw_polygon ctx polygon
  | Complex complex -> List.iter (render_shape ctx) complex

let render shape =
  match !context with
  | Some ctx -> render_shape ctx.context shape
  | None -> fail ()

let draw () =
  let w, h = get_window_size () in
  let c = { x = w /. 2.; y = h /. 2. } in
  background (1., 1., 1.);
  set_color (0., 0., 0.);
  let circle = Circle { c; radius = 100. } in
  let rect = Rectangle { c; width = 100.; height = 100. } in
  let ellip = Ellipse { c; rx = 100.; ry = 75. } in
  let polygon =
    Polygon
      (List.map
         (fun { x; y } -> { x = x +. 10.; y = y +. 10. })
         [ c; { x = c.x; y = c.y +. 100. }; { x = c.x +. 100.; y = c.y } ])
  in
  let axes =
    Complex
      [
        Line { a = { x = w /. 2.; y = 0. }; b = { x = w /. 2.; y = h } };
        Line { a = { x = 0.; y = h /. 2. }; b = { x = w; y = h /. 2. } };
      ]
  in
  let complex = Complex [ circle; rect; ellip; polygon; axes ] in
  render complex

let onload _ =
  let canvas = create_canvas () in
  init_context canvas;
  maximize_canvas ();
  draw ();
  Js._true

let _ = window##.onload := Html.handler onload
