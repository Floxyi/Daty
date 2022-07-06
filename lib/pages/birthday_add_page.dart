import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/birthday_card.dart';
import '../constants.dart';
import 'home_page.dart';

class AddBirthdayPage extends StatefulWidget {
  const AddBirthdayPage({Key? key}) : super(key: key);

  @override
  State<AddBirthdayPage> createState() => _AddBirthdayPageState();
}

class _AddBirthdayPageState extends State<AddBirthdayPage> {
  DateTime birthday = DateTime.now();
  String name = 'Name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          infoBanner('Choose a name:'),
          inputNameField(),
          infoBanner('Choose a date:'),
          datePicker(context),
          const SizedBox(height: 40),
          infoBanner('Preview:'),
          cardPreview(),
          const SizedBox(height: 40),
          saveButton(context),
          const SizedBox(height: 10),
          infoText()
        ],
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
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container infoText() {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: const [
          Flexible(
            child: Text(
              '  * Note that all properties can be canged later, \n \t   by tapping on a birthday card on the Home \n \t   screen.',
              style: TextStyle(color: Constants.darkerGrey, fontSize: 18),
            ),
          )
        ],
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
          Navigator.pop(context);
          birthDayList.add([getHighestID() + 1, name, birthday]);
        },
      ),
    );
  }

  Container cardPreview() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: BirthdayCard(getHighestID() + 1, name, birthday),
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
            name = value.toString();
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
