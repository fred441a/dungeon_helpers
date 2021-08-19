import 'package:flutter/material.dart';
import '../character_sheet/character_sheet_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_player.dart';

//TODO fix player rules so that players with different owners can be seen by dm

class PlayerPage extends StatelessWidget {
  PlayerPage({Key? key, required this.data, required this.groupData})
      : super(key: key);

  Map<String, dynamic> data;
  DocumentReference<Map<String, dynamic>> groupData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddPlayerPage(
                            groupData: groupData,
                            data: data,
                          )));
            },
            child: Text("Add Player +")),
        Expanded(
          child: ListView.builder(
            itemCount: data["members"].length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(4),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CharacterSheetPage(
                                  characterId: data["members"][index].id,
                                )));
                  },
                  child: FutureBuilder(
                    future: data["members"][index].get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Text(data["name"]);
                      }

                      return Text("loading");
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future getCharachter(String id) {
  return FirebaseFirestore.instance.collection("Groups").doc(id).get();
}
