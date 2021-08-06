import 'package:flutter/material.dart';
import '../general_functions.dart';

class RollerPage extends StatelessWidget {
  RollerPage({Key? key, required this.data}) : super(key: key);

  Map<String, dynamic> data;

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
                ),
                Abilitymodifiers(
                  label: "Dexterity",
                  value: data["dexterity"],
                ),
                Abilitymodifiers(
                  label: "Constitution",
                  value: data["constitution"],
                ),
                Abilitymodifiers(
                  label: "Inteligence",
                  value: data["inteligence"],
                ),
                Abilitymodifiers(
                  label: "Wisdom",
                  value: data["wisdom"],
                ),
                Abilitymodifiers(
                  label: "Charisma",
                  value: data["charisma"],
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
                        return Column(
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
                        );
                      }),
                ),
                const Text(
                  "Saving throws",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                SavingThrow(label: "Strength", data: data),
                SavingThrow(label: "Dexterity", data: data),
                SavingThrow(label: "Constitution", data: data),
                SavingThrow(label: "Inteligence", data: data),
                SavingThrow(label: "Wisdom", data: data),
                SavingThrow(label: "Charisma", data: data),
              ],
            ))
      ],
    );
  }
}

class SavingThrow extends StatelessWidget {
  SavingThrow({Key? key, required this.label, required this.data})
      : super(key: key);

  String label;
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    if (data["saving throws"][label.toLowerCase()]) {
      return Column(
        children: [
          Row(
            children: [
              Text(label),
              const Spacer(),
              Text(modifier(abilityModifier(data[label.toLowerCase()]) +
                  proficiencyBonus(data["xp"])))
            ],
          ),
          const Divider(),
        ],
      );
    }
    return Column(
      children: [
        Row(
          children: [
            Text(label),
            const Spacer(),
            Text(modifier(abilityModifier(data[label.toLowerCase()])))
          ],
        ),
        const Divider(),
      ],
    );
  }
}
