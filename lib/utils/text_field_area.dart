import 'package:cos_challenge/utils/helpers.dart';
import 'package:cos_challenge/utils/theme.dart';
import 'package:flutter/material.dart';

class TextFieldArea extends StatelessWidget {
  final String text;
  final TextEditingController textController;
  final void Function(String text) onSubmitted;

  const TextFieldArea({
    super.key,
    required this.text,
    required this.textController,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidthPortion(context, 0.1)),
    child: Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColor.yellowCreamCan),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColor.yellowCreamCan,
                    width: 2,
                  ),
                ),
              ),
              cursorColor: AppColor.yellowCreamCan,
              onSubmitted: onSubmitted,
            ),
          ),
          Spacer(),
        ],
      ),
    ),
  );
}
