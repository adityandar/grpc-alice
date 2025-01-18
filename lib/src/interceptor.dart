import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:logger/logger.dart';

import 'db_log_helper.dart';
import 'helper.dart';
import 'log_model.dart';

class MyInterceptor implements ClientInterceptor {
  final bool useInProd;
  final bool isActive;
  final Function(GrpcError)? isError;
  MyInterceptor({
    this.useInProd = false,
    this.isActive = true,
    this.isError,
  });

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request,
      CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
    var logger = Logger(
      filter: useInProd ? ProductionFilter() : null,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 0,
        colors: false,
        printEmojis: false,
        printTime: false,
      ),
      output: ConsoleOutput(false),
    );
    var loggerResp = Logger(
      filter: useInProd ? ProductionFilter() : null,
      printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 8,
          lineLength: 0,
          colors: false,
          printEmojis: false,
          printTime: false),
      output: ConsoleOutput(true),
    );
    String key = getRandomString(5);

    if (isActive) {
      logger.d(
        '[$key] \n'
        'Grpc request. \n'
        'method: ${method.path}, \n'
        'request: $request',
      );
    }

    final response = invoker(method, request, options)
      ..catchError((e) async {
        debugPrint('handle errors here $e');
        if (e is GrpcError) {
          debugGrpc(e);
          if (isError != null) isError!(e);
        }
      });
    if (isActive) {
      response.then((p0) => {
            loggerResp.d(
              '[$key] \n'
              'Grpc response. \n'
              'method: ${method.path}, \n'
              'response: $p0',
            )
          });
    }

    return response;
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
      ClientMethod<Q, R> method,
      Stream<Q> requests,
      CallOptions options,
      ClientStreamingInvoker<Q, R> invoker) {
    return invoker(method, requests, options);
  }
}

class ConsoleOutput extends LogOutput {
  final bool isResponse;

  ConsoleOutput(this.isResponse);
  @override
  void output(OutputEvent event) async {
    try {
      List<String> _log = [];
      for (var line in event.lines) {
        if (kDebugMode) {
          // print(line.replaceAll("│ ", "").replaceAll("└", "").replaceAll("┌", ""));
        }
        _log.add(line
            .replaceAll("│ ", "")
            .replaceAll("└", "")
            .replaceAll("┌", "")
            .replaceAll("├", ""));
      }
      var dbHelper = DBHelper();
      await dbHelper.saveLogModel(LogModel(
          stack: _log.join("\n"),
          createdAt: DateTime.now(),
          type: isResponse ? "RESPONSE" : "REQUEST"));
    } catch (e) {
      print("ERROR OUTPUT $e");
    }
  }
}
