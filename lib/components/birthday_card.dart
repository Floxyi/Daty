import 'package:daty/screens/birthday_info_page.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/calculator.dart';
import 'package:daty/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BirthdayCard extends StatefulWidget {
  final Birthday birthday;
  final bool canTap;

  const BirthdayCard(this.birthday, this.canTap, {super.key});

  @override
  State<BirthdayCard> createState() => _BirthdayCardState();
}

class _BirthdayCardState extends State<BirthdayCard> {
  late Birthday birthdayData;

  @override
  void initState() {
    birthdayData = widget.birthday;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.canTap) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return BirthdayInfoPage(birthdayData.birthdayId);
              },
            ),
          );

          mounted
              ? setState(() {
                  birthdayData = getDataById(birthdayData.birthdayId);
                })
              : null;
        }
      },
      child: Container(
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
            Calculator.hasBirthdayToday(birthdayData.date)
                ? partyIcon()
                : dayCounter(),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              child: widget.canTap
                  ? const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Constants.whiteSecondary,
                      size: 20,
                    )
                  : null,
            ),
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
            Calculator.remainingDaysTillBirthday(birthdayData.date).toString(),
            style: const TextStyle(
                fontSize: Constants.normalFontSize,
                fontWeight: FontWeight.bold,
                color: Constants.whiteSecondary),
          ),
          Text(
            AppLocalizations.of(context)!.days,
            style: const TextStyle(
              fontSize: Constants.smallerFontSize,
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
              fontSize: Constants.titleFontSizeSize,
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
          birthdayData.name,
          style: const TextStyle(
            fontSize: Constants.biggerFontSize,
            fontWeight: FontWeight.bold,
            color: Constants.whiteSecondary,
          ),
        ),
        Text(
          '${Calculator.getDayName(birthdayData.date.weekday, context)}, ${birthdayData.date.day}. ${Calculator.getMonthName(birthdayData.date.month, context)}',
          style: const TextStyle(
            fontSize: Constants.smallerFontSize,
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
          Calculator.hasBirthdayToday(birthdayData.date)
              ? '${Calculator.calculateAge(birthdayData.date)}'
              : '${Calculator.calculateAge(birthdayData.date) + 1}',
          style: const TextStyle(
            fontSize: Constants.biggerFontSize,
            fontWeight: FontWeight.bold,
            color: Constants.whiteSecondary,
          ),
        ),
      ],
    );
  }
}
