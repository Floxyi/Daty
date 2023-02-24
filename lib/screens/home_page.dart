import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/components/birthday_card/birthday_card_listview.dart';
import 'package:daty/screens/birthday_add_page.dart';
import 'package:daty/screens/settings_page.dart';
import 'package:daty/utilities/app_data.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/constants.dart';
import 'package:daty/utilities/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then(
      (value) async {
        if (value) {
          addNotificationListener();
        } else if (await isFirstStartup()) {
          // ignore: use_build_context_synchronously
          requestNotificationAccess(context);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 30),
          child: Column(
            children: [
              birthdayList.isNotEmpty
                  ? const BirthdayCardListview()
                  : emptyInfoText(),
              createBirthdayButton(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Constants.blackPrimary,
      title: Text(
        AppLocalizations.of(context)!.birthdays,
        style: const TextStyle(
          color: Constants.bluePrimary,
          fontSize: Constants.titleFontSizeSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        settingsButton(context),
      ],
    );
  }

  GestureDetector settingsButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: const Icon(
          Icons.settings,
          size: 30,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return const SettingsPage();
          },
        ));
      },
    );
  }

  Widget emptyInfoText() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.addBirthday,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: Constants.normalFontSize,
              color: Constants.lighterGrey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: const Icon(
              Icons.keyboard_double_arrow_down_rounded,
              color: Constants.lighterGrey,
            ),
          )
        ],
      ),
    );
  }

  Container createBirthdayButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, bottom: 23.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Constants.whiteSecondary,
          backgroundColor: Constants.darkGreySecondary,
          fixedSize: const Size(70, 70),
          side: const BorderSide(color: Constants.greySecondary, width: 3),
          shape: const StadiumBorder(),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Constants.whiteSecondary,
          size: 35,
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return const AddBirthdayPage();
          })).then(
            (value) => setState(
              () {},
            ),
          );
        },
      ),
    );
  }
}
