import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../screens/birthday_edit_page.dart';
import '../utilities/constants.dart';
import '../utilities/calculator.dart';
import '../utilities/data_storage.dart';

class BirthdayInfoPage extends StatefulWidget {
  final int birthdayId;

  const BirthdayInfoPage(this.birthdayId, {Key? key}) : super(key: key);

  @override
  State<BirthdayInfoPage> createState() => _BirthdayInfoPageState();
}

class _BirthdayInfoPageState extends State<BirthdayInfoPage>
    with WidgetsBindingObserver {
  late Timer timer;
  Duration duration = const Duration(milliseconds: 100);

  late ConfettiController controllerCenter;

  void startTimer() {
    timer = Timer.periodic(
      duration,
      (Timer t) => mounted ? setState(() {}) : timer.cancel(),
    );
  }

  @override
  void initState() {
    super.initState();

    startTimer();
    WidgetsBinding.instance.addObserver(this);

    controllerCenter = ConfettiController(
      duration: const Duration(seconds: 10),
    );

    Calculator.hasBirthdayToday(getDataById(widget.birthdayId).date)
        ? controllerCenter.play()
        : null;
  }

  @override
  void dispose() {
    timer.cancel();
    WidgetsBinding.instance.removeObserver(this);

    controllerCenter.dispose();

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
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ConfettiWidget(
                confettiController: controllerCenter,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ],
              ),
              const SizedBox(height: 30),
              iconWithName(),
              const SizedBox(height: 20),
              preciseAge(),
              const SizedBox(height: 20),
              birthdayInfo(),
              const SizedBox(height: 50),
              birthdayCountdown(),
              const SizedBox(height: 20),
              Text(
                'BID: ${getDataById(widget.birthdayId).birthdayId.toString()} / NID: ${getDataById(widget.birthdayId).notificationId}',
                style: TextStyle(
                  color: Constants.greySecondary,
                  fontSize: Constants.normalFontSize,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      actions: [
        editButton(context),
      ],
      title: const Center(
        child: Text(
          'Birthday Info',
          style: TextStyle(
            color: Constants.bluePrimary,
            fontSize: Constants.titleFontSizeSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  GestureDetector editButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Row(
          children: const [
            Text(
              'Edit',
              style: TextStyle(fontSize: Constants.normalFontSize),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.edit,
              size: 15,
            ),
          ],
        ),
      ),
      onTap: () {
        timer.cancel();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return BirthdayEditPage(widget.birthdayId);
        })).then((value) => startTimer());
      },
    );
  }

  Widget iconWithName() {
    return Column(
      children: [
        const Icon(
          Icons.cake_outlined,
          size: 80,
          color: Constants.whiteSecondary,
        ),
        const SizedBox(height: 10),
        Text(
          getDataById(widget.birthdayId).name,
          style: const TextStyle(
            color: Constants.whiteSecondary,
            fontSize: Constants.titleFontSizeSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Column birthdayInfo() {
    return Column(
      children: [
        Text(
          '${Calculator.getDayName(getDataById(widget.birthdayId).date.weekday)}, ${getDataById(widget.birthdayId).date.day}. ${Calculator.getMonthName(getDataById(widget.birthdayId).date.month)} ${getDataById(widget.birthdayId).date.year}',
          style: const TextStyle(
            color: Constants.whiteSecondary,
            fontSize: Constants.normalFontSize,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Row preciseAge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          Calculator.calculateAge(getDataById(widget.birthdayId).date)
              .toString(),
          style: const TextStyle(
            color: Constants.whiteSecondary,
            fontSize: Constants.titleFontSizeSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          Calculator.calculatePreciseAge(getDataById(widget.birthdayId).date, 8)
              .toString(),
          style: const TextStyle(
            color: Constants.whiteSecondary,
            fontSize: Constants.biggerFontSize,
          ),
        ),
      ],
    );
  }

  Container birthdayCountdown() {
    return Container(
      decoration: const BoxDecoration(
        color: Constants.darkGreySecondary,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 15,
          bottom: 5,
        ),
        child: Column(
          children: [
            const Text(
              'Countdown',
              style: TextStyle(
                color: Constants.whiteSecondary,
                fontSize: Constants.biggerFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            countdown(),
          ],
        ),
      ),
    );
  }

  Row countdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        counter(
          'Days',
          Calculator.daysTillBirthday(getDataById(widget.birthdayId).date),
        ),
        counter(
          'Hours',
          Calculator.hoursTillBirthday(getDataById(widget.birthdayId).date),
        ),
        counter(
          'Minutes',
          Calculator.minutesTillBirthday(getDataById(widget.birthdayId).date),
        ),
        counter(
          'Seconds',
          Calculator.secondsTillBirthday(getDataById(widget.birthdayId).date),
        ),
      ],
    );
  }

  Container counter(String unit, int time) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            time.toString(),
            style: const TextStyle(
              color: Constants.whiteSecondary,
              fontSize: Constants.biggerFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              color: Constants.whiteSecondary,
            ),
          )
        ],
      ),
    );
  }
}
