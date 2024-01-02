import 'dart:async';
// import 'dart:ffi';
// import 'dart:ffi';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:time/time.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timer/queue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'is_admin.dart';

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
  bool isUserAdmin = false;
  // AudioCache audioCache = AudioCache();

  // check access
  Future<bool> checkAccess() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null && await isAdmin()) {
      return true;
    }
    return false;
  }

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

  Future<void> playUrl(String url) async {
    await player.play(UrlSource(url));
  }

  void _startTimer() async {
    // player.play(
    //   AssetSource('sm64_coin.mp3'),
    // );
    // playUrl('https://audio.jukehost.co.uk/bgX4iEoqWr5yhS1cFTMmMagQXN7f2K7N');
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

    if (_isMounted) {
      setState(() {});
    }
    // setState(() {});
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

    if (widget.field == 'Debate') {
      switch (_timeDifference!.inMinutes) {
        case 6:
          if (_timeDifference!.inSeconds.remainder(60) == 0) {
            playUrl(
                'https://audio.jukehost.co.uk/bgX4iEoqWr5yhS1cFTMmMagQXN7f2K7N');
            // assetsAudioPlayer.open(Audio("sm64_coin.mp3"), autoStart: true);
            // AudioPlayer player = await audioCache.fixedPlayer('sm64_blue_coin.mp3');
          }

          break;
        case 1:
          if (_timeDifference!.inSeconds.remainder(60) == 0) {
            playUrl(
                'https://audio.jukehost.co.uk/bgX4iEoqWr5yhS1cFTMmMagQXN7f2K7N');
            // assetsAudioPlayer.open(Audio("sm64_coin.mp3"), autoStart: true);
          }
          break;
        case 0:
          if (_timeDifference!.inSeconds == 0) {
            // assetsAudioPlayer.open(Audio("sm64_coin.mp3"), autoStart: true);
            playUrl(
                'https://audio.jukehost.co.uk/rKoErLE85r2ll4Pi8IfMhQMhGvSIJ4UE');
            // AssetsAudioPlayer.open(
            //   Audio("sm64_coin.mp3"),
            //   autoStart: true,
            //   // showNotification: true,
            // );
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
    // setState(() {});
  }

  @override
  void dispose() {
    _isMounted = false;
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
        body: FutureBuilder(
          future: checkAccess(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.data == true) {
                return Center(
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
                          center: (widget.field != 'Debate')
                              ? CupertinoButton(
                                  // color: Colors.blue,
                                  child: Text(
                                    count,
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
                );
              } else {
                return const Center(
                  child: Text('You do not have access to this page'),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
