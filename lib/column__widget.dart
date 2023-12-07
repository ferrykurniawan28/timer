// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer/my_flutter_app_icons.dart';
import 'package:timer/streamtime.dart';

class Column_Widget extends StatelessWidget {
  const Column_Widget(
      {super.key,
      required this.controllerSpeech,
      required this.gridColor,
      required this.field});

  final ExpansionTileController controllerSpeech;
  final Color gridColor;
  final String field;

  @override
  Widget build(BuildContext context) {
    final iconfield = {
      'Debate': MyFlutterApp.debate,
      'Newscasting': MyFlutterApp.newscaster,
      'Storytelling': MyFlutterApp.storytelling,
      'Spelling Bee': MyFlutterApp.bee,
      'Speech': MyFlutterApp.speaker,
    };
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          Scaffold.of(context).openDrawer();

          Future.delayed(const Duration(milliseconds: 100), () {
            if (controllerSpeech.isExpanded) {
              controllerSpeech.collapse();
            } else {
              controllerSpeech.expand();
            }
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
              color: gridColor, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconfield[field]),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    field,
                    style: GoogleFonts.lato(fontSize: 20),
                  ),
                ],
              ),
              if (field != 'Debate')
                StreamTime(
                  title: 'Prep room 1',
                  room: 'prep room1',
                  field: field,
                ),
              if (field != 'Debate')
                StreamTime(
                  title: 'Prep room 2',
                  room: 'Prep room2',
                  field: field,
                ),
              StreamTime(
                title: 'Perform room',
                room: 'Perform room',
                field: field,
              ),
            ],
          ),
        ),
      );
    });
  }
}
