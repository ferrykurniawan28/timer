import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QueNumber extends StatefulWidget {
  const QueNumber({required this.field, required this.room, super.key});
  final String field;
  final String room;

  @override
  State<QueNumber> createState() => _QueNumberState();
}

class _QueNumberState extends State<QueNumber> {
  final DatabaseReference _dataRef = FirebaseDatabase.instance.ref('/AEO');
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
            setState(() {
              queue = roomData['queue'];
            });
          }
        }
      }
    });
  }

  void incremnt() async {
    setState(() {
      queue++;
    });
    await _dataRef
        .child(widget.field)
        .child(widget.room)
        .update({'queue': queue});
  }

  void decrement() async {
    setState(() {
      queue--;
    });
    await _dataRef
        .child(widget.field)
        .child(widget.room)
        .update({'queue': queue});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Queue Number',
          style: GoogleFonts.lato(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: decrement,
              backgroundColor: const Color.fromARGB(255, 0, 152, 255),
              child: const Icon(Icons.remove),
            ),
            Text(queue.toString()),
            FloatingActionButton(
              onPressed: incremnt,
              backgroundColor: const Color.fromARGB(255, 0, 152, 255),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
