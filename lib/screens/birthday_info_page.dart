import 'dart:async';

import 'package:flutter/material.dart';
import '../screens/birthday_edit_page.dart';
import '../constants.dart';
import '../calculator.dart';

class BirthdayInfoPage extends StatefulWidget {
  final int id;
  final String name;
  final DateTime birthday;

  const BirthdayInfoPage(this.id, this.name, this.birthday, {Key? key})
      : super(key: key);

  @override
  State<BirthdayInfoPage> createState() => _BirthdayInfoPageState();
}

class _BirthdayInfoPageState extends State<BirthdayInfoPage>
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
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(context),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            iconWithName(),
            const SizedBox(height: 20),
            preciseAge(),
            const SizedBox(height: 20),
            birthdayInfo(),
            const SizedBox(height: 50),
            birthdayCountdown(),
          ],
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
            fontSize: 30,
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
              style: TextStyle(fontSize: 15),
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return BirthdayEditPage(widget.id, widget.name, widget.birthday);
        }));
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
          widget.name,
          style: const TextStyle(
              color: Constants.whiteSecondary,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Column birthdayInfo() {
    return Column(
      children: [
        Text(
          '${Calculator.getDayName(widget.birthday.weekday)}, ${widget.birthday.day}. ${Calculator.getMonthName(widget.birthday.month)} ${widget.birthday.year}',
          style: const TextStyle(
            color: Constants.whiteSecondary,
            fontSize: 15,
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
          Calculator.calculateAge(widget.birthday).toString(),
          style: const TextStyle(
            color: Constants.whiteSecondary,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          Calculator.calculatePreciseAge(widget.birthday, 8).toString(),
          style: const TextStyle(
            color: Constants.whiteSecondary,
            fontSize: 25,
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
            widgetHeadline('Countdown'),
            countdown(),
          ],
        ),
      ),
    );
  }

  Text widgetHeadline(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Constants.whiteSecondary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Row countdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        counter('Days', Calculator.daysTillBirthday(widget.birthday)),
        counter('Hours', Calculator.hoursTillBirthday(widget.birthday)),
        counter('Minutes', Calculator.minutesTillBirthday(widget.birthday)),
        counter('Seconds', Calculator.secondsTillBirthday(widget.birthday)),
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
              fontSize: 25,
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
