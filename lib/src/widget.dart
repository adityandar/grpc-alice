import 'package:flutter/material.dart';

class GrpcAlice extends StatefulWidget {
  final bool shakeLog;
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  const GrpcAlice(
      {Key? key,
      required this.child,
      this.shakeLog = true,
      required this.navigatorKey})
      : super(key: key);

  @override
  State<GrpcAlice> createState() => _GrpcAliceState();
}

class _GrpcAliceState extends State<GrpcAlice> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
