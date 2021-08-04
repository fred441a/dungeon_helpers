import 'package:flutter/material.dart';
import 'character_sheet_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpellPage extends StatelessWidget {
  SpellPage({Key? key, required this.data, required this.character})
      : super(key: key);

  Map<String, dynamic> data;
  DocumentReference<Map<String, dynamic>> character;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: percentHeight(0.02, context),
        ),
        Row(
          children: [
            Dinglebob(
              label: "Spellcasting Ability",
              value: modifier(data["spellcasting ability"]),
            ),
            Spacer(),
            Dinglebob(
              label: "Spell Save DC",
              value: (data["spellcasting ability"] +
                      proficiencyBonus(data["xp"]) +
                      8)
                  .toString(),
            ),
            Spacer(),
            Dinglebob(
              label: "Spell Attack Bonus",
              value:
                  (data["spellcasting ability"] + proficiencyBonus(data["xp"]))
                      .toString(),
            ),
          ],
        ),
        ElevatedButton(onPressed: () {}, child: Text("Add Spell +")),
        Container(
          height: percentHeight(.60, context),
          child: ListView(
            children: [
              const Text(
                "Cantrip",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "cantrips", character: character),
              Text(
                "Level 1 - Mana: ${data["spells"]["spellslots"][1]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 1", character: character),
              Text(
                "Level 2 - Mana: ${data["spells"]["spellslots"][2]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 2", character: character),
              Text(
                "Level 3 - Mana: ${data["spells"]["spellslots"][3]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 3", character: character),
              Text(
                "Level 4 - Mana: ${data["spells"]["spellslots"][4]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 4", character: character),
              Text(
                "Level 5 - Mana: ${data["spells"]["spellslots"][5]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 5", character: character),
              Text(
                "Level 6 - Mana: ${data["spells"]["spellslots"][6]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 6", character: character),
              Text(
                "Level 7 - Mana: ${data["spells"]["spellslots"][7]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 7", character: character),
              Text(
                "Level 8 - Mana: ${data["spells"]["spellslots"][8]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 8", character: character),
              Text(
                "Level 9 - Mana: ${data["spells"]["spellslots"][9]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 9", character: character),
            ],
          ),
        )
      ],
    );
  }
}

class Spell extends StatelessWidget {
  Spell(
      {Key? key,
      required this.ability,
      required this.character,
      required this.level,
      required this.data})
      : super(key: key);

  final String ability;
  DocumentReference<Map<String, dynamic>> character;
  int level;
  Map<String, dynamic> data;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Text(ability),
        Spacer(),
        OutlinedButton(
          onPressed: () {
            var tempArray = data["spells"]["spellslots"];
            tempArray[level] = tempArray[level] - 1;
            character.set({
              "spells": {"spellslots": tempArray}
            }, SetOptions(merge: true));
          },
          child: Icon(Icons.local_fire_department),
        ),
      ],
    );
  }
}

class SpellsList extends StatelessWidget {
  SpellsList(
      {Key? key,
      required this.data,
      required this.level,
      required this.character})
      : super(key: key);
  Map<String, dynamic> data;
  String level;
  DocumentReference<Map<String, dynamic>> character;

  @override
  Widget build(BuildContext context) {
    int levelnumber;
    if (level == "cantrips") {
      levelnumber = 0;
    } else {
      levelnumber = int.parse(level.split(" ")[1]);
    }
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: data["spells"][level].length,
      itemBuilder: (BuildContext context, int index) {
        return Spell(
          ability: data["spells"][level][index],
          character: character,
          level: levelnumber,
          data: data,
        );
      },
    );
  }
}
