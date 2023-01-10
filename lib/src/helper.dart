import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

debugGrpc(dynamic e) {
  if (e is GrpcError) {
    debugPrint("CODE ${e.code}");
    debugPrint("CODE NAME ${e.codeName}");
    debugPrint("DETAILS ${e.details}");
    debugPrint("TRAILERS ${e.trailers}");
    debugPrint("MESSAGE ${e.message}");
  } else {
    debugPrint("ERROR $e");
  }
}
