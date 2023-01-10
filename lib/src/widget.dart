import 'package:flutter/material.dart';
import 'package:grpc_alice/src/log_screen.dart';
import 'package:shake/shake.dart';

class GrpcAlice extends StatefulWidget {
  final bool shakeLog;
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  const GrpcAlice({Key? key, required this.child, this.shakeLog = true, required this.navigatorKey}) : super(key: key);

  @override
  State<GrpcAlice> createState() => _GrpcAliceState();
}

class _GrpcAliceState extends State<GrpcAlice> {
  late ShakeDetector detector;
  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.waitForStart(
      onPhoneShake: () {
        if (widget.shakeLog) {
          widget.navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) {
            return const LogScreen();
          })).then((value) {
            // print("value $value");
          });
        }
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
    // print("LISTENING DETECTOR");
    detector.startListening();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
