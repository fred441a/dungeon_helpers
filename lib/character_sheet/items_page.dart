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
                value: data["money"]["copper"].toString(),
              ),
              Dinglebob(
                label: "SP",
                value: data["money"]["silver"].toString(),
              ),
              Dinglebob(
                label: "EP",
                value: data["money"]["electrum"].toString(),
              ),
              Dinglebob(
                label: "GP",
                value: data["money"]["gold"].toString(),
              ),
              Dinglebob(
                label: "PP",
                value: data["money"]["platinum"].toString(),
              ),
            ],
          ),
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
