import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:daty/screens/birthday_edit_page.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/calculator.dart';
import 'package:daty/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              const SizedBox(height: 10),
              birthdayInfo(),
              preciseAge(),
              const SizedBox(height: 30),
              zodiacSign(),
              const SizedBox(height: 40),
              birthdayCountdown(),
              allowNotificationSwitch(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Constants.blackPrimary,
      title: Center(
        child: Text(
          AppLocalizations.of(context)!.birthdayInfo,
          style: const TextStyle(
            color: Constants.bluePrimary,
            fontSize: Constants.titleFontSizeSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        editButton(context),
      ],
    );
  }

  GestureDetector editButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: const Icon(
          Icons.edit,
          size: 25,
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
    int weekdayNumber = getDataById(widget.birthdayId).date.weekday;
    String weekday = Calculator.getDayName(weekdayNumber, context);

    int day = getDataById(widget.birthdayId).date.day;

    int monthNumber = getDataById(widget.birthdayId).date.month;
    String month = Calculator.getMonthName(monthNumber, context);

    int year = getDataById(widget.birthdayId).date.year;

    int hourNumber = getDataById(widget.birthdayId).date.hour;
    int minuteNumber = getDataById(widget.birthdayId).date.minute;

    String hour = hourNumber < 10 ? '0$hourNumber' : '$hourNumber';
    String minute = minuteNumber < 10 ? '0$minuteNumber' : '$minuteNumber';

    return Column(
      children: [
        Text(
          '$weekday, $day. $month $year - $hour:$minute\n ',
          style: const TextStyle(
            color: Constants.whiteSecondary,
            fontSize: Constants.normalFontSize,
          ),
        ),
      ],
    );
  }

  Widget zodiacSign() {
    return Padding(
      padding: const EdgeInsets.only(right: 110, left: 110),
      child: Container(
        decoration: const BoxDecoration(
          color: Constants.darkGreySecondary,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 10, bottom: 10),
              child: Text(
                Calculator.getZodiacSign(
                  getDataById(widget.birthdayId).date,
                  context,
                )[1],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Constants.whiteSecondary,
                  fontSize: 40,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  Calculator.getZodiacSign(
                    getDataById(widget.birthdayId).date,
                    context,
                  )[0],
                  //'test',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Constants.whiteSecondary,
                    fontSize: Constants.normalFontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
            Text(
              AppLocalizations.of(context)!.countdown,
              style: const TextStyle(
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
          AppLocalizations.of(context)!.days,
          Calculator.daysTillBirthday(getDataById(widget.birthdayId).date),
        ),
        counter(
          AppLocalizations.of(context)!.hours,
          Calculator.hoursTillBirthday(getDataById(widget.birthdayId).date),
        ),
        counter(
          AppLocalizations.of(context)!.minutes,
          Calculator.minutesTillBirthday(getDataById(widget.birthdayId).date),
        ),
        counter(
          AppLocalizations.of(context)!.seconds,
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

  Padding allowNotificationSwitch() {
    return Padding(
      padding: const EdgeInsets.only(right: 35.0, left: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.allowNotification,
            style: const TextStyle(
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
}
