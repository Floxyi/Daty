import 'dart:math';
import 'package:daty/components/view_title.dart';
import 'package:flutter/services.dart';

import 'package:confetti/confetti.dart';
import 'package:daty/components/birthday_countdown.dart';
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

class _BirthdayInfoPageState extends State<BirthdayInfoPage> {
  late ConfettiController confetti;

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 10));
    Calculator.hasBirthdayToday(getDataById(widget.birthdayId).date)
        ? confetti.play()
        : null;
  }

  @override
  void dispose() {
    confetti.dispose();
    super.dispose();
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
              confettiSpawner(),
              const SizedBox(height: 30),
              informationDisplay(),
              const SizedBox(height: 40),
              const ViewTitle("Präzises Alter"),
              const SizedBox(height: 20),
              preciseAge(),
              const SizedBox(height: 40),
              const ViewTitle("Countdown"),
              const SizedBox(height: 20),
              BirthdayCountdown(widget.birthdayId),
              const SizedBox(height: 40),
              ViewTitle(AppLocalizations.of(context)!.generateWish),
              wishDisplay(),
              const SizedBox(height: 10),
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
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Container(
            margin: const EdgeInsets.only(right: 15),
            child: const Icon(
              Icons.edit,
              size: 25,
            ),
          ),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return BirthdayEditPage(widget.birthdayId);
            }));
          },
        ),
      ],
    );
  }

  ConfettiWidget confettiSpawner() {
    return ConfettiWidget(
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
    );
  }

  Widget informationDisplay() {
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
        const SizedBox(height: 10),
        Text(
          '$weekday, $day. $month $year - $hour:$minute',
          style: const TextStyle(
            color: Constants.whiteSecondary,
            fontSize: Constants.normalFontSize,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                Calculator.getZodiacSign(
                  getDataById(widget.birthdayId).date,
                  context,
                )[1],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Constants.whiteSecondary,
                  fontSize: 30,
                ),
              ),
            ),
            Text(
              Calculator.getZodiacSign(
                getDataById(widget.birthdayId).date,
                context,
              )[0],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Constants.whiteSecondary,
                fontSize: Constants.normalFontSize,
              ),
            ),
          ],
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

  Widget wishDisplay() {
    String birthdayWish = getWish();

    return Padding(
      padding: const EdgeInsets.only(right: 40, left: 40, top: 20),
      child: Container(
        decoration: const BoxDecoration(
          color: Constants.darkGreySecondary,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    birthdayWish,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Constants.whiteSecondary,
                      fontSize: Constants.normalFontSize,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: birthdayWish),
                        );
                      },
                      child: const Icon(Icons.copy),
                    ),
                    ElevatedButton(
                      onPressed: (() {
                        setState(() {});
                      }),
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getWish() {
    List<String> wishes = [
      AppLocalizations.of(context)!.wish1,
      AppLocalizations.of(context)!.wish2,
      AppLocalizations.of(context)!.wish3,
      AppLocalizations.of(context)!.wish4,
      AppLocalizations.of(context)!.wish5,
    ];

    int number = Random().nextInt(wishes.length);
    String wish = wishes[number];

    String name = getDataById(widget.birthdayId).name;
    wish = wish.replaceAll('/name/', name);

    int age = Calculator.calculateAge(getDataById(widget.birthdayId).date) + 1;
    wish = wish.replaceAll('/age/', age.toString());

    return wish;
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
              fontSize: Constants.smallerFontSize,
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
