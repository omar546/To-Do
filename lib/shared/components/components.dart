import 'package:flutter/material.dart';
import 'package:todo_app/shared/styles/styles.dart';

Widget buildTextField({
  double widthRit = 0.7,
  required BuildContext context,
  required String labelText,
  required TextEditingController controller,
  required IconData prefix,
   bool isClickable = true,
   var onTap,
  var validate,
  required TextInputType type,
  var onSubmit,
  var onChange,
}) {
  return Container(
    width: MediaQuery.of(context).size.width * widthRit,
    height: MediaQuery.of(context).size.height * 0.08,
    decoration: BoxDecoration(
      color: Styles.lightBlackColor,
      border: Border.all(color: Styles.greyColor),
      borderRadius: BorderRadius.circular(25.0),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextFormField(
        enabled: isClickable,
        validator: validate,
        keyboardType: type,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: onTap,
        style: TextStyle(
          color: Styles.greyColor,
        ),
        cursorColor: Styles.gumColor,
        controller: controller,
        // Set the validator function
        decoration: InputDecoration(
          prefixIcon: Icon(prefix, color: Styles.greyColor),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          labelStyle: TextStyle(
            fontSize: 13.0,
            color: Styles.gumColor,
          ),
          labelText: labelText,
          border: InputBorder.none,
        ),
      ),
    ),
  );
}



