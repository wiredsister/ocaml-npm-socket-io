(** These are high level js_of_ocaml bindings to the socket.io
    library *)

(** An individual socket, usually created by the library *)
class socket :
  < on : Js.js_string Js.t ->
      ('a, Js.Unsafe.any -> unit) Js.meth_callback -> unit Js.meth;
    .. >
    Js.t ->
  object method on : event_name:string -> (Js.Unsafe.any -> unit) -> unit end

(** A socket.io namespace object *)
class namespace :
  < emit : Js.js_string Js.t -> Js.Unsafe.any -> unit Js.meth;
    on : Js.js_string Js.t ->
      ('a,
       < on : Js.js_string Js.t ->
           ('b, Js.Unsafe.any -> unit) Js.meth_callback -> unit Js.meth;
         .. >
         Js.t -> unit)
        Js.meth_callback -> unit Js.meth;
    .. >
    Js.t ->
  object
    method emit : event_name:string -> Js.Unsafe.any -> unit
    method on_connection : (socket -> unit) -> unit
  end

(** Represents the socket.io module *)
class socket_io :
  (< listen : Nodejs.Http.server -> 'a Js.meth; .. > Js.t as 'a) ->
  object
    method listen : Nodejs.Http.server -> socket_io
    method sockets : namespace
  end

(** Main entry point of usage of the socket.io npm pacakge *)
val require : unit -> socket_io
