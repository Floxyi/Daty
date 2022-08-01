import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/birthday_card.dart';
import '../components/view_title.dart';
import '../utilities/constants.dart';
import 'home_page.dart';

class BirthdayEditPage extends StatefulWidget {
  final int id;
  final String name;
  final DateTime birthday;

  const BirthdayEditPage(this.id, this.name, this.birthday, {Key? key})
      : super(key: key);

  @override
  State<BirthdayEditPage> createState() => _BirthdayEditPageState();
}

class _BirthdayEditPageState extends State<BirthdayEditPage> {
  int id = 0;
  String newName = '';
  DateTime newDate = DateTime.now();
  TimeOfDay newTime = const TimeOfDay(hour: 0, minute: 0);

  @override
  void initState() {
    id = widget.id;
    newName = widget.name;
    newDate = widget.birthday;
    newTime = TimeOfDay(hour: newDate.hour, minute: newDate.minute);
    super.initState();
  }

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
            const ViewTitle('Choose a new name:'),
            inputNameField(),
            const SizedBox(height: 40),
            const ViewTitle('Choose a new date:'),
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
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Text(
        "Edit Birthday",
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
        initialValue: newName,
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
              fontSize: 20,
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
            newName = value.toString();
          });
        },
        validator: (String? value) {
          return (value != null && value.length > 12)
              ? 'The max name lenght is 13 characters!'
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
              '${newDate.day}.${newDate.month}.${newDate.year}',
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
      initialDate: newDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selected != null && selected != newDate) {
      setState(() {
        newDate = selected;
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
              newTime.format(context),
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
      initialTime: newTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != newTime) {
      setState(() {
        newTime = timeOfDay;
      });
    }
  }

  Container cardPreview() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: BirthdayCard(getHighestID() + 1, newName, newDate),
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
          Navigator.pushReplacementNamed(context, '/');
          birthDayList.removeAt(birthDayList.indexWhere(
            (birthdayData) => birthdayData[0] == id,
          ));
          newDate = DateTime(
            newDate.year,
            newDate.month,
            newDate.day,
            newTime.hour,
            newTime.minute,
          );
          birthDayList.add([id, newName, newDate]);
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
