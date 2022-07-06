import 'package:flutter/material.dart';
import '../pages/birthday_info_page.dart';
import '../constants.dart';
import '../calculator.dart';

class BirthdayCard extends StatefulWidget {
  final String name;
  final DateTime birthday;
  final int id;

  const BirthdayCard(this.id, this.name, this.birthday, {super.key});

  @override
  State<BirthdayCard> createState() => _BirthdayCardState();
}

class _BirthdayCardState extends State<BirthdayCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return BirthdayInfoPage(widget.id, widget.name, widget.birthday);
        }));
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
          color: Constants.greySecondary,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            birthdayDisplay(),
            const SizedBox(width: 15),
            birthdayInfo(),
            const Spacer(),
            DateTime.now().month == widget.birthday.month &&
                    DateTime.now().day == widget.birthday.day
                ? partyIcon()
                : dayCounter(),
          ],
        ),
      ),
    );
  }

  Container dayCounter() {
    return Container(
      decoration: const BoxDecoration(
        color: Constants.bluePrimary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Constants.bluePrimary,
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      width: 60,
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Calculator.daysTillBirthday(widget.birthday).toString(),
            style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Constants.whiteSecondary),
          ),
          const Text(
            'days',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Constants.whiteSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Container partyIcon() {
    return Container(
      decoration: const BoxDecoration(
        color: Constants.purplePrimary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Constants.purplePrimary,
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      width: 60,
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            '🎉',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Constants.blackPrimary,
                  offset: Offset(0.3, 0.2),
                  blurRadius: 15.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column birthdayInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.name}:',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Constants.whiteSecondary,
          ),
        ),
        Text(
          '${Calculator.getDayName(widget.birthday.weekday)}, ${widget.birthday.day}. ${Calculator.getMonthName(widget.birthday.month)}',
          style: const TextStyle(
            fontSize: 13,
            color: Constants.whiteSecondary,
          ),
        ),
      ],
    );
  }

  Column birthdayDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.cake_outlined,
          size: 30,
          color: Constants.whiteSecondary,
        ),
        Text(
          '${Calculator.nextBirthday(widget.birthday)}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Constants.whiteSecondary,
          ),
        ),
      ],
    );
  }
}

// TODO: update day counter
// TODO: ability to send notifications
