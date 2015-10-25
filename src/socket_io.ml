open Nodejs_kit

class type client = object
  (* method conn :  *)
end

(** A socket object, not the module *)
class type socket = object

  method username : js_str Js.readonly_prop

  method client : client Js.t Js.readonly_prop

  method broadcast : socket Js.t Js.readonly_prop

  method emit :
    js_str ->
    <username : js_str; message : js_str> Js.t ->
    unit Js.meth

  method on : js_str -> (Js.Unsafe.any Js.t -> unit) Js.callback -> unit Js.meth

end

class type namespace = object

  method emit : js_str -> ('a Js.t -> unit) Js.callback -> unit Js.meth

  method on : js_str -> (socket Js.t -> unit) Js.callback -> unit Js.meth

end

class type server = object

  method on : js_str -> (socket Js.t -> unit) Js.callback -> unit Js.meth

end

let server : (unit -> server Js.t) Js.constr =
  Js.Unsafe.js_expr "require(\"socket.io\")"

(** The module object socket.io *)
class type socket_io = object

  method listen : Nodejs.Http.server Js.t -> socket_io Js.t Js.meth

  method sockets : namespace Js.t Js.readonly_prop

  method call_arg : 'a Js.t -> server Js.t Js.meth

  method emit : js_str -> 'a Js.t -> unit Js.meth

end

let require () : socket_io Js.t =
  Nodejs_kit.require "socket.io"
