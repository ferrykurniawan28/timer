import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Jam extends StatefulWidget {
  const Jam({this.sizeDate, this.sizeHour, super.key});
  final sizeDate;
  final sizeHour;

  @override
  State<Jam> createState() => _JamState();
}

class _JamState extends State<Jam> {
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    setState(() {
      now = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = DateFormat('yMMMMEEEEd').format(now);
    final jam = DateFormat('jms').format(now);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          result,
          style: GoogleFonts.lato(
            fontSize: widget.sizeDate,
          ),
        ),
        Text(
          jam,
          style: GoogleFonts.lato(
            fontSize: widget.sizeHour,
          ),
        )
      ],
    );
  }
}
