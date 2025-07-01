import 'package:fangmou_app/screens/splash_screen/model/startup_status.dart';
import 'package:flutter/foundation.dart';

class SlashScreenState {
  final String message;
  final double progressPercent;
  final bool initializeFailed;

  SlashScreenState._slashScreenState(this.message, this.progressPercent, this.initializeFailed);

  factory SlashScreenState(StartupStatus status) {
    if (status == StartupStatus.failure) {
      return SlashScreenState._slashScreenState(status.message, status.progressPercent, status.initializeFailed);
    }
    return SlashScreenState._slashScreenState(status.message, status.progressPercent, status.initializeFailed);
  }
}
