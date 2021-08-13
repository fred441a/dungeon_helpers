import 'package:dungeonhelper/character_sheet/items_page.dart';
import 'package:dungeonhelper/character_sheet/notes_page.dart';
import 'package:dungeonhelper/character_sheet/skills_page.dart';
import 'package:dungeonhelper/character_sheet/spell_page.dart';
import 'package:dungeonhelper/character_sheet/weapons_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'roller_page.dart';
import '../general_functions.dart';
import 'package:nfc_manager/nfc_manager.dart';

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
                              Future.delayed(Duration(milliseconds: 10))
                                  .then((value) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text("Are you sure?!"),
                                          content: const Text(
                                              "Are you sure you want to delete this character.\n ones this character is deleted it cannot be returned"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, "Delete");
                                                  Navigator.pop(
                                                      context, "Delete");
                                                  Future.delayed(const Duration(
                                                          seconds: 1))
                                                      .then((value) {
                                                    _character.delete();
                                                  });
                                                },
                                                child: const Text("Delete")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cancel"))
                                          ],
                                        ));
                              });
                            },
                            child: const Text("Delete"),
                          ),
                          PopupMenuItem(
                            child: const Text("Write"),
                            onTap: () {
                              Future.delayed(Duration(milliseconds: 10))
                                  .then((value) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          content: SizedBox(
                                            height: percentHeight(.24, context),
                                            child: Column(
                                              children: const [
                                                Icon(
                                                  Icons.nfc,
                                                  size: 150,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                    "Place minifig on NFC chip")
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  NfcManager.instance
                                                      .stopSession();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cancel"))
                                          ],
                                        ));
                              });
                              NfcManager.instance.startSession(
                                  onDiscovered: (NfcTag tag) async {
                                var ndef = Ndef.from(tag);
                                if (ndef == null || !ndef.isWritable) {
                                  NfcManager.instance.stopSession(
                                      errorMessage: "NFC tag is not writable");
                                  Navigator.pop(context);
                                  return;
                                }
                                NdefMessage message = NdefMessage([
                                  NdefRecord.createText(_character.id),
                                ]);

                                try {
                                  await ndef.write(message);
                                  Navigator.pop(context);
                                  Future.delayed(Duration(seconds: 10))
                                      .then((value) {
                                    NfcManager.instance.stopSession();
                                  });
                                } catch (e) {
                                  NfcManager.instance
                                      .stopSession(errorMessage: e.toString());
                                  Navigator.pop(context);
                                  return;
                                }
                              });
                            },
                          ),
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
