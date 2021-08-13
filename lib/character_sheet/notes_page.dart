import 'package:flutter/material.dart';
import '../general_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesPage extends StatelessWidget {
  NotesPage({Key? key, required this.data, required this.character})
      : super(key: key);
  Map<String, dynamic> data;
  DocumentReference<Map<String, dynamic>> character;
  @override
  Widget build(BuildContext context) {
    TextEditingController _notes = TextEditingController(text: data["notes"]);
    FocusNode _focus = FocusNode();

    _focus.addListener(() {
      character.update({"notes": _notes.text});
    });
    return Column(
      children: [
        Container(
          width: percentWidth(0.55, context),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  character.set({
                    "hitpoints": data["max hit points"],
                    "spells": {"spellslots": data["spells"]["total spellslots"]}
                  }, SetOptions(merge: true));
                },
                child: const Text("Long Rest"),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Short Rest"),
              ),
            ],
          ),
        ),
        TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        content: Text("Test"),
                      ));
            },
            child: Text("Test")),
        const Spacer(),
        SizedBox(
          width: percentWidth(.9, context),
          child: TextField(
            controller: _notes,
            focusNode: textUpdator(_notes, "notes", character),
            maxLines: null,
            //keyboardType: TextInputType.multiline,
            minLines: 25,
            decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                labelText: "Notes",
                labelStyle: TextStyle(color: Colors.grey)),
          ),
        )
      ],
    );
  }
}
