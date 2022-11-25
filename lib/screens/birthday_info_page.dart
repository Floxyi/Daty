import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:daty/screens/birthday_edit_page.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/calculator.dart';
import 'package:daty/utilities/constants.dart';
import 'package:daty/utilities/notification_manager.dart';
import 'package:flutter/material.dart';

class BirthdayInfoPage extends StatefulWidget {
  final int birthdayId;

  const BirthdayInfoPage(this.birthdayId, {Key? key}) : super(key: key);

  @override
  State<BirthdayInfoPage> createState() => _BirthdayInfoPageState();
}

class _BirthdayInfoPageState extends State<BirthdayInfoPage>
    with WidgetsBindingObserver {
  late ConfettiController confetti;
  late Timer timer;
  Duration duration = const Duration(milliseconds: 100);

  void startTimer() {
    timer = Timer.periodic(
      duration,
      (Timer t) => mounted ? setState(() {}) : timer.cancel(),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    startTimer();

    confetti = ConfettiController(duration: const Duration(seconds: 10));
    Calculator.hasBirthdayToday(getDataById(widget.birthdayId).date)
        ? confetti.play()
        : null;
  }

  @override
  void dispose() {
    timer.cancel();
    confetti.dispose();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
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
                confettiController: confetti,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ],
                emissionFrequency: 0.05,
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
              allowNotificationSwitch(),
              const SizedBox(height: 20),
              //debugInfo()
            ],
          ),
        ),
      ),
    );
  }

  Padding allowNotificationSwitch() {
    return Padding(
      padding: const EdgeInsets.only(right: 35.0, left: 35.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Allow Notifications',
            style: TextStyle(
              color: Constants.whiteSecondary,
              fontSize: Constants.normalFontSize,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 70,
            height: 55,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                value: getDataById(widget.birthdayId).allowNotifications,
                onChanged: (value) {
                  setState(() {
                    Birthday birthday = getDataById(widget.birthdayId);
                    birthday.setAllowNotifications = value;
                  });
                },
                inactiveThumbColor: Constants.lighterGrey,
                inactiveTrackColor: Constants.darkGreySecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding debugInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        'AN: ${getDataById(widget.birthdayId).allowNotifications} BID: ${getDataById(widget.birthdayId).birthdayId} / NID: ${getDataById(widget.birthdayId).notificationIds} / week: ${notiOneWeekBefore} month: ${notiOneMonthBefore}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Constants.greySecondary,
          fontSize: Constants.normalFontSize,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Constants.blackPrimary,
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
      behavior: HitTestBehavior.translucent,
      child: Center(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Row(
            children: const [
              Text(
                'Edit',
                textAlign: TextAlign.center,
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
