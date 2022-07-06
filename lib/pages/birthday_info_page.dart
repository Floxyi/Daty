import 'package:flutter/material.dart';
import '../pages/birthday_edit_page.dart';
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
            const SizedBox(height: 50),
            Text(
              '${Calculator.getDayName(widget.birthday.weekday)}, ${widget.birthday.day}. ${Calculator.getMonthName(widget.birthday.month)} ${widget.birthday.year}',
              style: const TextStyle(
                color: Constants.whiteSecondary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'will soon be ${Calculator.calculateAge(widget.birthday) + 1} years old',
              style: const TextStyle(
                color: Constants.whiteSecondary,
                fontSize: 15,
              ),
            ),
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
      title: const Text(
        'Birthday Info',
        style: TextStyle(
          color: Constants.bluePrimary,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  GestureDetector editButton(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: const [
          Text(
            'Edit',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(width: 5),
          Icon(Icons.edit),
        ],
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
