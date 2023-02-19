import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/calculator.dart';
import 'package:daty/utilities/constants.dart';
import 'package:flutter/material.dart';

class BirthdayCardInfo extends StatefulWidget {
  final Birthday birthday;

  const BirthdayCardInfo(this.birthday, {Key? key}) : super(key: key);

  @override
  State<BirthdayCardInfo> createState() => _BirthdayCardInfoState();
}

class _BirthdayCardInfoState extends State<BirthdayCardInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        nameText(),
        infoText(),
      ],
    );
  }

  Text infoText() {
    return Text(
      getDateText(),
      style: const TextStyle(
        fontSize: Constants.smallerFontSize,
        color: Constants.whiteSecondary,
      ),
    );
  }

  Text nameText() {
    return Text(
      getNameText(),
      style: const TextStyle(
        fontSize: Constants.biggerFontSize,
        fontWeight: FontWeight.bold,
        color: Constants.whiteSecondary,
      ),
    );
  }

  String getNameText() {
    String name = widget.birthday.name;
    String zodiac = Calculator.getZodiacSign(widget.birthday.date, context)[0];
    return name + zodiac;
  }

  String getDateText() {
    String day = Calculator.getDayName(widget.birthday.date.weekday, context);
    String month = Calculator.getMonthName(widget.birthday.date.month, context);
    return '$day, ${widget.birthday.date.day}. $month';
  }
}
