import 'dart:io';

import 'package:flutter/material.dart';

abstract class CrossPlatformWidget extends StatelessWidget {
  const CrossPlatformWidget({Key? key}) : super(key: key);

  Widget buildAndroidWidget(BuildContext context);
  Widget buildIOSWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildIOSWidget(context);
    } else {
      return buildAndroidWidget(context);
    }
  }
}
