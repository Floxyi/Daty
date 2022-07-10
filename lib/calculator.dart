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
        return 'Feburary';
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
        return 'Spetember';
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
    final DateTime now =
        DateTime(birthday.year, DateTime.now().month, DateTime.now().day - 1);

    if (DateTime.now().month == birthday.month &&
        DateTime.now().day == birthday.day) {
      return DateTime.now().year - birthday.year;
    }

    if (now.isBefore(birthday)) {
      return DateTime.now().year - birthday.year - 1;
    } else {
      return DateTime.now().year - birthday.year;
    }
  }

  static int nextBirthday(DateTime birthday) {
    final DateTime now =
        DateTime(birthday.year, DateTime.now().month, DateTime.now().day);

    if (now.isBefore(birthday)) {
      return DateTime.now().year - birthday.year;
    } else if (DateTime.now().month == birthday.month &&
        DateTime.now().day == birthday.day) {
      return DateTime.now().year - birthday.year;
    } else {
      return DateTime.now().year - birthday.year + 1;
    }
  }

  static bool hasBirthday(DateTime birthday) {
    DateTime yearDay = DateTime(DateTime.now().year, birthday.month,
        birthday.day, birthday.hour, birthday.minute);

    if (yearDay.isBefore(DateTime.now()) &&
        birthday.day == DateTime.now().day &&
        birthday.month == DateTime.now().month) {
      return true;
    }
    return false;
  }

  static int daysTillBirthday(DateTime birthday) {
    if (birthday.day == DateTime.now().day &&
        birthday.month == DateTime.now().month) {
      return 0;
    }

    int year = DateTime.now().year;
    if (birthday.isBefore(DateTime.now())) {
      year++;
    }

    DateTime yearDay = DateTime(
        year, birthday.month, birthday.day, birthday.hour, birthday.minute);
    return yearDay.difference(DateTime.now()).inDays % 365;
  }

  static int hoursTillBirthday(DateTime birthday) {
    if (birthday.day == DateTime.now().day &&
        birthday.month == DateTime.now().month) {
      return 0;
    }

    DateTime yearDay = DateTime(DateTime.now().year, birthday.month,
        birthday.day, birthday.hour, birthday.minute);
    return yearDay.difference(DateTime.now()).inHours % 24;
  }

  static int minutesTillBirthday(DateTime birthday) {
    if (birthday.day == DateTime.now().day &&
        birthday.month == DateTime.now().month) {
      return 0;
    }

    DateTime yearDay = DateTime(DateTime.now().year, birthday.month,
        birthday.day, birthday.hour, birthday.minute);
    return yearDay.difference(DateTime.now()).inMinutes % 60;
  }

  static int secondsTillBirthday(DateTime birthday) {
    if (birthday.day == DateTime.now().day &&
        birthday.month == DateTime.now().month) {
      return 0;
    }

    DateTime yearDay = DateTime(DateTime.now().year, birthday.month,
        birthday.day, birthday.hour, birthday.minute);
    return yearDay.difference(DateTime.now()).inSeconds % 60;
  }
}
