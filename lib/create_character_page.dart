import 'package:dungeonhelper/general_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'character_sheet/character_sheet_page.dart';

class CharacterCreationPage extends StatelessWidget {
  CharacterCreationPage({
    Key? key,
  }) : super(key: key);

  final TextEditingController _name = TextEditingController();
  final TextEditingController _class = TextEditingController();
  final TextEditingController _lvl = TextEditingController();
  final TextEditingController _race = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Character Creator"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Text("Name: "),
              SizedBox(
                width: percentWidth(.5, context),
                child: TextField(
                  controller: _name,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("class: "),
              SizedBox(
                width: percentWidth(.5, context),
                child: TextField(
                  controller: _class,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Race: "),
              SizedBox(
                width: percentWidth(.5, context),
                child: TextField(
                  controller: _race,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Starting level: "),
              SizedBox(
                width: percentWidth(.5, context),
                child: TextField(
                  controller: _lvl,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DocumentReference<Map<String, dynamic>> character =
              await CreateCharSheet(
                  _name.text, _class.text, _race.text, int.parse(_lvl.text));

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CharacterSheetPage(characterId: character.id)));
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

//TODO a whole lot
//but first of all you need to set max hitpoints and max spellslots based on class and level
Future<DocumentReference<Map<String, dynamic>>> CreateCharSheet(
    String name, String dndclass, String race, int xp) {
  var db = FirebaseFirestore.instance.collection("Characters");

  return db.add({
    "name": name,
    "class": dndclass,
    "userId": FirebaseAuth.instance.currentUser?.uid,
    "xp": xp,
    "race": race,
    "strength": 1,
    "dexterity": 1,
    "constitution": 1,
    "inteligence": 1,
    "wisdom": 1,
    "charisma": 1,
    "skills": {
      "Athlectics": 1,
      "Acrobatics": 1,
      "Sleight of hand": 1,
      "Stealth": 1,
      "arcana": 1,
      "history": 1,
      "investigation": 1,
      "Nature": 1,
      "Religion": 1,
      "Animal handeling": 1,
      "Insight": 1,
      "Perception": 1,
      "Survival": 1,
      "Deception": 1,
      "Intimidation": 1,
      "Performance": 1,
      "Persuasion": 1,
    },
    "saving throws": {
      "strength": false,
      "dexterity": false,
      "constitution": false,
      "inteligence": false,
      "wisdom": false,
      "charisma": false,
    },
    "weapons": [],
    "hit dice": "1d8",
    "spellcasting ability": 1,
    "spells": {
      "spellslots": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      "cantrips": [],
      "level 1": [],
      "level 2": [],
      "level 3": [],
      "level 4": [],
      "level 5": [],
      "level 6": [],
      "level 7": [],
      "level 8": [],
      "level 9": [],
    }
  });
}
