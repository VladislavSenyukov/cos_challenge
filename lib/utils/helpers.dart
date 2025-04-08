import 'package:cos_challenge/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

Size screenSize(BuildContext context) => MediaQuery.of(context).size;

double screenHeightPortion(BuildContext context, double portion) =>
    screenSize(context).height * portion;

double screenWidthPortion(BuildContext context, double portion) =>
    screenSize(context).width * portion;

void showNotification(String text) => showSimpleNotification(
  Center(
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColor.white,
      ),
    ),
  ),
  background: AppColor.redDevil,
  duration: Duration(seconds: 5),
);
