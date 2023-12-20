import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        leading: Icon(Icons.menu_rounded),
        title: Center(child: Text('Console')),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
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

              for (QueryDocumentSnapshot document in _querySnapshot.docs) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String id = data['images'].toString() ?? 'loading..';
                String victim = data['victim'] ?? 'loading..';
                // ... (access other variables as needed)

                widgets.add(
                  ListTile(
                    title: Text('Variable 1: $id'),
                    subtitle: Text('Variable 2: $victim'),
                    // ... (add other variables to the widget)
                  ),
                );
              }

              return ListView(
                children: widgets,
              );
            }
          },
        ),
      ),
    );
  }
}
