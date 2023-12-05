import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:time/time.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:timer/queue.dart';
import 'package:vibration/vibration.dart';

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
  final player = AudioPlayer();
  bool _isMounted = false; // final assetsAudioPlayer = AssetsAudioPlayer();
  final vibration = Vibration.vibrate(pattern: [500, 1000, 500, 2000]);
  bool _isFullscreen = false;
  int _selectedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _isMounted = true;

    if (widget.field == 'Debate') {
      _selectedValue = 7;
    }

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

            setState(() {
              isTimerRunning = roomData['isRunning'];
              _futureDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
              _timeDifference = _futureDateTime.difference(DateTime.now());
              if (roomData['minutes'] == null) {
                _selectedValue = _selectedValue;
              } else {
                _selectedValue = roomData['minutes'];
              }
              if (roomData['second'] == null) {
                _selectedSeconds = _selectedSeconds;
              } else {
                _selectedSeconds = roomData['second'];
              }
            });
          }
        }
      }
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      // _updateTime();
      if (isTimerRunning) {
        _calculateTimeDifference();
      }
    });
  }

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

  Future<void> playUrl(String url) async {
    await player.play(UrlSource(url));
  }

  void _startTimer() async {
    player.stop();
    if (_selectedValue == 0 && _selectedSeconds == 0) {
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
    _futureDateTime = DateTime.now()
        .add(Duration(minutes: _selectedValue, seconds: _selectedSeconds));

    _timeDifference = Duration(minutes: _selectedValue);

    Future.delayed(const Duration(seconds: 1), () {
      Duration interval = const Duration(seconds: 1);

      timer = Timer.periodic(interval, (timer) {
        // _updateTime();
        _calculateTimeDifference();
      });
    });

    isTimerRunning = true;

    try {
      await _dataRef.child(widget.field).child(widget.room).update({
        'timestamp': _futureDateTime.millisecondsSinceEpoch,
        'isRunning': true,
        'minutes': _selectedValue,
        'second': _selectedSeconds
      });
    } catch (error) {
      // print(error);
    } finally {
      // print('Done writing to database');
    }
  }

  void _stopTimer() async {
    timer?.cancel();
    await Future.delayed(const Duration(milliseconds: 100));
    player.stop();
    // player.dispose();
    isTimerRunning = false;
    _futureDateTime = DateTime.now();
    _timeDifference = _futureDateTime.difference(DateTime.now());
    try {
      await _dataRef.child(widget.field).child(widget.room).update({
        'timestamp': _futureDateTime.millisecondsSinceEpoch,
        'isRunning': false,
        'minutes': _selectedValue,
        'second': _selectedSeconds
      });
    } finally {}

    if (_isMounted) {
      setState(() {});
    }
    // setState(() {});
  }

  void _calculateTimeDifference() async {
    DateTime currentDateTime = DateTime.now();
    _timeDifference = _futureDateTime.difference(currentDateTime);

    if (_timeDifference!.isNegative) {
      if (_timeDifference!.inMinutes.abs() > 2) {
        _stopTimer();
      }
    }
    if (widget.room != 'Perform room' &&
        _timeDifference!.inSeconds == 0 &&
        isTimerRunning) {
      playUrl('https://audio.jukehost.co.uk/QKQLX1wM1sD4auo8CGAq5FLCCr7iawLF');
      vibration;
    }

    if (widget.field == 'Debate') {
      switch (_timeDifference!.inMinutes) {
        case 6:
          if (_timeDifference!.inSeconds.remainder(60) == 0) {
            playUrl(
                'https://audio.jukehost.co.uk/bgX4iEoqWr5yhS1cFTMmMagQXN7f2K7N');
          }

          break;
        case 1:
          if (_timeDifference!.inSeconds.remainder(60) == 0) {
            playUrl(
              'https://audio.jukehost.co.uk/bgX4iEoqWr5yhS1cFTMmMagQXN7f2K7N',
            );
          }
          break;
        case 0:
          if (_timeDifference!.inSeconds == 0) {
            playUrl(
                'https://audio.jukehost.co.uk/rKoErLE85r2ll4Pi8IfMhQMhGvSIJ4UE');
          }
          break;
      }
      if (_timeDifference!.isNegative) {
        if (_timeDifference!.inSeconds.abs() > 20) {
          playUrl(
              'https://audio.jukehost.co.uk/rKoErLE85r2ll4Pi8IfMhQMhGvSIJ4UE');
        }
      }
    }

    if (_isMounted) {
      setState(() {});
    }
  }

  String padWithZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _isMounted = false;
    timer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes;
    int seconds;
    String count;

    if (isTimerRunning) {
      minutes = _timeDifference!.inMinutes.remainder(60);
      seconds = _timeDifference!.inSeconds.remainder(60);

      String minuteString = minutes.toString().padLeft(2, '0');
      String secondString = seconds.toString().padLeft(2, '0');

      count = '$minuteString:$secondString';
    } else {
      minutes = _selectedValue;
      seconds = _selectedSeconds;
      count = '$_selectedValue:$_selectedSeconds';
    }

    double progress = _timeDifference != null
        ? (_timeDifference!.inSeconds /
                (_selectedValue * 60 + _selectedSeconds))
            .clamp(0, 1)
        : 1.0;

    return Scaffold(
      body: Scaffold(
        appBar: (_isFullscreen)
            ? null
            : AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isFullscreen = !_isFullscreen;
                        FullScreenWindow.setFullScreen(_isFullscreen);
                      });
                    },
                    icon: (_isFullscreen)
                        ? const Icon(Icons.fullscreen_exit)
                        : const Icon(Icons.fullscreen),
                  ),
                ],
                title: Text(
                  widget.title,
                  style: GoogleFonts.lato(color: Colors.white),
                ),
                centerTitle: true,
                // backgroundColor: Colors.blue,
              ),
        body: Center(
          child: (_isFullscreen)
              ? timerFullscren(progress, count, context)
              : Column(
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
                        center: (widget.field != 'Debate')
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 66,
                                    child: CupertinoButton(
                                      // color: Colors.blue,
                                      child: Text(
                                        padWithZero(minutes),
                                        style: GoogleFonts.lato(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                      onPressed: () => showCupertinoModalPopup(
                                        context: context,
                                        builder: (_) => SizedBox(
                                          height: 250,
                                          child: CupertinoPicker(
                                            scrollController:
                                                FixedExtentScrollController(
                                              initialItem: 0,
                                            ),
                                            itemExtent: 25,
                                            onSelectedItemChanged: (int value) {
                                              setState(() {
                                                _selectedValue = value;
                                              });
                                            },
                                            children: [
                                              for (int i = 0; i < 61; i++)
                                                Text(padWithZero(i))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ':',
                                    style: GoogleFonts.lato(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                  SizedBox(
                                    width: 66,
                                    child: CupertinoButton(
                                      // color: Colors.blue,
                                      child: Text(
                                        padWithZero(seconds),
                                        style: GoogleFonts.lato(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                      onPressed: () => showCupertinoModalPopup(
                                        context: context,
                                        builder: (_) => SizedBox(
                                          height: 250,
                                          child: CupertinoPicker(
                                            scrollController:
                                                FixedExtentScrollController(
                                              initialItem: 0,
                                            ),
                                            itemExtent: 25,
                                            onSelectedItemChanged: (int value) {
                                              setState(() {
                                                _selectedSeconds = value;
                                              });
                                            },
                                            children: [
                                              for (int i = 0; i < 61; i++)
                                                Text(padWithZero(i))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                count,
                                style: GoogleFonts.lato(
                                    color: Colors.white, fontSize: 25),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Text(_timeDifference.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: _stopTimer,
                            icon: const Icon(Icons.timer_off_outlined)
                            // iconSize: 30,
                            ),
                        IconButton(
                          onPressed: _startTimer,
                          icon: const Icon(Icons.timer_outlined),
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
        floatingActionButton: IconButton(
          onPressed: () {
            setState(() {
              _isFullscreen = !_isFullscreen;
              FullScreenWindow.setFullScreen(_isFullscreen);
            });
          },
          icon: (_isFullscreen)
              ? const Icon(Icons.fullscreen_exit)
              : const Icon(Icons.fullscreen),
        ),
      ),
    );
  }
}

Widget timerFullscren(double progress, String count, context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.1,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width - 100,
          child: LinearPercentIndicator(
            percent: progress,
            // animation:   ,
            lineHeight: 15,
            progressColor: Colors.blue,
          ),
        ),
      ],
    ),
  );
}
