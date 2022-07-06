import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/birthday_card.dart';
import '../constants.dart';
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
  String oldName = '';
  DateTime oldDate = DateTime.now();
  String newName = '';
  DateTime newDate = DateTime.now();

  @override
  void initState() {
    id = widget.id;
    oldName = widget.name;
    oldDate = widget.birthday;
    newName = widget.name;
    newDate = widget.birthday;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          infoBanner('Choose a new name:'),
          inputNameField(),
          const SizedBox(height: 40),
          infoBanner('Choose a new date:'),
          datePicker(context),
          const SizedBox(height: 40),
          infoBanner('Preview:'),
          cardPreview(),
          const SizedBox(height: 40),
          saveButton(context),
        ],
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
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
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
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/');
          birthDayList.removeAt(birthDayList.indexWhere((birthdayData) =>
              birthdayData[0] == id &&
              birthdayData[1] == oldName &&
              birthdayData[2] == oldDate));
          birthDayList.add([id, newName, newDate]);
        },
      ),
    );
  }

  Container cardPreview() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: BirthdayCard(getHighestID() + 1, newName, newDate),
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
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        onPressed: () {
          _selectDate(context);
        },
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
            fontSize: 18,
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

  Container infoBanner(String title) {
    return Container(
      padding: const EdgeInsets.all(3),
      color: Constants.darkGreySecondary,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            ' $title',
            style: const TextStyle(color: Constants.lighterGrey, fontSize: 18),
          )
        ],
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
