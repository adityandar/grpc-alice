import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'db_log_helper.dart';
import 'log_model.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final keyCode = RegExp(r'\[((.*)+)\]');
  bool isLoading = false;
  String isLoadingText = "Loading ...";
  List<LogModel> logs = [];
  List<LogModel> logResponse = [];
  String filter = "";
  @override
  void initState() {
    debugPrint("LOG SCREEN LOADED");
    super.initState();
    _initLog();
  }

  _initLog() async {
    try {
      DBHelper dbHelper = DBHelper();
      final res = await dbHelper.getLogModels();
      logs = res.where((e) => e.type == "REQUEST").map((e) {
        final match = keyCode.firstMatch(e.stack!);
        e.ref = match?.group(1);
        e.stack = e.stack!.replaceAll("${match?.group(0)}", "");
        return e;
      }).toList();
      logResponse = res.where((e) => e.type == "RESPONSE").map((e) {
        final match = keyCode.firstMatch(e.stack!);
        e.ref = match?.group(1);
        e.stack = e.stack!.replaceAll("${match?.group(0)}", "");
        return e;
      }).toList();
      // print(res);
      setState(() {});
    } catch (e) {
      print("ERROR $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onRefresh() async {
    debugPrint("REFRESH PAGE");
  }

  Widget _cardLog(LogModel e) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "#${e.id}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Chip(
              label: Text(
                "${e.type}",
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: e.type == "RESPONSE"
                  ? Colors.green.shade100
                  : Colors.amber.shade300,
            )
          ],
        ),
        Text(
          DateFormat("dd-MMM-yyyy HH:mm:ss").format(e.createdAt!),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        InkWell(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: e.stack ?? ""));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: const Text("Text Copied"),
                action: SnackBarAction(
                  label: "OK",
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: e.stack ?? ""));
                  },
                ),
              ));
            },
            child: Text(e.stack!))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("LOG PAGE"),
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      ...logs.map((e) {
                        final resp = logResponse.where((el) => el.ref == e.ref);
                        return Card(
                            margin: const EdgeInsets.only(bottom: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                _cardLog(e),
                                if (resp.isNotEmpty) const Divider(),
                                if (resp.isNotEmpty) _cardLog(resp.first),
                                const SizedBox(height: 10),
                              ],
                            ));
                      }).toList(),
                      const SizedBox(height: 20),
                    ]),
              ),
            ),
          ),
        ));
  }
}
