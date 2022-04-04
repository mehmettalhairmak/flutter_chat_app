import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/app/widgets/cross_platform_widget.dart';

class CrossPlatformAlertDialog extends CrossPlatformWidget {
  final String title;
  final String content;
  final String mainButtonTitle;
  final String? cancelButtonTitle;

  const CrossPlatformAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.mainButtonTitle,
    this.cancelButtonTitle,
  }) : super(key: key);

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => this);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtons(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtons(context),
    );
  }

  List<Widget> _dialogButtons(BuildContext context) {
    final _allButton = <Widget>[];
    if (Platform.isIOS) {
      if (cancelButtonTitle != null) {
        _allButton.add(
          CupertinoDialogAction(
            child: Text(cancelButtonTitle!),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        );
      }
      _allButton.add(
        CupertinoDialogAction(
          child: Text(mainButtonTitle),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      );
    } else {
      if (cancelButtonTitle != null) {
        _allButton.add(
          ElevatedButton(
            child: Text(cancelButtonTitle!),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        );
      }
      _allButton.add(
        ElevatedButton(
          child: Text(mainButtonTitle),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      );
    }
    return _allButton;
  }
}
