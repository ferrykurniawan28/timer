// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer/my_flutter_app_icons.dart';
import 'package:timer/streamtime.dart';

class Column_Widget extends StatelessWidget {
  const Column_Widget(
      {super.key,
      required this.controllerExpand,
      required this.gridColor,
      required this.field,
      required this.isDesktop});

  final ExpansionTileController controllerExpand;
  final Color gridColor;
  final String field;
  final bool isDesktop;

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
            if (controllerExpand.isExpanded) {
              controllerExpand.collapse();
            } else {
              controllerExpand.expand();
            }
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [adjustColorIntensity(gridColor, 150), gridColor]),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      iconfield[field],
                      size: 50,
                    ),
                    SizedBox(
                      width: (isDesktop) ? 30 : 10,
                    ),
                    Text(
                      field,
                      style: GoogleFonts.lato(fontSize: 20),
                    ),
                  ],
                ),
              ),
              if (field != 'Debate')
                Expanded(
                  child: StreamTime(
                    title: 'Prep room 1',
                    room: 'prep room1',
                    field: field,
                    fontsize: (isDesktop) ? 20 : 13,
                  ),
                ),
              if (isDesktop)
                const SizedBox(
                  height: 10,
                ),
              if (field != 'Debate')
                Expanded(
                  child: StreamTime(
                    title: 'Prep room 2',
                    room: 'Prep room2',
                    field: field,
                    fontsize: (isDesktop) ? 20 : 13,
                  ),
                ),
              if (isDesktop)
                const SizedBox(
                  height: 10,
                ),
              Expanded(
                child: StreamTime(
                  title: 'Perform room',
                  room: 'Perform room',
                  field: field,
                  fontsize: (isDesktop) ? 20 : 13,
                ),
              ),
              if (isDesktop)
                const SizedBox(
                  height: 10,
                ),
              if (field != 'Debate')
                const SizedBox(
                  height: 30,
                )
            ],
          ),
        ),
      );
    });
  }
}

Color adjustColorIntensity(Color baseColor, int factor) {
  int red = (baseColor.red * factor / 100).round().clamp(0, 255);
  int green = (baseColor.green * factor / 100).round().clamp(0, 255);
  int blue = (baseColor.blue * factor / 100).round().clamp(0, 255);

  return Color.fromARGB(255, red, green, blue);
}
