import 'package:flutter/cupertino.dart';

class UiUtil {
  final BuildContext context;

  UiUtil(this.context);

  void back({dynamic data}) => Navigator.of(context).pop(data);

  void alert({
    required String msg,
    String title = 'Info',
    bool goBack = false,
    dynamic backData,
  }) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: !goBack,
      builder: (builder) {
        return goBack
            ? WillPopScope(
                child: dialog(title, msg, goBack, backData),
                onWillPop: () async => false,
              )
            : dialog(title, msg, goBack, backData);
      },
    );
  }

  CupertinoAlertDialog dialog(
    String title,
    String msg,
    bool goBack,
    dynamic backData,
  ) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(
        msg,
        style: const TextStyle(fontSize: 15),
      ),
      actions: [
        CupertinoButton(
          child: const Text('OK'),
          onPressed: () {
            back();
            if (goBack) back(data: backData);
          },
        ),
      ],
    );
  }
}
