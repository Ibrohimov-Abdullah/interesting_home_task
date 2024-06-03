import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CollectionScreen2 extends StatelessWidget {
  final String collection;

  const CollectionScreen2({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: Text('$collection Collections')),
      body: ListView(
        children: getSubCollections(collection).map((subCollection) {
          return Card(
            child: ListTile(
              title: Text(subCollection),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCollectionScreen2(
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

class SubCollectionScreen2 extends StatelessWidget {
  final String mainCollection;
  final String subCollection;

  const SubCollectionScreen2(
      {super.key, required this.mainCollection, required this.subCollection});

  @override
  Widget build(BuildContext context) {
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('University')
        .doc(mainCollection)
        .collection(subCollection);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.orange,
          title: Text('$subCollection Collection')),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Card(
                  child: ListTile(
                leading: Text("${data['surname']}\naddress: ${data['address']}" ?? "No Surname"),
                title: Text(data['name'] ?? 'No Name'),
                subtitle: Text(data['date']?.toDate().toString() ?? 'No Date'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _updateDocument(
                          context, collectionReference, document),
                    ),
                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const Text(
                                            "Are you sure to delete it ?"),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  _deleteDocument(
                                                      collectionReference,
                                                      document.id);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("delete")),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("No thanks")),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ));
                        }),
                  ],
                ),
              ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        shape: const StadiumBorder(),
        onPressed: () => _addDocument(context, collectionReference),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _addDocument(
      BuildContext context, CollectionReference collectionReference) {
    TextEditingController nameController = TextEditingController();
    TextEditingController surnameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: surnameController,
              decoration: const InputDecoration(labelText: 'Surname'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
          ],
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
                'surname': surnameController.text,
                'address': addressController.text,
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

  void _updateDocument(BuildContext context,
      CollectionReference collectionReference, DocumentSnapshot document) {
    TextEditingController nameController =
        TextEditingController(text: document['name']);
    TextEditingController surnameController = TextEditingController(text: document['surname']);
    TextEditingController addressController = TextEditingController(text: document['address']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: surnameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await collectionReference.doc(document.id).update({
                'name': nameController.text,
                'date': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteDocument(CollectionReference collectionReference, String docId) {
    collectionReference.doc(docId).delete();
  }
}
