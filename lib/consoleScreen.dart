import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class Console extends StatefulWidget {
  @override
  _ConsoleState createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  late StreamSubscription<QuerySnapshot> _subscription;
  late QuerySnapshot _querySnapshot;

  @override
  void initState() {
    super.initState();
    _subscribeToUpdates();
  }

  void _subscribeToUpdates() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference reportsCollection = firestore.collection('reports');

    _subscription =
        reportsCollection.snapshots().listen((QuerySnapshot snapshot) {
      setState(() {
        _querySnapshot = snapshot;
        print('------------5--------------');
        print(_querySnapshot.docs);
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          leading: Icon(
            Icons.menu_rounded,
            color: Colors.white,
          ),
          title: Center(
              child: Text(
            'Console',
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('reports').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text('No data available'),
              );
            } else {
              List<Widget> widgets = [];
              List<Marker> markers = [];

              for (QueryDocumentSnapshot document in _querySnapshot.docs) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String id = document.id;
                String victim = data!['victim'];
                GeoPoint location = data!['location'];
                Timestamp time = data!['time'];
                // ... (access other variables as needed)

                markers.add(
                  Marker(
                    point: LatLng(location.latitude, location.longitude),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.car_crash_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );

                widgets.add(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(victim)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (userSnapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!userSnapshot.hasData ||
                              userSnapshot.data == null) {
                            return const Center(
                              child: Text('No data available'),
                            );
                          } else {
                            print("------------5---------");
                            print(userSnapshot.data!.id);
                            print(userSnapshot.data!.data());
                            Map<String, dynamic> userData = userSnapshot.data!
                                .data() as Map<String, dynamic>;
                            print(userData);
                            String name = userData!['name'];
                            return Container(
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.6),
                                      offset: const Offset(0, 0),
                                      blurRadius: 5.0,
                                      spreadRadius: 1.0,
                                    ), //BoxShadow
                                  ]),
                              width: double.infinity,
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(data['images'][1]),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Medical history - ${userData['medicalHistory']}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                            'Time: ${DateFormat.jm().format((time as Timestamp).toDate())}',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        SizedBox(
                                          height: 25,
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              launchUrl(Uri.parse(
                                                  'https://q-lert.github.io/reports/?report=${id}'));
                                            },
                                            icon: Icon(Icons.report_rounded)),
                                        Text(
                                          'More info',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              launchUrl(Uri.parse(
                                                  'https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}'));
                                            },
                                            icon: Icon(Icons.map)),
                                        Text(
                                          'open in maps',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                );
              }

              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 80),
                    height: 50,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Image(image: AssetImage('assets/logo.png')),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Dashboard',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 1.0, color: Colors.black),
                                  color: Colors.grey.shade300,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.6),
                                      offset: const Offset(0, 0),
                                      blurRadius: 5.0,
                                      spreadRadius: 1.0,
                                    ), //BoxShadow
                                  ]),
                              height: 600,
                              width: 800,
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: widgets
                                    //[
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Container(
                                    //     margin: EdgeInsets.only(top: 20),
                                    //     decoration: BoxDecoration(
                                    //         color: Colors.white,
                                    //         borderRadius:
                                    //             BorderRadius.circular(20),
                                    //         boxShadow: [
                                    //           BoxShadow(
                                    //             color: Colors.black
                                    //                 .withOpacity(0.6),
                                    //             offset: const Offset(0, 0),
                                    //             blurRadius: 5.0,
                                    //             spreadRadius: 1.0,
                                    //           ), //BoxShadow
                                    //         ]),
                                    //     width: double.infinity,
                                    //     height: 150,
                                    //     child: Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.spaceAround,
                                    //       children: [
                                    //         CircleAvatar(
                                    //           radius: 50,
                                    //           backgroundImage:
                                    //               AssetImage('assets/logo.png'),
                                    //         ),
                                    //         Column(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.end,
                                    //           children: [
                                    //             Text(
                                    //               'Batman',
                                    //               style: TextStyle(
                                    //                   fontSize: 25,
                                    //                   fontWeight:
                                    //                       FontWeight.bold),
                                    //             ),
                                    //             SizedBox(
                                    //               height: 20,
                                    //             ),
                                    //             Text(
                                    //               'Medical Record: suffers from depression so be nice to him',
                                    //               style: TextStyle(
                                    //                   color: Colors.grey),
                                    //             ),
                                    //             Text(
                                    //                 'time of incident: 8:45pm today',
                                    //                 style: TextStyle(
                                    //                     color: Colors.grey)),
                                    //             SizedBox(
                                    //               height: 25,
                                    //             )
                                    //           ],
                                    //         ),
                                    //         Column(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.center,
                                    //           children: [
                                    //             IconButton(
                                    //                 onPressed: () {},
                                    //                 icon: Icon(
                                    //                     Icons.report_rounded)),
                                    //             Text(
                                    //               'More info',
                                    //               style: TextStyle(
                                    //                   color: Colors.grey,
                                    //                   fontSize: 12),
                                    //             ),
                                    //             SizedBox(
                                    //               height: 20,
                                    //             ),
                                    //             IconButton(
                                    //                 onPressed: () {},
                                    //                 icon: Icon(Icons.map)),
                                    //             Text(
                                    //               'open in maps',
                                    //               style: TextStyle(
                                    //                   color: Colors.grey,
                                    //                   fontSize: 12),
                                    //             ),
                                    //           ],
                                    //         )
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    //],
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1.5, color: Colors.black),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent,
                              offset: const Offset(0, 0),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.black,
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: 500,
                            height: 600,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(17.434451, 78.445226),
                                initialZoom: 10,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                ),
                                MarkerLayer(
                                  markers: markers,
                                  // markers: [
                                  //   Marker(
                                  //     point: LatLng(17.434451, 78.445226),
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //         borderRadius:
                                  //             BorderRadius.circular(50),
                                  //         color: Colors.white,
                                  //       ),
                                  //       child: Icon(
                                  //         Icons.car_crash_sharp,
                                  //         color: Colors.black,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ));
  }
}
