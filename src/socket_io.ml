class type client = object
  (* method conn :  *)
end

class type socket = object
  method client : client Js.t Js.readonly_prop
  method on :
    Js.js_string Js.t ->
    (Js.Unsafe.any -> unit) Js.callback ->
    unit Js.meth
end

class type namespace = object
  method emit :
    Js.js_string Js.t ->
    ('a Js.t -> unit) Js.callback ->
    unit Js.meth

  method on :
    Js.js_string Js.t ->
    (socket Js.t -> unit) Js.callback ->
    unit Js.meth
end

class type server = object

  method on :
    Js.js_string Js.t ->
    (socket Js.t -> unit) Js.callback ->
    unit Js.meth

end

class type socket_io = object
  method listen : Nodejs.Http.server Js.t -> socket_io Js.t Js.meth
  method sockets : namespace Js.t Js.readonly_prop
  method call_arg : 'a Js.t -> server Js.t Js.meth
  method emit :
    Js.js_string Js.t ->
    Js.Unsafe.any ->
    unit Js.meth
end

let require () : socket_io Js.t =
  Nodejs_globals.require "socket.io"

let server () : server Js.t =
  Js.Unsafe.eval_string "require(\"socket.io\")()"
