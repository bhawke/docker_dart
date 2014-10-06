import 'dart:io';
import 'dart:async';
import 'package:redstone/server.dart' as app;
import 'package:mongo_dart/mongo_dart.dart';


@app.Group("/users")
class Posts {
  @app.Route("/list")
  list() => getAll().then((users) => users);
}

Future<List> getAll() {
  var c = new Completer();
  var dbHost = Platform.environment['MONGO_PORT_27017_TCP_ADDR'];
  print("dbHost: $dbHost");
  var dbPort = Platform.environment['MONGO_PORT_27017_TCP_PORT'];
  print("dbPort: $dbPort");
  var dbEnv = "mongodb://$dbHost:$dbPort/test";
  print("dbEnv: $dbEnv");
  var mongodb_uri = dbHost == null ? "mongodb://localhost/test" : dbEnv;
  print("mongodb_uri: $mongodb_uri");
  Db db = new Db(mongodb_uri);

  db.open().then((_) {
    DbCollection coll = db.collection("users");
    coll.find().toList().then((data) {
      db.close().then((_) {
        print("data = $data");
        c.complete(data);
      });
    }).catchError((e) {
      stderr.write(e);
      c.complete(new List());
    });
  }).catchError((e) {
    stderr.write(e);
    c.complete(new List());
  });

  return c.future;
}


@app.Route("/")
helloWorld() => "Hello, World!";

main() {
  app.setupConsoleLog();
  app.start();
}