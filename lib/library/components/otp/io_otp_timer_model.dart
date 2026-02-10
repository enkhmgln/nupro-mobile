import 'dart:async';

import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:flutter/foundation.dart';

class IOOtpTimerModel extends ChangeNotifier {
  final int duration;
  final buttonModel = IOButtonModel(
    label: 'Код авах',
    type: IOButtonType.secondary,
    size: IOButtonSize.tiny,
  );

  int remainingDuration = 5;
  Timer? timer;

  String get minute {
    return (remainingDuration ~/ 60).toString().padLeft(2, '0');
  }

  String get second {
    return (remainingDuration % 60).toString().padLeft(2, '0');
  }

  bool get isTimerEnded {
    return remainingDuration == 0;
  }

  IOOtpTimerModel({this.duration = 180}) {
    remainingDuration = duration;
  }

  void startTimer() {
    endTimer();
    remainingDuration = duration;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (ticker) {
        if (remainingDuration > 0) {
          remainingDuration = duration - ticker.tick;
        } else {
          remainingDuration = 0;
          endTimer();
        }
        notifyListeners();
      },
    );
  }

  void endTimer() {
    timer?.cancel();
  }

  @override
  void dispose() {
    endTimer();
    super.dispose();
  }
}
