import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlert_console/consoleScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void fetchData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Accessing the collection
    CollectionReference reportsCollection = firestore.collection('reports');

    // Getting documents from the collection
    QuerySnapshot querySnapshot = await reportsCollection.get();
    print(querySnapshot.size);

    // Accessing each document in the collection
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      // Accessing data within the document
      Object? userData = documentSnapshot.data();
      print("---------------------*----------------");
      print('Report ID: ${documentSnapshot.id}, Data: $userData');
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
        home: Console());
  }
}
