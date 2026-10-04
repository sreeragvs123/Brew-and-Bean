import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';


class SseMessage {
  final String event;
  final String data;
  const SseMessage({required this.event, required this.data});
}

/// Reads a Server-Sent Events stream (text/event-stream) line by line.
///
/// A message looks like:
///   event: order
///   data: {"id":1,...}
///   <blank line>
class SseClient {
  /// The server sends a heartbeat every 25 s, so 60 s of silence means the connection is dead.
  static const _silenceLimit = Duration(seconds: 60);

  Stream<SseMessage> connect(String url) async* {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15))); // own instance, so closing it ends only this stream
    try {
     final response = await dio.get<ResponseBody>(
       url,
       options: Options(
         responseType: ResponseType.stream,
         receiveTimeout: Duration.zero, // the stream stays open; silence is checked below
         headers: {'Accept': 'text/event-stream', 'Cache-Control': 'no-cache'},
       ),
     );

     final lines = response.data!.stream
         .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .timeout(_silenceLimit);

      var eventName = 'message';
      final data = StringBuffer();

      await for (final line in lines) {
        if (line.isEmpty) {
          // blank line = the message is complete
          if (data.isNotEmpty) {
            yield SseMessage(event: eventName, data: data.toString());
          }
          eventName = 'message';
          data.clear();
        } else if (line.startsWith('event:')) {
          eventName = line.substring(6).trim();
        } else if (line.startsWith('data:')) {
          if (data.isNotEmpty) data.write('\n');
          data.write(line.substring(5).trim());
        }
        // lines starting with ':' are comments (heartbeat), ignore them
      }
    } finally {
      dio.close(force: true);
    }
  }
}
