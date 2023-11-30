// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:timer/jam.dart';
import 'package:timer/streamtime.dart';
// import 'package:flutter/widgets.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref();
// final db = FirebaseFirestore.instance;

class MainScreenMobile extends StatefulWidget {
  const MainScreenMobile({super.key});

  @override
  State<MainScreenMobile> createState() => _MainScreenMobileState();
}

class _MainScreenMobileState extends State<MainScreenMobile> {
  // final MyExpansionTileController controllerSpeech =
  //     MyExpansionTileController();
  final ExpansionTileController controllerSpeech = ExpansionTileController();
  final ExpansionTileController controllerStortel = ExpansionTileController();
  final ExpansionTileController controllerNewscast = ExpansionTileController();
  final ExpansionTileController controllerSpellbee = ExpansionTileController();
  final ExpansionTileController controllerDebate = ExpansionTileController();
  bool isExpandedSpeech = false;
  bool isExpandedStortel = false;
  bool isExpandedNewscast = false;
  bool isExpandedSpellbee = false;
  bool isExpandedDebate = false;

  // final GlobalKey<ExpansionTileState> expansionTileKey = GlobalKey();

  Color gridColor = Colors.black54;
  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800;

  @override
  Widget build(BuildContext context) {
    // final widthDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      // drawerScrimColor: Colors.white,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            color: Colors.white,
            icon: const Icon(Icons.menu),
          );
        }),
        title: Text(
          'Homepage',
          style: GoogleFonts.lato(color: Colors.white),
        ),
        centerTitle: true,
        // backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        // backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                child: Text(
                  'AEO 2024',
                  style: GoogleFonts.lato(),
                ),
                // margin: EdgeInsets.all(20),
                // decoration: BoxDecoration(),
              ),
              ExpansionTile(
                  title: Text(
                    'Speech',
                    style: GoogleFonts.lato(),
                  ),
                  controller: controllerSpeech,
                  children: [
                    ListTile(
                      title: Text(
                        'Prep room 1',
                        style: GoogleFonts.lato(),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/speech_prep_1');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Prep room 2',
                        style: GoogleFonts.lato(),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/speech_prep_2');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Perform room',
                        style: GoogleFonts.lato(),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/speech_perform');
                      },
                    )
                  ]),
              ExpansionTile(
                title: Text(
                  'Storytelling',
                  style: GoogleFonts.lato(),
                ),
                controller: controllerStortel,
                children: [
                  ListTile(
                    title: Text(
                      'Prep room 1',
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/storytelling_prep_1');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Prep room 2',
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/storytelling_prep_2');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Perform room',
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/storytelling_perform');
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Newscasting',
                  style: GoogleFonts.lato(),
                ),
                controller: controllerNewscast,
                children: [
                  ListTile(
                    title: Text(
                      'Prep room 1',
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/newscasting_prep_1');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Prep room 2',
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/newscasting_prep_2');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Perform room',
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/newscasting_perform');
                    },
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Spelling Bee',
                  style: GoogleFonts.lato(),
                ),
                controller: controllerSpellbee,
                children: [
                  ListTile(
                    title: Text(
                      'Perform room',
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/spelling_bee_perform');
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Debate',
                  style: GoogleFonts.lato(),
                ),
                controller: controllerDebate,
                children: [
                  ListTile(
                    title: Text(
                      'Perform room',
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/debate_perform');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: (isDesktop(context)) ? 150 : 100,
              child: Jam(
                sizeDate: (isDesktop(context)) ? 40 : 25,
                sizeHour: (isDesktop(context)) ? 35 : 23,
              ),
            ),
            StaggeredGrid.count(
              crossAxisCount: (isDesktop(context)) ? 4 : 2,
              // padding: const EdgeInsets.all(10),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1.2,
                  child: Builder(builder: (context) {
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
                            color: gridColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Speech',
                              style: GoogleFonts.lato(fontSize: 20),
                            ),
                            const StreamTime(
                              title: 'Prep room 1',
                              room: 'prep room1',
                              field: 'Speech',
                            ),
                            const StreamTime(
                              title: 'Prep room 2',
                              room: 'Prep room2',
                              field: 'Speech',
                            ),
                            const StreamTime(
                              title: 'Perform room',
                              room: 'Perform room',
                              field: 'Speech',
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1.2,
                  child: Builder(builder: (context) {
                    return InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();

                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (controllerStortel.isExpanded) {
                            controllerStortel.collapse();
                          } else {
                            controllerStortel.expand();
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: gridColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Storytelling',
                              style: GoogleFonts.lato(fontSize: 20),
                            ),
                            const StreamTime(
                              title: 'Prep room 1',
                              room: 'Prep room1',
                              field: 'Storytelling',
                            ),
                            const StreamTime(
                              title: 'Prep room 2',
                              room: 'Prep room2',
                              field: 'Storytelling',
                            ),
                            const StreamTime(
                              title: 'Perform room',
                              room: 'Perform room',
                              field: 'Storytelling',
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                StaggeredGridTile.count(
                  mainAxisCellCount: 1.2,
                  crossAxisCellCount: 1,
                  child: Builder(builder: (context) {
                    return InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();

                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (controllerNewscast.isExpanded) {
                            controllerNewscast.collapse();
                          } else {
                            controllerNewscast.expand();
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: gridColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Newscasting',
                              style: GoogleFonts.lato(fontSize: 20),
                            ),
                            const StreamTime(
                              title: 'Prep room 1',
                              room: 'Prep room1',
                              field: 'Newscasting',
                            ),
                            const StreamTime(
                              title: 'Prep room 2',
                              room: 'Prep room2',
                              field: 'Newscasting',
                            ),
                            const StreamTime(
                              title: 'Perform room',
                              room: 'Perform room',
                              field: 'Newscasting',
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 0.6,
                  child: Builder(builder: (context) {
                    return InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();

                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (controllerSpellbee.isExpanded) {
                            controllerSpellbee.collapse();
                          } else {
                            controllerSpellbee.expand();
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: gridColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Spelling Bee',
                              style: GoogleFonts.lato(fontSize: 20),
                            ),
                            const StreamTime(
                              title: 'Perform room',
                              room: 'Perform room',
                              field: 'Spelling Bee',
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 0.6,
                  child: Builder(builder: (context) {
                    return InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();

                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (controllerDebate.isExpanded) {
                            controllerDebate.collapse();
                          } else {
                            controllerDebate.expand();
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: gridColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Debate',
                              style: GoogleFonts.lato(fontSize: 20),
                            ),
                            const StreamTime(
                              title: 'Perform room',
                              room: 'Perform room',
                              field: 'Debate',
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
