library shelf_static.example;

import 'dart:io';
import 'dart:isolate';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

void main(List<String> args) {
  var count = 0;
  if (args.length > 0) {
    count = int.parse(args[0]);
  }

  if (count == 0) {
    count = Platform.numberOfProcessors;
  }

  if (!FileSystemEntity.isFileSync('bin/server.dart')) {
    throw new StateError('Server expects to be started from '
        'the root of the project.');
  }

  ProcessSignal.SIGINT.watch().listen((sig) {
    print('Got SIGINT');
    exit(0);
  });

  ProcessSignal.SIGTERM.watch().listen((sig) {
    print('Got SIGTERM');
    exit(0);
  });


  ServerSocket.bind(InternetAddress.ANY_IP_V4, 8080).then((socket) {
    print('Creating $count listener(s).');

    for (var i = 1; i < count; i++) {
      Isolate.spawn(_isolateStart, [socket.reference, i]);
    }

    _startServer(socket, 0);
  });
}

void _isolateStart(List args) {
  var ref = args[0] as ServerSocketReference;
  var isolate = args[1] as int;

  ref.create().then((socket) => _startServer(socket, isolate));
}

void _startServer(ServerSocket socket, int isolate) {
  var server = new HttpServer.listenOn(socket);

  var isolateHeaderMiddleware = createMiddleware(
      responseHandler: (Response response) {
    return response.change(headers: {'X-Dart-Isolate-ID': isolate.toString()});
  });

  var handler = const Pipeline().addMiddleware(isolateHeaderMiddleware)
      .addHandler(createStaticHandler('web',
          defaultDocument: 'index.html', serveFilesOutsidePath: true));

  io.serveRequests(server, handler);
}
