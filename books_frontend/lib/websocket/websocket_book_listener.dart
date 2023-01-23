import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketBookListener {
  final Uri _uri;
  WebSocketChannel? _channel;

  WebsocketBookListener({required String uri}) : _uri = Uri.parse(uri);

  Future<bool> connect(Function(dynamic message) listener) async {
    if (_channel != null) {
      _channel!.sink.close();
    }

    try {
      _channel = WebSocketChannel.connect(_uri);
      _channel!.stream.listen(listener);
      return true;
    } catch (error) {
      _channel = null;
      return false;
    }
  }
}
