import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Calculator {
  static String getDayName(int day, BuildContext context) {
    switch (day) {
      case 1:
        return AppLocalizations.of(context)!.monday;
      case 2:
        return AppLocalizations.of(context)!.tuesday;
      case 3:
        return AppLocalizations.of(context)!.wednesday;
      case 4:
        return AppLocalizations.of(context)!.thursday;
      case 5:
        return AppLocalizations.of(context)!.friday;
      case 6:
        return AppLocalizations.of(context)!.saturday;
      case 7:
        return AppLocalizations.of(context)!.sunday;
      default:
        return 'error';
    }
  }

  static String getMonthName(int month, BuildContext context) {
    switch (month) {
      case 1:
        return AppLocalizations.of(context)!.january;
      case 2:
        return AppLocalizations.of(context)!.february;
      case 3:
        return AppLocalizations.of(context)!.march;
      case 4:
        return AppLocalizations.of(context)!.april;
      case 5:
        return AppLocalizations.of(context)!.may;
      case 6:
        return AppLocalizations.of(context)!.june;
      case 7:
        return AppLocalizations.of(context)!.july;
      case 8:
        return AppLocalizations.of(context)!.august;
      case 9:
        return AppLocalizations.of(context)!.september;
      case 10:
        return AppLocalizations.of(context)!.october;
      case 11:
        return AppLocalizations.of(context)!.november;
      case 12:
        return AppLocalizations.of(context)!.december;
      default:
        return 'error';
    }
  }

  static int calculateAge(DateTime birthday) {
    int diffToBirthday = DateTime.now().difference(birthday).inDays; // + 1d
    int age = 0;

    for (int i = birthday.year; i <= DateTime.now().year; i++) {
      if (isLeapYear(i)) {
        diffToBirthday -= 366;
      } else {
        diffToBirthday -= 365;
      }

      if (diffToBirthday >= 0) {
        age++;
      }
    }

    if (hasBirthdayToday(birthday)) {
      age++;
    }

    return age;
  }

  static bool isLeapYear(int year) {
    if (year % 4 != 0 || (year % 100 == 0 && year % 400 != 0)) {
      return false;
    }
    return true;
  }

  static String calculatePreciseAge(DateTime birthday, places) {
    DateTime now = DateTime.now();

    DateTime lastBirthday = DateTime(
      hadBirthdayThisYear(birthday) ? now.year : now.year - 1,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );
    DateTime nextBirthday = DateTime(
      hadBirthdayThisYear(birthday) ? now.year + 1 : now.year,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );

    int toBirthdayDiff = now.difference(nextBirthday).inMilliseconds;
    int fullBirthdayDiff = lastBirthday.difference(nextBirthday).inMilliseconds;

    double preciseAge = ((1 - toBirthdayDiff) / fullBirthdayDiff) + 1;
    preciseAge += calculateAge(birthday);

    String preciseAgeAsString = preciseAge
        .toStringAsFixed(places)
        .substring(calculateAge(birthday).toString().length);

    return preciseAgeAsString;
  }

  static bool hadBirthdayThisYear(DateTime birthday) {
    DateTime birthdayThisYear = DateTime(
      DateTime.now().year,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );

    if (birthdayThisYear.isAfter(DateTime.now())) {
      return false;
    }
    return true;
  }

  static int remainingDaysTillBirthday(DateTime birthday) {
    if (hasBirthdayToday(birthday)) {
      return 0;
    }

    int year = DateTime.now().year;
    if (birthday.isBefore(DateTime.now())) {
      year++;
    }

    DateTime yearDay = DateTime(
      year,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );
    return (yearDay.difference(DateTime.now()).inDays % 365) + 1;
  }

  static bool hasBirthdayToday(DateTime birthday) {
    if (birthday.day == DateTime.now().day &&
        birthday.month == DateTime.now().month) {
      return true;
    }
    return false;
  }

  static int daysTillBirthday(DateTime birthday) {
    DateTime nextBirthday = DateTime(
      hadBirthdayThisYear(birthday)
          ? DateTime.now().year + 1
          : DateTime.now().year,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );
    return nextBirthday.difference(DateTime.now()).inDays % 365;
  }

  static int hoursTillBirthday(DateTime birthday) {
    DateTime nextBirthday = DateTime(
      hadBirthdayThisYear(birthday)
          ? DateTime.now().year + 1
          : DateTime.now().year,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );
    return nextBirthday.difference(DateTime.now()).inHours % 24;
  }

  static int minutesTillBirthday(DateTime birthday) {
    DateTime nextBirthday = DateTime(
      hadBirthdayThisYear(birthday)
          ? DateTime.now().year + 1
          : DateTime.now().year,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );
    return nextBirthday.difference(DateTime.now()).inMinutes % 60;
  }

  static int secondsTillBirthday(DateTime birthday) {
    DateTime nextBirthday = DateTime(
      hadBirthdayThisYear(birthday)
          ? DateTime.now().year + 1
          : DateTime.now().year,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );
    return (nextBirthday.difference(DateTime.now()).inSeconds + 1) % 60;
  }
}
