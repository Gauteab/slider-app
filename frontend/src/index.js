var app = Elm.Main.init({
  node: document.getElementById("root"),
});

// var socket = new WebSocket("ws://localhost:9160");
// var socket = new WebSocket("ws://158.39.201.82:9160");
var socket = new WebSocket(
  // hack to work on both local and server
  document.defaultView.origin.replace("http", "ws").replace("8000", "9160")
);

app.ports.sendMessage.subscribe(function (message) {
  socket.send(message);
});

socket.addEventListener("message", function (event) {
  app.ports.messageReceiver.send(event.data);
});
