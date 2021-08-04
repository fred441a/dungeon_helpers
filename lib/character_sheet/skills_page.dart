import 'package:flutter/material.dart';
import 'character_sheet_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SkillsPage extends StatelessWidget {
  SkillsPage({Key? key, required this.data, required this.character})
      : super(key: key);

  Map<String, dynamic> data;
  DocumentReference<Map<String, dynamic>> character;

  @override
  Widget build(BuildContext context) {
    TextEditingController _skills = TextEditingController(text: data["ptal"]);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: percentHeight(0.02, context)),
          child: Row(
            children: [
              Dinglebob(
                label: "Hitpoints",
                value: data["current hit points"].toString(),
              ),
              Spacer(),
              Dinglebob(
                label: "Armor Class",
                value: data["armor class"].toString(),
              ),
              Spacer(),
              Dinglebob(
                label: "Proficiency bonus",
                value: modifier(proficiencyBonus(data["xp"])),
              ),
              Spacer(),
              Dinglebob(
                label: "Speed",
                value: data["speed"].toString() + "ft",
              )
            ],
          ),
        ),
        SizedBox(
          width: percentWidth(.9, context),
          child: TextField(
            controller: _skills,
            focusNode: textUpdator(_skills, "ptal", character),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            minLines: 20,
            decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                labelText: "Proficiencies,Traits, Abilities, Languguages",
                labelStyle: TextStyle(color: Colors.grey)),
          ),
        )
      ],
    );
  }
}
