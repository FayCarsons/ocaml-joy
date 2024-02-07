open Joy.Svg

let () =
  init ();
  background (255, 255, 255, 255);
  (* create an ellipse *)
  let e = ellipse 100 75 in
  (* render it *)
  set_color (0, 0, 0);
  show [ e ];
  write ~filename:"ellipse.png" ()
