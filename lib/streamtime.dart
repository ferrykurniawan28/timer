import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreamTime extends StatefulWidget {
  const StreamTime(
      {required this.title,
      required this.room,
      required this.field,
      super.key});
  final String title;
  final String room;
  final String field;

  @override
  State<StreamTime> createState() => _StreamTimeState();
}

class _StreamTimeState extends State<StreamTime> {
  final DatabaseReference _dataRef = FirebaseDatabase.instance.ref('/AEO');
  late DateTime _futureDateTime;
  Duration? _timeDifference;
  late bool isTimerRunning;
  int queue = 0;

  @override
  void initState() {
    super.initState();

    _dataRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        final fieldData = data[widget.field];

        if (fieldData != null && fieldData is Map) {
          final roomData = fieldData[widget.room];

          if (roomData != null && roomData is Map) {
            final timestamp = roomData['timestamp'];

            setState(() {
              _futureDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
              isTimerRunning = roomData['isRunning'];
              queue = roomData['queue'];
            });
          }
        }
      }
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isTimerRunning) {
        _calculateTimeDifference();
      } else if (!isTimerRunning) {
        setState(() {
          _futureDateTime = DateTime.now();
          // _timeDifference = Duration.zero;
        });
      }
    });
  }

  void _calculateTimeDifference() async {
    // futureTime = DateTime.fromMillisecondsSinceEpoch(future);
    DateTime currentDateTime = DateTime.now();
    _timeDifference = _futureDateTime.difference(currentDateTime);

    if (_timeDifference!.isNegative) {
      // _timeDifference = const Duration(minutes: -2);
      if (_timeDifference!.inMinutes.abs() > 2) {
        // _stopTimer();
        return;
      }
    }
    // If the future date is in the past, stop the timer
    // if (_timeDifference! <= Duration.zero) {
    //   // timer?.cancel();
    //   _timeDifference = Duration.zero;
    //   // _stopTimer();
    //   isTimerRunning = false;
    // }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String count = _timeDifference != null
        ? '${_timeDifference!.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_timeDifference!.inSeconds.remainder(60).toString().padLeft(2, '0')}'
        : '00:00';
    return Column(
      children: [
        Text(
          widget.title,
          style: GoogleFonts.lato(),
        ),
        Text('Queue: ${queue.toString()}'),
        Text('Time left: $count')
      ],
    );
  }
}
