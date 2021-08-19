import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGroupPage extends StatelessWidget {
  CreateGroupPage({Key? key}) : super(key: key);
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create group"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "Name of group"),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              var db = FirebaseFirestore.instance.collection("Groups");
              db.add({
                "name": _controller.text,
                "userId": FirebaseAuth.instance.currentUser?.uid,
                "members": [],
                "monsters": []
              });
              Navigator.pop(context);
            },
            child: const Text("Add")),
      ],
    );
  }
}
