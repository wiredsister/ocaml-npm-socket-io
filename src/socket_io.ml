module Raw_js = struct

  class type client = object end
  class type socket = object end
  class type namespace = object end
  class type server = object end

  class type socket_io = object
    method listen : Nodejs.Http.server -> socket_io Js.t Js.meth
    method sockets : namespace Js.t Js.readonly_prop
  end

end

class socket raw_js = object

  method on
      ~event_name:(event_name : string)
      (f : (Js.Unsafe.any -> unit)) : unit =
    Nodejs.m raw_js "on" [|Nodejs.i event_name; Nodejs.i f|]

  method id : string =
    Nodejs.g raw_js "id" |> Js.to_string

end

class namespace raw_js = object(self)

  method name =
    Nodejs.g raw_js "name" |> Js.to_string

  method on_connection (f : (socket -> unit)) : unit =
    let wrapped_listener = fun this_socket ->
      f (new socket this_socket)
    in
    Nodejs.m raw_js "on" [|Nodejs.i "connection"; Nodejs.i wrapped_listener|]

  method emit (s : string) (anything : Js.Unsafe.any) : unit =
    Nodejs.m raw_js "emit" [|Nodejs.i s; anything|]

end

class socket_io raw_js = object(self)

  method listen (s : Nodejs.Http.server) : socket_io =
    new socket_io (raw_js##listen s)

  method sockets : namespace =
    new namespace raw_js##.sockets

end

let require () =
  let raw_js : Raw_js.socket_io Js.t = Nodejs.require_module "socket.io" in
  new socket_io raw_js
