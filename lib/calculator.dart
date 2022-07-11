import 'dart:math';

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

  static String calculatePreciseAge(DateTime birthday, places) {
    DateTime nextBirthday = DateTime(
      birthday.year + 1,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );

    int diff = DateTime.now().difference(nextBirthday).inMilliseconds;
    double preciseAge = diff / (365.25 * 24 * 60 * 60 * 1000) + 1;
    preciseAge = roundDouble(preciseAge, places);

    String ageString = preciseAge.toString();
    ageString = ageString.substring(preciseAge.round().toString().length);

    if (ageString.length != places + 1) {
      for (int i = ageString.toString().length; i < places + 1; i++) {
        ageString = "${ageString}0";
      }
    }

    return ageString;
  }

  static double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
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
    if (birthday.day == DateTime.now().day &&
        birthday.month == DateTime.now().month) {
      return true;
    }
    return false;
  }

  static int daysTillBirthday(DateTime birthday) {
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
    return yearDay.difference(DateTime.now()).inDays % 365;
  }

  static int hoursTillBirthday(DateTime birthday) {
    DateTime yearDay = DateTime(
      DateTime.now().year,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );
    return yearDay.difference(DateTime.now()).inHours % 24;
  }

  static int minutesTillBirthday(DateTime birthday) {
    DateTime yearDay = DateTime(
      DateTime.now().year,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );
    return yearDay.difference(DateTime.now()).inMinutes % 60;
  }

  static int secondsTillBirthday(DateTime birthday) {
    DateTime yearDay = DateTime(
      DateTime.now().year,
      birthday.month,
      birthday.day,
      birthday.hour,
      birthday.minute,
    );
    return yearDay.difference(DateTime.now()).inSeconds % 60;
  }
}
