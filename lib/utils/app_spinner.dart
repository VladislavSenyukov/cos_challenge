import 'package:cos_challenge/utils/theme.dart';
import 'package:flutter/material.dart';

class AppSpinner extends StatelessWidget {
  final bool isLoading;
  static const _spinnerHeight = 40.0;

  const AppSpinner({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) =>
      isLoading
          ? CircularProgressIndicator(
            color: AppColor.yellowCreamCan,
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
            constraints: BoxConstraints(
              minWidth: _spinnerHeight,
              minHeight: _spinnerHeight,
            ),
          )
          : SizedBox(width: _spinnerHeight, height: _spinnerHeight);
}
