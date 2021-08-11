import 'package:flutter/material.dart';
import '../general_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemPage extends StatelessWidget {
  ItemPage({Key? key, required this.data, required this.character})
      : super(key: key);
  Map<String, dynamic> data;
  DocumentReference<Map<String, dynamic>> character;

  @override
  Widget build(BuildContext context) {
    TextEditingController _equipment =
        TextEditingController(text: data["equipment and treasure"]);
    return Padding(
      padding: EdgeInsetsDirectional.only(top: percentHeight(.02, context)),
      child: Column(
        children: [
          Row(
            children: [
              Dinglebob(
                label: "CP",
                value: data["money"]?["copper"] != null
                    ? data["money"]["copper"].toString()
                    : "0",
                update: (value) {
                  character.set({
                    "money": {"copper": int.parse(value)}
                  }, SetOptions(merge: true));
                },
              ),
              Dinglebob(
                label: "SP",
                value: data["money"]?["silver"] != null
                    ? data["money"]["silver"].toString()
                    : "0",
                update: (value) {
                  character.set({
                    "money": {"silver": int.parse(value)}
                  }, SetOptions(merge: true));
                },
              ),
              Dinglebob(
                label: "EP",
                value: data["money"]?["electrum"] != null
                    ? data["money"]["electrum"].toString()
                    : "0",
                update: (value) {
                  character.set({
                    "money": {"electrum": int.parse(value)}
                  }, SetOptions(merge: true));
                },
              ),
              Dinglebob(
                label: "GP",
                value: data["money"]?["gold"] != null
                    ? data["money"]["gold"].toString()
                    : "0",
                update: (value) {
                  character.set({
                    "money": {"gold": int.parse(value)}
                  }, SetOptions(merge: true));
                },
              ),
              Dinglebob(
                label: "PP",
                value: data["money"]?["platinum"] != null
                    ? data["money"]["platinum"].toString()
                    : "0",
                update: (value) {
                  character.set({
                    "money": {"platinum": int.parse(value)}
                  }, SetOptions(merge: true));
                },
              ),
            ],
          ),
          ElevatedButton(onPressed: () {}, child: Text("Convert spend")),
          Container(
              width: percentWidth(.9, context),
              child: TextField(
                controller: _equipment,
                focusNode: textUpdator(
                    _equipment, "equipment and treasure", character),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                minLines: 10,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    labelText: "Equipment & Treasure",
                    labelStyle: TextStyle(color: Colors.grey)),
              )),
        ],
      ),
    );
  }
}
