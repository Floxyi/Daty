import 'package:flutter/material.dart';
import '../utilities/constants.dart';

class ViewTitle extends StatelessWidget {
  final String title;
  const ViewTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      color: Constants.darkGreySecondary,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            ' $title',
            style: const TextStyle(color: Constants.lighterGrey, fontSize: 18),
          )
        ],
      ),
    );
  }
}
