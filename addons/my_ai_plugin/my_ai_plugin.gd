@tool
extends EditorPlugin

   var http_server: HTTPServer = null

   func _enter_tree():
       http_server = HTTPServer.new()
       var port = 8081
       var err = http_server.listen(port)
       if err == OK:
           print("HTTP Server started on port %d" % port)
       else:
           push_error("Failed to start HTTP Server: %s" % err)
       print("AI HTTP Listener plugin loaded.")

   func _exit_tree():
       if http_server:
           http_server.stop()
           http_server = null
       print("AI HTTP Listener plugin unloaded.")