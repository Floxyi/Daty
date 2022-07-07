import 'dart:async';

import 'package:flutter/material.dart';
import '../calculator.dart';
import '../constants.dart';

class BirthdayCountdown extends StatefulWidget {
  final DateTime birthday;

  const BirthdayCountdown(this.birthday, {Key? key}) : super(key: key);

  @override
  State<BirthdayCountdown> createState() => _BirthdayCountdownState();
}

class _BirthdayCountdownState extends State<BirthdayCountdown>
    with WidgetsBindingObserver {
  late Timer timer;
  Duration duration = const Duration(milliseconds: 1);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(duration, (Timer t) => setState(() {}));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.paused:
          timer.cancel();
          break;
        case AppLifecycleState.inactive:
          timer.cancel();
          break;
        case AppLifecycleState.resumed:
          timer = Timer.periodic(duration, (Timer t) => setState(() {}));
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 30, left: 30),
      decoration: const BoxDecoration(
        color: Constants.darkGreySecondary,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    Calculator.daysTillBirthday(widget.birthday).toString(),
                    style: const TextStyle(
                      color: Constants.whiteSecondary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Days',
                    style: TextStyle(color: Constants.whiteSecondary),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    Calculator.hoursTillBirthday(widget.birthday).toString(),
                    style: const TextStyle(
                      color: Constants.whiteSecondary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Hours',
                    style: TextStyle(color: Constants.whiteSecondary),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    Calculator.minutesTillBirthday(widget.birthday).toString(),
                    style: const TextStyle(
                      color: Constants.whiteSecondary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Minutes',
                    style: TextStyle(color: Constants.whiteSecondary),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    Calculator.secondsTillBirthday(widget.birthday).toString(),
                    style: const TextStyle(
                      color: Constants.whiteSecondary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Seconds',
                    style: TextStyle(color: Constants.whiteSecondary),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
