import 'package:daty/components/birthday_card.dart';
import 'package:daty/components/view_title.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BirthdayEditPage extends StatefulWidget {
  final int birthdayId;

  const BirthdayEditPage(this.birthdayId, {Key? key}) : super(key: key);

  @override
  State<BirthdayEditPage> createState() => _BirthdayEditPageState();
}

class _BirthdayEditPageState extends State<BirthdayEditPage> {
  late String newName;
  late DateTime newDate;
  late TimeOfDay newTime;

  final ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();
  bool isInputCorrect = true;

  @override
  void initState() {
    newName = getDataById(widget.birthdayId).name;
    newDate = getDataById(widget.birthdayId).date;
    newTime = TimeOfDay(hour: newDate.hour, minute: newDate.minute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(),
      body: RawScrollbar(
        thumbColor: Constants.lighterGrey,
        radius: Radius.circular(20),
        thickness: 5,
        thumbVisibility: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
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
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Constants.blackPrimary,
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
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: getDataById(widget.birthdayId).name,
          keyboardType: TextInputType.text,
          keyboardAppearance: Brightness.dark,
          style: const TextStyle(color: Constants.whiteSecondary),
          inputFormatters: [
            LengthLimitingTextInputFormatter(12),
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
              borderSide: BorderSide.none,
            ),
            floatingLabelStyle: TextStyle(
              color: Constants.bluePrimary,
              fontSize: Constants.biggerFontSize,
              fontWeight: FontWeight.bold,
            ),
            hintText: 'What is the name of the person?',
            hintStyle: TextStyle(
              color: Constants.lighterGrey,
              fontSize: 15,
            ),
            labelText: 'Name',
            labelStyle: TextStyle(
              color: Constants.whiteSecondary,
              fontSize: Constants.normalFontSize,
            ),
            errorStyle: TextStyle(
              fontSize: Constants.smallerFontSize,
            ),
          ),
          onChanged: (String? value) {
            setState(() {
              newName = value.toString();
              if (_formKey.currentState!.validate()) {
                isInputCorrect = true;
              }
            });
          },
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name.';
            } else {
              value.trim();
              if (value.isEmpty) {
                return 'Please enter a name.';
              }
            }
            return null;
          },
        ),
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Constants.bluePrimary,
              onPrimary: Constants.blackPrimary,
              onSurface: Constants.whiteSecondary,
            ),
            dialogBackgroundColor: Constants.darkGreySecondary,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Constants.whiteSecondary,
              ),
            ),
          ),
          child: child!,
        );
      },
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
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            timePickerTheme: TimePickerThemeData(
              dayPeriodTextColor: Constants.whiteSecondary,
              dayPeriodBorderSide: BorderSide(color: Constants.bluePrimary),
              dialHandColor: Constants.bluePrimary,
              dialTextColor: Constants.whiteSecondary,
              entryModeIconColor: Constants.whiteSecondary,
              hourMinuteTextColor: Constants.whiteSecondary,
              helpTextStyle: TextStyle(color: Constants.whiteSecondary),
              hourMinuteColor: Constants.greySecondary,
              backgroundColor: Constants.darkGreySecondary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (timeOfDay != null && timeOfDay != newTime) {
      setState(() {
        newTime = timeOfDay;
      });
    }
  }

  Container cardPreview() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: BirthdayCard(Birthday(newName, newDate), false),
    );
  }

  Container saveButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isInputCorrect ? Constants.bluePrimary : Colors.red,
        ),
        child: const Text(
          'Save',
          style: TextStyle(
              color: Constants.whiteSecondary,
              fontSize: Constants.normalFontSize,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            newDate = DateTime(
              newDate.year,
              newDate.month,
              newDate.day,
              newTime.hour,
              newTime.minute,
            );
            updateBirthday(widget.birthdayId, Birthday(newName, newDate));
            //Navigator.pushReplacementNamed(context, '/');
            Navigator.pop(context);
          } else {
            setState(() {
              isInputCorrect = false;
            });
          }
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
