import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/size_config.dart';
import 'package:todo_app/ui/theme.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? contorller;
  final Widget? widget;
  const InputField({
    required this.title,
    required this.hint,
    this.contorller,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Themes().titleStyle,
            ),
            Container(
              padding: EdgeInsets.only(left: 14),
              margin: EdgeInsets.only(top: 8),
              width: SizeConfig.screenWidth,
              height: 52,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: primaryClr,
                  border: Border.all(
                    color: Colors.grey,
                  )),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    controller: contorller,
                    style: Themes().subTileStyle,
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: Themes().subTileStyle,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 0, color: white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 0, color: white)),
                    ),
                  )),
                  widget ?? Container()
                ],
              ),
            ),
          ],
        ));
  }
}
