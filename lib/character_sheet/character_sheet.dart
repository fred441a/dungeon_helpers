import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'roller_page.dart';

class CharacterSheet extends StatelessWidget {
  const CharacterSheet({Key? key, required this.characterId}) : super(key: key);
  final String characterId;

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _character = FirebaseFirestore.instance
        .collection("Characters")
        .doc(characterId)
        .snapshots();

    return StreamBuilder(
        stream: _character,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return DefaultTabController(
            length: 6,
            child: Scaffold(
              appBar: AppBar(
                title: Text(data["name"]),
                bottom: const TabBar(tabs: [
                  Tab(
                    icon: Icon(Icons.casino),
                  ),
                  Tab(
                    icon: Icon(Icons.menu_book),
                  ),
                  Tab(icon: Icon(Icons.hardware)),
                  Tab(
                    icon: Icon(Icons.local_mall),
                  ),
                  Tab(
                    icon: Icon(Icons.auto_fix_high),
                  ),
                  Tab(
                    icon: Icon(Icons.description),
                  )
                ]),
              ),
              body: TabBarView(
                children: [
                  RollerPage(),
                  Container(),
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
