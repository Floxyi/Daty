import 'package:daty/utilities/constants.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(),
      body: body(),
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Constants.blackPrimary,
      title: const Text(
        'About',
        style: TextStyle(
          color: Constants.bluePrimary,
          fontSize: Constants.titleFontSizeSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: backButton(context),
    );
  }

  GestureDetector backButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        child: const Icon(
          Icons.arrow_back,
          size: 30,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget body() {
    return Center(
      child: Column(
        children: [
          infoText(),
        ],
      ),
    );
  }

  Widget infoText() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'This App was made with love ❤️',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Constants.normalFontSize,
              color: Constants.lighterGrey,
            ),
          ),
          Text(
            '~Floxyi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Constants.normalFontSize,
              color: Constants.lighterGrey,
            ),
          ),
        ],
      ),
    );
  }
}
