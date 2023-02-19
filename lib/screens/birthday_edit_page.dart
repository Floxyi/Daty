import 'package:daty/components/birthday_card/birthday_card.dart';
import 'package:daty/components/date_picker.dart';
import 'package:daty/components/time_picker.dart';
import 'package:daty/components/view_title.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool isNameInputCorrect = true;

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
        radius: const Radius.circular(20),
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
                ViewTitle('${AppLocalizations.of(context)!.editName}:'),
                inputNameField(),
                const SizedBox(height: 40),
                ViewTitle('${AppLocalizations.of(context)!.editDate}:'),
                DatePicker(
                  newDate,
                  onDayChanged: (newDayTime) {
                    setState(() {
                      newDate = newDayTime;
                    });
                  },
                ),
                const SizedBox(height: 40),
                ViewTitle('${AppLocalizations.of(context)!.editTime}:'),
                TimePicker(
                  newTime,
                  onTimeChanged: (newDateTime) {
                    setState(() {
                      newTime = newDateTime;
                    });
                  },
                ),
                infoText(AppLocalizations.of(context)!.timeInfo),
                const SizedBox(height: 40),
                ViewTitle('${AppLocalizations.of(context)!.preview}:'),
                cardPreview(),
                const SizedBox(height: 40),
                saveButton(context),
                const SizedBox(height: 40),
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
      title: Text(
        AppLocalizations.of(context)!.birthdayEdit,
        style: const TextStyle(
          color: Constants.bluePrimary,
          fontSize: Constants.titleFontSizeSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: cancelButton(context),
    );
  }

  GestureDetector cancelButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        child: const Icon(
          Icons.close,
          size: 25,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  Container inputNameField() {
    return Container(
      decoration: const BoxDecoration(
        color: Constants.greySecondary,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
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
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Constants.bluePrimary),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            fillColor: Constants.bluePrimary,
            focusColor: Constants.bluePrimary,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide.none,
            ),
            floatingLabelStyle: const TextStyle(
              color: Constants.bluePrimary,
              fontSize: Constants.biggerFontSize,
              fontWeight: FontWeight.bold,
            ),
            hintStyle: const TextStyle(
              color: Constants.lighterGrey,
              fontSize: 15,
            ),
            labelText: AppLocalizations.of(context)!.name,
            labelStyle: const TextStyle(
              color: Constants.whiteSecondary,
              fontSize: Constants.normalFontSize,
            ),
            errorStyle: const TextStyle(
              fontSize: Constants.smallerFontSize,
            ),
          ),
          onChanged: (String? value) {
            setState(() {
              newName = value.toString();
              if (_formKey.currentState!.validate()) {
                isNameInputCorrect = true;
              }
            });
          },
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.nameError;
            } else {
              value.trim();
              if (value.isEmpty) {
                return AppLocalizations.of(context)!.nameError;
              }
            }
            return null;
          },
        ),
      ),
    );
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
          backgroundColor:
              isNameInputCorrect ? Constants.bluePrimary : Colors.red,
        ),
        child: Text(
          AppLocalizations.of(context)!.save,
          style: const TextStyle(
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
              isNameInputCorrect = false;
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
