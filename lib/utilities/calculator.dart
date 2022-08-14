class Calculator {
  static String getDayName(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'error';
    }
  }

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'error';
    }
  }

  static int calculateAge(DateTime birthday) {
    int diffToBirthday = DateTime.now().difference(birthday).inDays;
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
