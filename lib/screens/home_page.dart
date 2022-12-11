import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/components/birthday_card.dart';
import 'package:daty/screens/birthday_add_page.dart';
import 'package:daty/screens/settings_page.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/app_data.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/calculator.dart';
import 'package:daty/utilities/constants.dart';
import 'package:daty/utilities/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((value) async {
      if (value) {
        addNotificationListener();
      } else if (await isFirstStartup()) {
        requestNotificationAccess(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(),
      body: body(),
    );
  }

  Widget body() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 30),
        child: Column(
          children: [
            birthdayList.isNotEmpty ? birthdayListView() : infoText(),
            addButton(context),
          ],
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

  Expanded birthdayListView() {
    return Expanded(
      child: RawScrollbar(
        thumbColor: Constants.lighterGrey,
        radius: const Radius.circular(20),
        thickness: 5,
        thumbVisibility: true,
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: birthdayList.length,
          itemBuilder: (context, index) {
            birthdayList.sort(
              (a, b) => Calculator.remainingDaysTillBirthday(a.date).compareTo(
                Calculator.remainingDaysTillBirthday(b.date),
              ),
            );
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: slidableCard(index, birthdayList[index]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Slidable slidableCard(int index, Birthday item) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            deleteBirthday(index, context, item);
          },
        ),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {
              deleteBirthday(index, context, item);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_sweep_outlined,
            label: AppLocalizations.of(context)!.delete,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: BirthdayCard(
          birthdayList[index],
          true,
        ),
      ),
    );
  }

  void deleteBirthday(int index, BuildContext context, Birthday item) {
    setState(() {
      removeBirthday(birthdayList.elementAt(index).birthdayId);
    });

    ScaffoldMessenger.of(context).showSnackBar(dismissibleSnackBar(item));
  }

  SnackBar dismissibleSnackBar(Birthday birthday) {
    return SnackBar(
      backgroundColor: Constants.greySecondary,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      content: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  '${AppLocalizations.of(context)!.deletedBirthday} ${birthday.name}!'),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.darkGreySecondary,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  setState(() {
                    if (restoreBirthday()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${AppLocalizations.of(context)!.restoredBirthday} ${lastDeleted!.name}!',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      );
                    }
                  });
                },
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.restore,
                      style: const TextStyle(color: Constants.bluePrimary),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.restore, color: Constants.bluePrimary)
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget infoText() {
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

  Container addButton(BuildContext context) {
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
