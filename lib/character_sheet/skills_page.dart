import 'package:flutter/material.dart';
import 'character_sheet_functions.dart';

class SkillsPage extends StatelessWidget {
  SkillsPage({Key? key, required this.data}) : super(key: key);

  Map<String, dynamic> data;

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
                value: data["hitpoints"].toString(),
              ),
              Dinglebob(
                label: "Armor Class",
                value: data["armor class"].toString(),
              ),
              Dinglebob(
                label: "Proficiency bonus",
                value: modifier(proficiencyBonus(data["xp"])),
              ),
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
