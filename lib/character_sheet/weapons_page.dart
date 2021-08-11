import 'package:flutter/material.dart';
import '../general_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeaponsPage extends StatelessWidget {
  WeaponsPage({Key? key, required this.data, required this.character})
      : super(key: key);

  DocumentReference<Map<String, dynamic>> character;
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    TextEditingController _attacks =
        TextEditingController(text: data["attacks and ammunition"]);
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: percentHeight(0.02, context)),
            child: GestureDetector(
              onTap: () {
                DiceSelector(context, data["hit dice"], "Hit dice")
                    .then((value) {
                  character.set({"hit dice": value}, SetOptions(merge: true));
                });
              },
              child: Dinglebob(
                editable: false,
                label: "Hit dice",
                value: data["hit dice"],
              ),
            )),
        Row(
          children: [
            ArmorShield(
              label: "Armor",
              type: data["armor"]?["name"] ?? "Nothing equipt",
              value: modifier(data["armor"]?["armor class"] ?? 0),
            ),
            ArmorShield(
              label: "Shield",
              type: data["shield"]?["name"] ?? "Nothing equipt",
              value: modifier(data["shield"]?["armor class"] ?? 0),
            )
          ],
        ),
        Container(
            height: percentHeight(.25, context),
            child: ListView.builder(
              itemCount: data["weapons"].length,
              itemBuilder: (BuildContext context, int index) {
                return Weapons(
                    weapon: data["weapons"][index]["name"],
                    dmg: data["weapons"][index]["dice"],
                    type: data["weapons"][index]["damage type"]);
              },
            )),
        Container(
          width: percentWidth(0.9, context),
          child: TextField(
            controller: _attacks,
            focusNode:
                textUpdator(_attacks, "attacks and ammunition", character),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            minLines: 9,
            decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                labelText: "Attacks & Ammunition",
                labelStyle: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}

class Ammo extends StatelessWidget {
  const Ammo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: percentWidth(0.70, context),
            child: TextField(),
          ),
          VerticalDivider(),
          Container(
            width: percentWidth(0.20, context),
            child: TextField(),
          )
        ],
      ),
    );
  }
}

class Weapons extends StatelessWidget {
  const Weapons(
      {Key? key, required this.weapon, required this.dmg, required this.type})
      : super(key: key);
  final String weapon;
  final String dmg;
  final String type;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Text(
                    weapon,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  const VerticalDivider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Text(
                    dmg,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Text(
                    type,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class ArmorShield extends StatelessWidget {
  const ArmorShield(
      {Key? key,
      required this.label,
      this.type = "nothing equipt",
      this.value = "0d0"})
      : super(key: key);
  final String label;
  final String type;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: percentWidth(0.5, context),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 22),
          ),
          Container(
              width: percentWidth(0.45, context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Text(
                        type,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const VerticalDivider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      Text(
                        value,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
