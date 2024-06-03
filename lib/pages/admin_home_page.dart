import 'package:cloud_fire_store_learning/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/cfs_service.dart';
import 'admin_main_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool loading = true;
  List list = [];
  List<Post> postList = [];

  /// refresh function
  void refresh({required bool value}) {
    setState(() {
      loading = value;
    });
  }

  Future<void> create() async {
    refresh(value: false);
    Post post = Post(
        userId: "userId",
        firstname: "firstname",
        lastname: "lastname",
        date: "date",
        content: "content"
    );
    await CFService.createCollection(collectionPath: "University", data: post.toJson(), secondPath: 'Buildings', thirdPath: 'Dormitory');
    await loadDate();
  }

  Future<void> loadDate()async{
    postList = [];
    refresh(value: false);
    list = await CFService.read(collectionPath: "University",secondPath: 'Buildings', thirdPath: 'Dormitory');
    refresh(value: true);
    for (var e in list) {
      postList.add(Post.fromJson(e.data() as Map<String, dynamic>));
    }
  }

  Future<void> remove({required String id})async{
    refresh(value: false);
    await CFService.delete(collectionPath: "Abdullah", id: id);
    await loadDate();
  }

  Future<void> update({required String id, required Post data}) async{
    refresh(value: false);
    await CFService.update(collectionPath: 'Abdullah', id: id, data: data.toJson());
    await loadDate();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(onPressed: ()async{
            await AuthService.logoutAccount();
          }, icon: const Icon(Icons.logout))
        ],
        backgroundColor: Colors.orange,
        title: const Text("PDP University",style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black
        ),),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade400.withOpacity(0.9),
        child: Column(
          children: [
            const SizedBox(height: 120,),
            Card(
              child: ListTile(
                onTap: (){},
                title: const Text("Students"),
              ),
            ),
            const SizedBox(height: 20,),
            Card(
              child: ListTile(
                onTap: (){},
                title: const Text("Faculties"),
              ),
            ),
            const SizedBox(height: 20,),
            Card(
              child: ListTile(
                onTap: (){},
                title: Text("Buildings"),
              ),
            ),
          ],
        ),
      ),
      body: loading
          ? ListView(
        children: [
          Card(
            child: ListTile(
              title: const Text('Buildings'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CollectionScreen2(collection: 'Buildings'),
                ),
              ),
            ),
          ),
          Card(child: ListTile(
            title: const Text('Faculties'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CollectionScreen2(collection: 'Faculties'),
              ),
            ),
          ),
          ),
          Card(
            child: ListTile(
              title: const Text('Students'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CollectionScreen2(collection: 'Students'),
                ),
              ),
            ),
          ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(

        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: create,
        shape: const StadiumBorder(),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
