import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/birthday_card.dart';
import '../components/view_title.dart';
import '../utilities/constants.dart';
import 'home_page.dart';

class AddBirthdayPage extends StatefulWidget {
  const AddBirthdayPage({Key? key}) : super(key: key);

  @override
  State<AddBirthdayPage> createState() => _AddBirthdayPageState();
}

class _AddBirthdayPageState extends State<AddBirthdayPage> {
  DateTime birthday = DateTime.now();
  TimeOfDay time = const TimeOfDay(hour: 0, minute: 0);
  String name = 'Name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const ViewTitle('Choose a name:'),
            inputNameField(),
            const SizedBox(height: 40),
            const ViewTitle('Choose a date:'),
            datePicker(context),
            const SizedBox(height: 40),
            const ViewTitle('Choose a time:'),
            timePicker(context),
            infoText(
              "Note that you can leave this as default if you don't know the exact time",
            ),
            const SizedBox(height: 40),
            const ViewTitle('Preview:'),
            cardPreview(),
            const SizedBox(height: 40),
            saveButton(context),
            const SizedBox(height: 10),
            infoText(
              'Note that all properties can be changed later, by tapping on a birthday card on the Home screen.',
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Text(
        'Add Birthday',
        style: TextStyle(
          color: Constants.bluePrimary,
          fontSize: Constants.titleFontSizeSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container inputNameField() {
    return Container(
      decoration: const BoxDecoration(
        color: Constants.greySecondary,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      margin: const EdgeInsets.all(20),
      child: TextFormField(
        style: const TextStyle(color: Constants.whiteSecondary),
        inputFormatters: [
          LengthLimitingTextInputFormatter(15),
        ],
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Constants.bluePrimary),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          fillColor: Constants.bluePrimary,
          focusColor: Constants.bluePrimary,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide.none),
          floatingLabelStyle: TextStyle(
              color: Constants.bluePrimary,
              fontSize: Constants.biggerFontSize,
              fontWeight: FontWeight.bold),
          hintText: 'Whats the name of the person?',
          hintStyle: TextStyle(
            color: Constants.lighterGrey,
            fontSize: 15,
          ),
          labelText: ' Name *',
          labelStyle: TextStyle(
            color: Constants.whiteSecondary,
            fontSize: Constants.normalFontSize,
          ),
        ),
        onChanged: (String? value) {
          setState(() {
            name = value.toString();
          });
        },
        validator: (String? value) {
          return (value != null && value.length > 12)
              ? 'The max name length is 13 characters!'
              : null;
        },
      ),
    );
  }

  Container datePicker(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.date_range_rounded),
            const SizedBox(width: 10),
            Text(
              '${birthday.day}.${birthday.month}.${birthday.year}',
              style: const TextStyle(fontSize: Constants.normalFontSize),
            ),
          ],
        ),
        onPressed: () {
          _selectDate(context);
        },
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: birthday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selected != null && selected != birthday) {
      setState(() {
        birthday = selected;
      });
    }
  }

  Container timePicker(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined),
            const SizedBox(width: 10),
            Text(
              time.format(context),
              style: const TextStyle(fontSize: Constants.normalFontSize),
            ),
          ],
        ),
        onPressed: () {
          _selectTime(context);
        },
      ),
    );
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: time,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != time) {
      setState(() {
        time = timeOfDay;
      });
    }
  }

  Container cardPreview() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: BirthdayCard(getHighestID() + 1, name, birthday),
    );
  }

  Container saveButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      child: ElevatedButton(
        child: const Text(
          'Save',
          style: TextStyle(
              color: Constants.whiteSecondary,
              fontSize: Constants.normalFontSize,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pop(context);
          DateTime birthdayWithTime = DateTime(birthday.year, birthday.month,
              birthday.day, time.hour, time.minute);
          birthDayList.add([getHighestID() + 1, name, birthdayWithTime]);
        },
      ),
    );
  }

  Row infoText(String text) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 30, right: 30),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Constants.darkerGrey,
                  fontSize: Constants.normalFontSize,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

int getHighestID() {
  int id = birthDayList[0][0] as int;
  for (int i = 0; i < birthDayList.length; i++) {
    if (birthDayList[i][0] as int > id) {
      id = birthDayList[i][0] as int;
    }
  }
  return id;
}
