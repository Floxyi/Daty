import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/utilities/calculator.dart';
import '../utilities/constants.dart';

void initializeNotificationSystem() {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'scheduled_channel_group',
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Constants.bluePrimary,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      )
    ],
  );
}

Future<void> createBirthdayReminderNotification(
  DateTime birthday,
  String personName,
) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title: "It's birtday time! ${Emojis.smile_partying_face}",
      body: personName +
          " just turned " +
          Calculator.calculateAge(birthday).toString() +
          "!",
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      ),
    ],
    schedule: NotificationCalendar(
      month: birthday.month,
      day: birthday.day,
      hour: birthday.hour,
      minute: birthday.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
      allowWhileIdle: true,
      preciseAlarm: true,
    ),
  );
  print("added birthday");
}

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}
