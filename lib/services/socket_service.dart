import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final IO.Socket _socket = IO.io(
    "http://127.0.0.1:3000", // Mets l’URL de ton backend ici
    IO.OptionBuilder()
        .setTransports(['websocket']) // Utilisation WebSocket
        .enableAutoConnect() // Auto connexion
        .build(),
  );

  static IO.Socket get socket => _socket;

  static void connect() {
    if (!_socket.connected) {
      _socket.connect();
    }
  }

  static void disconnect() {
    if (_socket.connected) {
      _socket.disconnect();
    }
  }
}
