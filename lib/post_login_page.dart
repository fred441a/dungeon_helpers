// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'character_sheet/character_sheet_page.dart';

class PostLoginPage extends StatefulWidget {
  PostLoginPage({Key? key}) : super(key: key);

  @override
  State<PostLoginPage> createState() => _PostLoginPageState();
}

class _PostLoginPageState extends State<PostLoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void floatingActionButtonPress() {
    if (_tabController.index == 0) {
      print("First page");
    } else if (_tabController.index == 1) {
      print("Second page");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(child: Icon(Icons.person)),
            const Tab(
              child: Icon(Icons.people),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [const CaractersPage(), const Groups()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: floatingActionButtonPress,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CaractersPage extends StatelessWidget {
  const CaractersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _charaters = FirebaseFirestore.instance
        .collection("Characters")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return StreamBuilder(
        stream: _charaters,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(4),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CharacterSheetPage(
                                    characterId: snapshot.data!.docs[index].id,
                                  )));
                    },
                    child: Text(snapshot.data!.docs[index]["name"]),
                  ),
                );
              });
        });
  }
}

class Groups extends StatelessWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
