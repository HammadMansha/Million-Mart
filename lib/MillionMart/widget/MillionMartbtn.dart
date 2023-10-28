import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';

class AppBtn extends StatelessWidget {
  final String title;

  final VoidCallback onBtnSelected;

  const AppBtn({Key? key, required this.title, required this.onBtnSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Container(
          height: 40,
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [btnGradientColor0, btnGradientColor0],
                stops: [0, 1]),
            borderRadius: new BorderRadius.all(const Radius.circular(50.0)),
          ),
          child: Text(title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: white, fontWeight: FontWeight.normal))
          // : new CircularProgressIndicator(
          //     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          //   ),
          ),
      onPressed: () {

        onBtnSelected();
      },
    );
  }
}
