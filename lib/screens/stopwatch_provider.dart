import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopwatchProvider extends ChangeNotifier {
  final StopWatchTimer stopwatch = StopWatchTimer();
}
