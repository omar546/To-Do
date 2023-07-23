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
          color: Styles.greyColor,fontSize: 20
        ),
        cursorColor: Styles.gumColor,
        controller: controller,
        // Set the validator function
        decoration: InputDecoration(
          prefixIcon: Icon(prefix, color: Styles.gumColor),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          labelStyle: TextStyle(
            fontSize: 16.0,
            color: Styles.gumColor,
          ),
          labelText: labelText,
          border: InputBorder.none,
        ),
      ),
    ),
  );
}

Widget buildTaskItem(Map model) => Padding(
  padding: const EdgeInsets.all(10.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(child: Text('${model['time']}',style: TextStyle(fontSize: 14,fontFamily: 'Thunder',color: Styles.greyColor),)),
      ),
      SizedBox(width: 25,),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 200.0),
            decoration: BoxDecoration(
              border: Border.all(width: 1.5,color: Styles.gumColor,),
              borderRadius: BorderRadius.circular(15.0),
              color: Styles.greyColor.withOpacity(0.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: FittedBox(
                  fit: BoxFit.scaleDown, // Scale the text to fit within the container
                  alignment: Alignment.center, // Center the text within the container
                  child: Text('${model['title']}',overflow:TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Thunder',fontSize: 25,color: Styles.whiteColor))),
            ),
          ),

        ],
      ),
      SizedBox(width: 20,),

      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(child: Text('${model['date']}',style: TextStyle(fontSize: 14,fontFamily: 'Thunder',color: Styles.greyColor),)),
      ),
    ],
  ),
);



