import 'package:flutter/material.dart';
import '../general_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RollerPage extends StatelessWidget {
  RollerPage({Key? key, required this.data, required this.character})
      : super(key: key);

  Map<String, dynamic> data;
  DocumentReference<Map<String, dynamic>> character;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: percentWidth(0.33, context),
            child: Column(
              children: [
                Abilitymodifiers(
                  label: "Strength",
                  value: data["strength"],
                  update: (value) {
                    character.set({"strength": int.parse(value)},
                        SetOptions(merge: true));
                  },
                ),
                Abilitymodifiers(
                  label: "Dexterity",
                  value: data["dexterity"],
                  update: (value) {
                    character.set({"dexterity": int.parse(value)},
                        SetOptions(merge: true));
                  },
                ),
                Abilitymodifiers(
                  label: "Constitution",
                  value: data["constitution"],
                  update: (value) {
                    character.set({"constitution": int.parse(value)},
                        SetOptions(merge: true));
                  },
                ),
                Abilitymodifiers(
                  label: "Inteligence",
                  value: data["inteligence"],
                  update: (value) {
                    character.set({"inteligence": int.parse(value)},
                        SetOptions(merge: true));
                  },
                ),
                Abilitymodifiers(
                  label: "Wisdom",
                  value: data["wisdom"],
                  update: (value) {
                    character.set(
                        {"wisdom": int.parse(value)}, SetOptions(merge: true));
                  },
                ),
                Abilitymodifiers(
                  label: "Charisma",
                  value: data["charisma"],
                  update: (value) {
                    character.set({"charisma": int.parse(value)},
                        SetOptions(merge: true));
                  },
                ),
              ],
            )),
        SizedBox(
            width: percentWidth(0.66, context),
            child: Column(
              children: [
                Container(
                  height: percentHeight(.5, context),
                  child: ListView.builder(
                      itemCount: data["skills"].length,
                      itemBuilder: (BuildContext context, int index) {
                        var keys = data["skills"].keys.toList()..sort();
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            PlusMinusPopUp(context, data["skills"][keys[index]],
                                    keys[index])
                                .then((value) {
                              character.set({
                                "skills": {keys[index]: value}
                              }, SetOptions(merge: true));
                            });
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(keys[index].toString()),
                                  const Spacer(),
                                  Text(modifier(data["skills"][keys[index]]))
                                ],
                              ),
                              const Divider()
                            ],
                          ),
                        );
                      }),
                ),
                const Text(
                  "Saving throws",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                SavingThrow(
                  label: "Strength",
                  data: data,
                  character: character,
                ),
                SavingThrow(
                  label: "Dexterity",
                  data: data,
                  character: character,
                ),
                SavingThrow(
                  label: "Constitution",
                  data: data,
                  character: character,
                ),
                SavingThrow(
                  label: "Inteligence",
                  data: data,
                  character: character,
                ),
                SavingThrow(
                  label: "Wisdom",
                  data: data,
                  character: character,
                ),
                SavingThrow(
                  label: "Charisma",
                  data: data,
                  character: character,
                ),
              ],
            ))
      ],
    );
  }
}

class SavingThrow extends StatelessWidget {
  SavingThrow(
      {Key? key,
      required this.label,
      required this.data,
      required this.character})
      : super(key: key);

  String label;
  Map<String, dynamic> data;
  DocumentReference<Map<String, dynamic>> character;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print("test");
        if (data["saving throws"][label.toLowerCase()]) {
          character.set({
            "saving throws": {label.toLowerCase(): false}
          }, SetOptions(merge: true));
        } else {
          character.set({
            "saving throws": {label.toLowerCase(): true}
          }, SetOptions(merge: true));
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              Text(label),
              const Spacer(),
              data["saving throws"][label.toLowerCase()]
                  ? Text(modifier(abilityModifier(data[label.toLowerCase()]) +
                      proficiencyBonus(data["xp"])))
                  : Text(modifier(abilityModifier(data[label.toLowerCase()])))
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
