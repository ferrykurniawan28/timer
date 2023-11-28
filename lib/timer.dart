import 'dart:async';
// import 'dart:ffi';
// import 'dart:ffi';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:time/time.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timer/queue.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class Time extends StatefulWidget {
  const Time(
      {required this.title,
      required this.field,
      required this.room,
      super.key});
  final String title;
  final String field;
  final String room;

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  final DatabaseReference _dataRef = FirebaseDatabase.instance.ref('/AEO');

  Map<String, dynamic> datavalue = {};
  String dtime = '';
  int dtimInt = 0;
  late DateTime _futureDateTime;
  late DateTime futureTime;
  Timer? timer;
  Duration? _timeDifference;
  bool isTimerRunning = false;
  dynamic future;
  int _selectedValue = 0;

  @override
  void initState() {
    super.initState();

    // _selectedValue = 3;

    _dataRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        // Assuming there is only one key-value pair in widget.field
        final fieldData = data[widget.field];

        if (fieldData != null && fieldData is Map) {
          // Assuming there is only one key-value pair in widget.room
          final roomData = fieldData[widget.room];

          if (roomData != null && roomData is Map) {
            // Accessing the timestamp and isRunning values
            final timestamp = roomData['timestamp'];
            // final isRunning = roomData['isRunning'];

            // print('Timestamp: $timestamp');
            // print('Is Running: $isRunning');

            setState(() {
              isTimerRunning = roomData['isRunning'];
              _futureDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            });
          }
        }
      }
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      // _updateTime();
      if (isTimerRunning) {
        _calculateTimeDifference();
      } else {
        // setState(() {});
        // _stopTimer();
      }
    });
  }

  // void _updateTime() {
  //   setState(() {
  //     _currentDateTime = DateTime.now();
  //   });
  // }
  void showError(String errorMessage, List<Widget> action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error!'),
        content: Text(errorMessage),
        actions: action,
      ),
    );
  }

  void _startTimer() async {
    if (_selectedValue == 0) {
      showError(
        'Please select a time!',
        [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Select'),
          ),
        ],
      );
      return;
    }
    _futureDateTime = DateTime.now().add(Duration(minutes: _selectedValue));

    _timeDifference = Duration(minutes: _selectedValue);

    Future.delayed(const Duration(seconds: 1), () {
      Duration interval = const Duration(seconds: 1);

      timer = Timer.periodic(interval, (timer) {
        // _updateTime();
        _calculateTimeDifference();
      });
    });

    isTimerRunning = true;

    // await _dataRef.child('time').set(_futureDateTime);
    try {
      await _dataRef.child(widget.field).child(widget.room).update({
        'timestamp': _futureDateTime.millisecondsSinceEpoch,
        'isRunning': true
      });
    } catch (error) {
      // print(error);
    } finally {
      // print('Done writing to database');
    }

    // _dataRef.child('dtime').set(_futureDateTime);
    // await _dataRef.child('room1').set(_futureDateTime)
  }

  void _stopTimer() async {
    timer?.cancel();
    isTimerRunning = false;
    _futureDateTime = DateTime.now();
    _timeDifference = _futureDateTime.difference(DateTime.now());
    try {
      await _dataRef.child(widget.field).child(widget.room).update({
        'timestamp': _futureDateTime.millisecondsSinceEpoch,
        'isRunning': false
      });
    } catch (error) {
      // print(error);
    } finally {
      // print('Done writing to database');
    }
    setState(() {});
  }

  void _calculateTimeDifference() async {
    // futureTime = DateTime.fromMillisecondsSinceEpoch(future);
    DateTime currentDateTime = DateTime.now();
    _timeDifference = _futureDateTime.difference(currentDateTime);

    if (_timeDifference!.isNegative) {
      // _timeDifference = const Duration(minutes: -2);
      if (_timeDifference!.inMinutes.abs() > 2) {
        _stopTimer();
        // return;
      }
    }
    // If the future date is in the past, stop the timer
    // if (_timeDifference! <= Duration.zero) {
    //   // timer?.cancel();
    //   // _timeDifference = Duration.zero;
    //   // _stopTimer();
    //   // isTimerRunning = false;
    // }

    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String count = isTimerRunning
        ? '${_timeDifference!.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_timeDifference!.inSeconds.remainder(60).toString().padLeft(2, '0')}'
        : '$_selectedValue:00';

    double progress = _timeDifference != null
        ? (_timeDifference!.inSeconds / (_selectedValue * 60))
            .clamp(0, 1) // Assuming the timer is set for 30 seconds
        : 1.0;

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: GoogleFonts.lato(color: Colors.white),
          ),
          centerTitle: true,
          // backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: CircularPercentIndicator(
                  radius: 70,
                  // animation: true,
                  // animateFromLastPercent: false,
                  progressColor: (progress >= 0.2)
                      ? const Color.fromARGB(255, 0, 152, 255)
                      : Colors.red,
                  lineWidth: 10,
                  percent: progress,
                  center: CupertinoButton(
                    // color: Colors.blue,
                    child: Text(
                      count,
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 25),
                    ),
                    onPressed: () => showCupertinoModalPopup(
                      context: context,
                      builder: (_) => SizedBox(
                        height: 250,
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: 0,
                          ),
                          itemExtent: 30,
                          onSelectedItemChanged: (int value) {
                            final Map<int, int> time = {
                              0: 0,
                              1: 2,
                              2: 3,
                              3: 5,
                              4: 6,
                              5: 7,
                              6: 8,
                              7: 10,
                              8: 12,
                              9: 15,
                              10: 30,
                            };
                            setState(() {
                              _selectedValue = time[value]!;
                            });
                          },
                          children: const [
                            Text('00:00'),
                            Text('02:00'),
                            Text('03:00'),
                            Text('05:00'),
                            Text('06:00'),
                            Text('07:00'),
                            Text('08:00'),
                            Text('10:00'),
                            Text('12:00'),
                            Text('15:00'),
                            Text('30:00'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _startTimer,
                    icon: const Icon(Icons.timer_outlined),
                  ),
                  // CupertinoButton.filled(
                  //   child: Text('Minutes: $_selectedValue'),
                  //   onPressed: () => showCupertinoModalPopup(
                  //     context: context,
                  //     builder: (_) => SizedBox(
                  //       height: 250,
                  //       child: CupertinoPicker(
                  //         scrollController: FixedExtentScrollController(),
                  //         itemExtent: 30,
                  //         onSelectedItemChanged: (int value) {},
                  //         children: [],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  IconButton(
                    onPressed: _stopTimer,
                    icon: const Icon(Icons.timer_off_outlined),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              QueNumber(field: widget.field, room: widget.room),
            ],
          ),
        ),
      ),
    );
  }
}
