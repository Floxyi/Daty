import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/notification_manager.dart';
import 'package:flutter/material.dart';
import '../components/birthday_card.dart';
import 'birthday_add_page.dart';
import '../utilities/constants.dart';
import '../utilities/calculator.dart';
import '/utilities/data_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    AwesomeNotifications().isNotificationAllowed().then((value) => value
        ? addNotificationListener(context)
        : requestNotificationAccess(context));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        birthdayListView(),
        addButton(context),
      ],
    );
  }

  Expanded birthdayListView() {
    return Expanded(
      child: RawScrollbar(
        thumbColor: Constants.lighterGrey,
        radius: Radius.circular(20),
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
                  padding: EdgeInsets.all(15.0),
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
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) {
              setState(() {
                removeBirthday(birthdayList.elementAt(index).birthdayId);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                dismissibleSnackBar(item),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_sweep_outlined,
            label: 'Delete',
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 10, left: 10),
        child: BirthdayCard(
          getDataById(index),
          true,
        ),
      ),
    );
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
              Text('Removed birthday of ${birthday.name}!'),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Constants.darkGreySecondary,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  setState(() {
                    if (restoreBirthday()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Restored birthday of ${lastDeleted!.name}!',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
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
                  children: const [
                    Text(
                      'Restore',
                      style: TextStyle(color: Constants.bluePrimary),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.restore, color: Constants.bluePrimary)
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container addButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Constants.darkGreySecondary,
          fixedSize: const Size(60, 60),
          shape: const CircleBorder(),
        ),
        child: const Icon(
          Icons.add_rounded,
          size: Constants.titleFontSizeSize,
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
