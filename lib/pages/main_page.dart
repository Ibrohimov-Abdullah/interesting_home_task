import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CollectionScreen extends StatelessWidget {
  final String collection;

  const CollectionScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$collection Collections')),
      body: ListView(
        children: getSubCollections(collection).map((subCollection) {
          return Card(
            child: ListTile(
              title: Text(subCollection),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCollectionScreen(
                      mainCollection: collection, subCollection: subCollection),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<String> getSubCollections(String collection) {
    switch (collection) {
      case 'Buildings':
        return ['Dormitory', 'Sport', 'Classroom'];
      case 'Faculties':
        return ['International', 'Local'];
      case 'Students':
        return ['Grand', 'Contracts', 'SuperContracts'];
      default:
        return [];
    }
  }
}

class SubCollectionScreen extends StatelessWidget {
  final String mainCollection;
  final String subCollection;

  SubCollectionScreen({required this.mainCollection, required this.subCollection});

  @override
  Widget build(BuildContext context) {
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('University')
        .doc(mainCollection)
        .collection(subCollection);

    return Scaffold(
      appBar: AppBar(title: Text('$subCollection Collection')),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text(data['name'] ?? 'No Name'),
                  subtitle: Text(data['date']?.toDate().toString() ?? 'No Date'),
                  // trailing: Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     IconButton(
                  //       icon: Icon(Icons.edit),
                  //       onPressed: () => _updateDocument(context, collectionReference, document),
                  //     ),
                  //     IconButton(
                  //       icon: Icon(Icons.delete),
                  //       onPressed: () => _deleteDocument(collectionReference, document.id),
                  //     ),
                  //   ],
                  // ),
                ),
              );
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _addDocument(context, collectionReference),
      //   child: Icon(Icons.add),
      // ),
    );
  }

  void _addDocument(BuildContext context, CollectionReference collectionReference) {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Document'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await collectionReference.add({
                'name': nameController.text,
                'date': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _updateDocument(BuildContext context, CollectionReference collectionReference, DocumentSnapshot document) {
    TextEditingController nameController = TextEditingController(text: document['name']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Document'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await collectionReference.doc(document.id).update({
                'name': nameController.text,
                'date': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteDocument(CollectionReference collectionReference, String docId) {
    collectionReference.doc(docId).delete();
  }
}