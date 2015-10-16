

class type socket_io = object

end

let require () : socket_io Js.t =
  Internal.require (Js.string "socket.io")
