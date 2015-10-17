class type client = object
  (* method conn :  *)
end

class type socket = object
  inherit Nodejs.Events.event_emitter
  method client : client Js.t Js.readonly_prop
  method on :
    Js.js_string Js.t ->
    (Js.Unsafe.any -> unit) Js.callback ->
    unit Js.meth
end

class type namespace = object
  inherit Nodejs.Events.event_emitter
  method on_ :
    Js.js_string Js.t ->
    (socket Js.t -> unit) Js.callback ->
    unit Js.meth
end

class type socket_io = object
  inherit Nodejs.Events.event_emitter
  method listen : Nodejs.Http.server Js.t -> socket_io Js.t Js.meth
  method sockets : namespace Js.t Js.readonly_prop
  method emit_ :
    Js.js_string Js.t ->
    Js.Unsafe.any ->
    unit Js.meth
end

class type server = object

end

let require () : socket_io Js.t =
  Nodejs_globals.require (Js.string "socket.io")

let server () : server Js.t =
  Js.Unsafe.eval_string "require(\"socket.io\")()"
