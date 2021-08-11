import 'package:flutter/material.dart';
import '../general_functions.dart';
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
                value: data["hitpoints"] != null
                    ? data["hitpoints"].toString()
                    : 0.toString(),
                update: (value) {
                  character.set(
                      {"hitpoints": int.parse(value)}, SetOptions(merge: true));
                },
              ),
              Spacer(),
              Dinglebob(
                label: "Armor Class",
                value: data["armor class"] != null
                    ? data["armor class"].toString()
                    : 0.toString(),
                update: (value) {
                  character.set({"armor class": int.parse(value)},
                      SetOptions(merge: true));
                },
              ),
              Spacer(),
              Dinglebob(
                editable: false,
                label: "Proficiency bonus",
                value: modifier(proficiencyBonus(data["xp"])),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  PlusMinusPopUp(context, data["speed"] ?? 0, "speed")
                      .then((value) {
                    character.set({"speed": value}, SetOptions(merge: true));
                  });
                },
                child: Dinglebob(
                  editable: false,
                  label: "Speed",
                  value: data["speed"].toString() + "ft",
                ),
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
