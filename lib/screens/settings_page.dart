import 'package:daty/utilities/constants.dart';
import 'package:daty/utilities/notification_manager.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    isSwitched = notificationEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 50, left: 50, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Recieve Notifications',
                style: TextStyle(
                  color: Constants.whiteSecondary,
                  fontSize: Constants.normalFontSize,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 70,
                height: 55,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    inactiveThumbColor: Constants.lighterGrey,
                    inactiveTrackColor: Constants.darkGreySecondary,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
