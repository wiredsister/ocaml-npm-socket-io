

class type socket_io = object
  inherit Nodejs.Events.event_emitter
  method listen : Nodejs.Http.server -> socket_io Js.t Js.meth
end

let require () : socket_io Js.t =
  Nodejs_globals.require (Js.string "socket.io")
