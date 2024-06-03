import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreExample extends StatefulWidget {
  @override
  _FirestoreExampleState createState() => _FirestoreExampleState();
}

class _FirestoreExampleState extends State<FirestoreExample> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNestedCollections() async {
    try {
      // Create a reference to the first collection
      CollectionReference collection1Ref = _firestore.collection('collection1');

      // Create a document in the first collection
      DocumentReference document1Ref = collection1Ref.doc('document1');
      await document1Ref.set({'name': 'First Document'});

      // Create a subcollection in the first document
      CollectionReference collection2Ref = document1Ref.collection('collection2');

      // Create a document in the second collection
      DocumentReference document2Ref = collection2Ref.doc('document2');
      await document2Ref.set({'name': 'Second Document'});

      // Create a subcollection in the second document
      CollectionReference collection3Ref = document2Ref.collection('collection3');

      // Create a document in the third collection with a date field
      DocumentReference document3Ref = collection3Ref.doc('document3');
      await document3Ref.set({
        'name': 'Third Document',
        'date': FieldValue.serverTimestamp(),
      });

      log('Nested collections and document with date field created successfully.');
    } catch (e) {
      log("Error: $e");
    }
  }


  @override
  void initState() {
    createNestedCollections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Example"),
      ),
      body: Center(
        child: Text("Check console for Firestore operations"),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: FirestoreExample(),
));
