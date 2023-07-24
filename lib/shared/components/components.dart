import 'package:flutter/material.dart';

import '../cubit/cubit.dart';
import '../styles/styles.dart';

Widget buildTextField({
  double widthRit = 0.6,
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
    height: MediaQuery.of(context).size.height * 0.07,
    decoration: BoxDecoration(
      color: Styles.lightBlackColor,
      border: Border.all(color: Styles.greyColor, width: 2),
      borderRadius: BorderRadius.circular(26.0),
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
        style: const TextStyle(color: Styles.greyColor, fontSize: 16),
        cursorColor: Styles.gumColor,
        controller: controller,
        // Set the validator function
        decoration: InputDecoration(
          prefixIcon: Icon(prefix, color: Styles.gumColor),
          hintText: labelText,
          hintStyle: TextStyle(
            color: Styles.gumColor.withOpacity(0.5),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          border: InputBorder.none,
        ),
      ),
    ),
  );
}

Widget buildTaskItem({required Map model, context, required index}) =>
    Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: AlignmentDirectional.centerStart,
        color: Styles.gumColor,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(30.0, 0.0, 10.0, 0.0),
          child: Icon(
            Icons.delete_forever_rounded,
            color: Styles.blackColor,
          ),
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: model['id']);
      },
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: Styles.gumColor,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    color: Styles.greyColor.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                              child: Text(
                            '${model['time']}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Thunder',
                                color: Styles.greyColor),
                          )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text('${model['title']}',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontFamily: 'Thunder',
                                    fontSize: 20,
                                    color: Styles.whiteColor)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                              child: Text(
                            '${model['date']}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Thunder',
                                color: Styles.greyColor),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Visibility(
              visible: index == 0 || index == 2,
              child: IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    AppCubit.get(context).updateDatabase(
                      status: 'done',
                      id: model['id'],
                    );
                  },
                  icon: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Styles.greyColor,
                    size: 25,
                  )),
            ),
            Visibility(
              visible: index == 0 || index == 1,
              child: IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    AppCubit.get(context).updateDatabase(
                      status: 'archive',
                      id: model['id'],
                    );
                  },
                  icon: const Icon(
                    Icons.archive_outlined,
                    color: Styles.greyColor,
                    size: 25,
                  )),
            ),
            Visibility(
              visible: index == 1 || index == 2,
              child: IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    AppCubit.get(context).updateDatabase(
                      status: 'new',
                      id: model['id'],
                    );
                  },
                  icon: const Icon(
                    Icons.hide_source_rounded,
                    color: Styles.greyColor,
                    size: 25,
                  )),
            ),
          ],
        ),
      ),
    );
