open Nodejs

module Raw_js = struct
  type js_str = Js.js_string Js.t
  class type client = object end

  class type socket = object
    method username : js_str Js.readonly_prop
    method client : client Js.t Js.readonly_prop
    method broadcast : socket Js.t Js.readonly_prop
    method on : js_str -> (Js.Unsafe.any -> unit) Js.callback -> unit Js.meth
  end
  class type namespace = object
    method emit : js_str -> ('a Js.t -> unit) Js.callback -> unit Js.meth
    method on : js_str -> (socket -> unit) Js.callback -> unit Js.meth
  end

  class type server = object

    method on : js_str -> (socket Js.t -> unit) Js.callback -> unit Js.meth

  end

  let server : (unit -> server Js.t) Js.constr =
    Js.Unsafe.js_expr "require(\"socket.io\")"

  class type socket_io = object
    method listen : Nodejs.Http.server -> socket_io Js.t Js.meth
    method sockets : namespace Js.t Js.readonly_prop
    method emit : js_str -> 'a Js.t -> unit Js.meth
  end
end

class socket js_obj = object

  method on
      ~event_name:(event_name : string)
      (f : (Js.Unsafe.any -> unit)) : unit =
    js_obj##on (Js.string event_name) !@f

  method id = js_obj <!> "id" |> Js.to_string

end

class namespace js_obj = object

  method on_connection (f : (socket -> unit)) : unit =
    let wrapped_f = fun this_socket -> f (new socket this_socket) in
    js_obj##on (Js.string "connection") !@wrapped_f

  method emit ~event_name:(event_name : string) (a : Js.Unsafe.any) : unit =
    js_obj##emit (Js.string event_name) a

end

class socket_io js_obj = object

  method listen (s : Nodejs.Http.server) : socket_io =
    new socket_io (js_obj##listen s)

  method sockets : namespace =
    new namespace (js_obj <!> "sockets")

end

let require () =
  new socket_io (require_module "socket.io")
