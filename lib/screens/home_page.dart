import 'package:flutter/material.dart';
import '../components/birthday_card.dart';
import 'birthday_add_page.dart';
import '../utilities/constants.dart';
import '../utilities/calculator.dart';

final birthDayList = [
  [1, 'Florian', DateTime(2005, 6, 15, 23, 4)],
  [2, 'Liam', DateTime(2004, 7, 27)],
  [3, 'Jannes', DateTime(2004, 12, 9)],
  [4, 'Max', DateTime(2005, 2, 24)],
  [5, 'Colin', DateTime(2004, 11, 11)],
  [6, 'Vincent', DateTime(2004, 3, 14)],
  [7, 'Riley', DateTime(2000, 6, 13)],
  [8, 'Riley', DateTime(2000, 6, 13)],
  [9, 'Riley', DateTime(2000, 6, 13)],
  [
    10,
    'Peter',
    DateTime(
      2005,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute + 1,
    )
  ],
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var lastDeleted = ['', DateTime.now()];

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
      child: ListView.builder(
        itemCount: birthDayList.length,
        itemBuilder: (context, index) {
          birthDayList.sort(((a, b) =>
              Calculator.remainingDaysTillBirthday(a[2] as DateTime).compareTo(
                  Calculator.remainingDaysTillBirthday(b[2] as DateTime))));
          final item = birthDayList[index];

          return Column(
            children: [
              Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(item[0].toString()),
                background: dismissibleBackground(),
                onDismissed: (direction) {
                  setState(() {
                    lastDeleted = birthDayList.elementAt(index);
                    birthDayList.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    dismissibleSnackBar(item, context),
                  );
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    child: makeBirthdayCard(index)),
              ),
            ],
          );
        },
      ),
    );
  }

  Container dismissibleBackground() {
    return Container(
      margin: const EdgeInsets.all(13),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.red,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Row(
              children: const [
                Icon(
                  Icons.delete_sweep_outlined,
                  color: Constants.whiteSecondary,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Constants.whiteSecondary,
                    fontSize: Constants.normalFontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SnackBar dismissibleSnackBar(List<Object> item, BuildContext context) {
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
              Text('Birthday of ${item[1]} removed!'),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Constants.darkGreySecondary),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  setState(() {
                    birthDayList.add(lastDeleted);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Birthday restored!'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ));
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

  BirthdayCard makeBirthdayCard(int index) {
    return BirthdayCard(birthDayList[index][0] as int,
        birthDayList[index][1].toString(), birthDayList[index][2] as DateTime);
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
