import 'dart:convert';

import 'package:dungeonhelper/character_sheet/character_sheet_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MonsterPage extends StatelessWidget {
  MonsterPage({Key? key, required this.data}) : super(key: key);

  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => Monstersearch()),
            child: const Text("Add monster +")),
        Expanded(
            child: ListView.builder(
                itemCount: data["monsters"].length,
                itemBuilder: (BuildContext context, int index) {
                  return Container();
                }))
      ],
    );
  }
}

class Monstersearch extends StatelessWidget {
  const Monstersearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Find the monster you are looking for"),
      content: MonsterSearchContent(),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class MonsterSearchContent extends StatefulWidget {
  const MonsterSearchContent({Key? key}) : super(key: key);

  @override
  _MonsterSearchContentState createState() => _MonsterSearchContentState();
}

class _MonsterSearchContentState extends State<MonsterSearchContent> {
  Map _monsterJson = {"count": 0, "results": []};

  void updateSearch(String search) async {
    var url = Uri.parse("http://www.dnd5eapi.co/api/monsters/?name=" + search);
    var respons = await http.get(url);
    if (this.mounted) {
      setState(() {
        _monsterJson = jsonDecode(respons.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    updateSearch("");
    return Column(children: [
      TextField(
        onChanged: updateSearch,
      ),
      Container(
        height: percentHeight(0.6, context),
        width: percentWidth(.9, context),
        child: ListView.builder(
          itemCount: _monsterJson["count"],
          itemBuilder: (BuildContext context, int index) {
            return OutlinedButton(
                onPressed: () {},
                child: Text(_monsterJson["results"][index]["name"]));
          },
        ),
      ),
    ]);
  }
}
