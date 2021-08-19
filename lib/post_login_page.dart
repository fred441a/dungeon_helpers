// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'character_sheet/character_sheet_page.dart';
import 'group_sheet/group_sheet.dart';
import 'character_sheet/create_character_page.dart';
import 'dart:io' show Platform;
import 'package:nfc_manager/nfc_manager.dart';
import 'group_sheet/create_group_page.dart';

class PostLoginPage extends StatefulWidget {
  PostLoginPage({Key? key}) : super(key: key);

  @override
  State<PostLoginPage> createState() => _PostLoginPageState();
}

class _PostLoginPageState extends State<PostLoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void _NFCOpenCharacter(Map data) async {
    if (data["ndef"]["cachedMessage"]["records"][0]["type"][0] != 84) {
      print("Not Text NFC");
      return;
    }

    String characterId = String.fromCharCodes(
        data["ndef"]["cachedMessage"]["records"][0]["payload"]);
    characterId = characterId.replaceAll("en", "");

    DocumentSnapshot<Map<String, dynamic>> db = await FirebaseFirestore.instance
        .collection("Characters")
        .doc(characterId)
        .get();

    Map<String, dynamic> dbdata = db.data() as Map<String, dynamic>;

    if (dbdata == null) {
      print("This char does not exist!");
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                CharacterSheetPage(characterId: characterId)));
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void floatingActionButtonPress() {
    if (_tabController.index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CharacterCreationPage()));
    } else if (_tabController.index == 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CreateGroupPage());
    }
  }

  void startNfc() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      if (Platform.isAndroid) {
        NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
          _NFCOpenCharacter(tag.data);
          Future.delayed(Duration(seconds: 1)).then((value) {
            NfcManager.instance.stopSession();
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    startNfc();
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

//TODO make this 1 class that can function as just charachter and group class

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
    Stream<QuerySnapshot> _groups = FirebaseFirestore.instance
        .collection("Groups")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return StreamBuilder(
        stream: _groups,
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
                              builder: (context) => Groupsheet(
                                  groupId: snapshot.data!.docs[index].id)));
                    },
                    child: Text(snapshot.data!.docs[index]["name"]),
                  ),
                );
              });
        });
  }
}
