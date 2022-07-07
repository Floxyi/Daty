import 'package:flutter/material.dart';
import '../constants.dart';

class ViewTitle extends StatelessWidget {
  const ViewTitle(String title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      color: Constants.darkGreySecondary,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            ' $this.title',
            style: const TextStyle(color: Constants.lighterGrey, fontSize: 18),
          )
        ],
      ),
    );
  }
}
