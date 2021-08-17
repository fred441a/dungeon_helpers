import 'package:flutter/material.dart';
import '../general_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_manager/nfc_manager.dart';

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
                    "hitpoints": data["max hitpoints"],
                    "spells": {"spellslots": data["spells"]["total spellslots"]}
                  }, SetOptions(merge: true));
                },
                child: const Text("Long Rest"),
              ),
              Spacer(),
              //TODO
              ElevatedButton(
                onPressed: () {},
                child: const Text("Short Rest"),
              ),
            ],
          ),
        ),
        TextButton(
            onPressed: () {
              NfcManager.instance.startSession(
                  onDiscovered: (NfcTag tag) async {
                print(tag.data);
                NfcManager.instance.stopSession();
              });
            },
            child: const Text("test")),
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
