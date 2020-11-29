import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DroneCommand {
  final Uri url;

  DroneCommand(this.url);

  void sendCommand(String cmd) async{
    Response r = await post(this.url, body: cmd);
    debugPrint(r.body);
  }
}
