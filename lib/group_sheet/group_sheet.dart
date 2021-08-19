import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'players_page.dart';
import 'monster_page.dart';

class Groupsheet extends StatelessWidget {
  Groupsheet({Key? key, required this.groupId}) : super(key: key);

  String groupId;

  @override
  Widget build(BuildContext context) {
    DocumentReference<Map<String, dynamic>> _groups =
        FirebaseFirestore.instance.collection("Groups").doc(groupId);
    Stream<DocumentSnapshot> _stream = _groups.snapshots();

    return StreamBuilder(
        stream: _stream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return DefaultTabController(
            length: 6,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text(data["name"]),
                bottom: const TabBar(tabs: [
                  Tab(
                    icon: Icon(Icons.person),
                  ),
                  Tab(
                    icon: Icon(Icons.pets),
                  ),
                  Tab(icon: Icon(Icons.person_pin)),
                  Tab(
                    icon: Icon(Icons.menu),
                  ),
                  Tab(
                    icon: Icon(Icons.comment),
                  ),
                  Tab(
                    icon: Icon(Icons.description),
                  )
                ]),
              ),
              body: TabBarView(
                children: [
                  PlayerPage(
                    data: data,
                    groupData: _groups,
                  ),
                  MonsterPage(
                    data: data,
                    group: _groups,
                  ),
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ),
          );
        });
  }
}
