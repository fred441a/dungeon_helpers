import 'package:dungeonhelper/character_sheet/items_page.dart';
import 'package:dungeonhelper/character_sheet/notes_page.dart';
import 'package:dungeonhelper/character_sheet/skills_page.dart';
import 'package:dungeonhelper/character_sheet/spell_page.dart';
import 'package:dungeonhelper/character_sheet/weapons_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'roller_page.dart';
import '../general_functions.dart';

class CharacterSheetPage extends StatelessWidget {
  const CharacterSheetPage({Key? key, required this.characterId})
      : super(key: key);
  final String characterId;

  @override
  Widget build(BuildContext context) {
    DocumentReference<Map<String, dynamic>> _character =
        FirebaseFirestore.instance.collection("Characters").doc(characterId);
    Stream<DocumentSnapshot> _stream = _character.snapshots();

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
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${data["name"]} - ${level(data["xp"])}"),
                        Text("${data["race"]}, ${data["class"]}")
                      ],
                    ),
                    Spacer(),
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: "Delete",
                            onTap: () {
                              Navigator.pop(context, "Delete");
                              _character.delete();
                            },
                            child: const Text("Delete"),
                          )
                        ];
                      },
                    )
                  ],
                ),
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
                  RollerPage(
                    data: data,
                    character: _character,
                  ),
                  SkillsPage(
                    data: data,
                    character: _character,
                  ),
                  WeaponsPage(
                    data: data,
                    character: _character,
                  ),
                  ItemPage(
                    data: data,
                    character: _character,
                  ),
                  SpellPage(
                    data: data,
                    character: _character,
                  ),
                  NotesPage(
                    data: data,
                    character: _character,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
