import 'package:flutter/material.dart';
import 'package:todo_app/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String lable;
  final Function() OnTap;
  const MyButton({required this.lable, required this.OnTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: OnTap,
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: primaryClr, borderRadius: BorderRadius.circular(10)),
          width: 100,
          height: 45,
          child: Text(
            lable,
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          )),
    );
  }
}
