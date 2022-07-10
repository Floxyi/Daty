import 'package:flutter/material.dart';
import '../pages/birthday_edit_page.dart';
import '../constants.dart';
import '../calculator.dart';
import '../widgets/birthday_countdown.dart';
import '../widgets/view_title.dart';

class BirthdayInfoPage extends StatefulWidget {
  final int id;
  final String name;
  final DateTime birthday;

  const BirthdayInfoPage(this.id, this.name, this.birthday, {Key? key})
      : super(key: key);

  @override
  State<BirthdayInfoPage> createState() => _BirthdayInfoPageState();
}

class _BirthdayInfoPageState extends State<BirthdayInfoPage> {
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
            const SizedBox(height: 50),
            birthdayInfo(),
            const SizedBox(height: 50),
            BirthdayCountdown(widget.birthday),
          ],
        ),
      ),
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
          '${widget.name} (${Calculator.calculateAge(widget.birthday)})',
          style: const TextStyle(
              color: Constants.whiteSecondary,
              fontSize: 25,
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
        Text(
          '(will soon be ${Calculator.calculateAge(widget.birthday) + 1} years old)',
          style: const TextStyle(
            color: Constants.whiteSecondary,
            fontSize: 15,
          ),
        ),
      ],
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
}
