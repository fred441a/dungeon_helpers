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
            child: Dinglebob(
              label: "HitDice",
              value: data["hit dice"],
            )),
        Row(
          children: [
            ArmorShield(
              label: "Armor",
              type: data["armor"]["name"],
              value: modifier(data["armor"]["armor class"]),
            ),
            ArmorShield(
              label: "Shield",
              type: data["shield"]["name"],
              value: modifier(data["shield"]["armor class"]),
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
      padding: EdgeInsets.all(10),
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
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  VerticalDivider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Text(
                    dmg,
                    style: TextStyle(fontSize: 18),
                  ),
                  VerticalDivider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Text(
                    type,
                    style: TextStyle(fontSize: 18),
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
      {Key? key, required this.label, required this.type, required this.value})
      : super(key: key);
  final String label;
  final String type;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: percentWidth(0.5, context),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 22),
          ),
          Container(
              width: percentWidth(0.45, context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(),
              ),
              child: Padding(
                padding: EdgeInsets.all(2),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Text(
                        type,
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      VerticalDivider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      Text(
                        value,
                        style: TextStyle(fontSize: 18),
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
