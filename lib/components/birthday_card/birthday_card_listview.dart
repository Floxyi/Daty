import 'package:daty/components/birthday_card/birthday_card.dart';
import 'package:daty/utilities/Birthday.dart';
import 'package:daty/utilities/birthday_data.dart';
import 'package:daty/utilities/calculator.dart';
import 'package:daty/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BirthdayCardListview extends StatefulWidget {
  const BirthdayCardListview({Key? key}) : super(key: key);

  @override
  State<BirthdayCardListview> createState() => _BirthdayCardListviewState();
}

class _BirthdayCardListviewState extends State<BirthdayCardListview> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
            return birthdayCardList(index);
          },
        ),
      ),
    );
  }

  Column birthdayCardList(int index) {
    birthdayList.sort(
      (a, b) => Calculator.remainingDaysTillBirthday(a.date).compareTo(
        Calculator.remainingDaysTillBirthday(b.date),
      ),
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15.0),
          child: slidableBirthdayCard(index, birthdayList[index]),
        ),
      ],
    );
  }

  Slidable slidableBirthdayCard(int index, Birthday item) {
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
          slideableAction(index, item),
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

  SlidableAction slideableAction(int index, Birthday item) {
    return SlidableAction(
      onPressed: (context) {
        deleteBirthday(index, context, item);
      },
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      icon: Icons.delete_sweep_outlined,
      label: AppLocalizations.of(context)!.delete,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                  cancelDeletion();
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

  void cancelDeletion() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      if (restoreBirthday()) {
        ScaffoldMessenger.of(context).showSnackBar(cancellationSnackbar());
      }
    });
  }

  SnackBar cancellationSnackbar() {
    return SnackBar(
      content: Text(
        '${AppLocalizations.of(context)!.restoredBirthday} ${lastDeleted!.name}!',
      ),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    );
  }
}
