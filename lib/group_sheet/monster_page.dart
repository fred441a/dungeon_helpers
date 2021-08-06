import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dungeonhelper/general_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

// TODO add a way to delet monsters
// make monsters editable

class MonsterPage extends StatelessWidget {
  MonsterPage({Key? key, required this.data, required this.group})
      : super(key: key);

  Map<String, dynamic> data;
  DocumentReference<Map<String, dynamic>> group;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => Monstersearch(
                      group: group,
                      data: data,
                    )),
            child: const Text("Add monster +")),
        Expanded(
            child: ListView.builder(
                itemCount: data["monsters"].length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Container(
                        width: percentWidth(.8, context),
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MiniSheet(
                                            data: data["monsters"][index],
                                          )));
                            },
                            child: Text(data["monsters"][index]["name"])),
                      ),
                      Container(
                        width: percentWidth(.2, context),
                        child: ElevatedButton(
                          child: Icon(Icons.delete),
                          onPressed: () {
                            List tempArray = data["monsters"];
                            tempArray.removeAt(index);
                            group.set({"monsters": tempArray},
                                SetOptions(merge: true));
                          },
                        ),
                      )
                    ],
                  );
                }))
      ],
    );
  }
}

class Monstersearch extends StatelessWidget {
  Monstersearch({Key? key, required this.group, required this.data})
      : super(key: key);
  DocumentReference<Map<String, dynamic>> group;
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Find the monster you are looking for"),
      content: MonsterSearchContent(group: group, data: data),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class MonsterSearchContent extends StatefulWidget {
  MonsterSearchContent({Key? key, required this.group, required this.data})
      : super(key: key);
  DocumentReference<Map<String, dynamic>> group;
  Map<String, dynamic> data;

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

  String nestedArrayRemover(String jsoninput) {
    jsoninput = jsoninput.replaceAll("[[", "[");
    jsoninput = jsoninput.replaceAll("]]", "]");
    return jsoninput;
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  var respons = await http.get(Uri.parse(
                      "http://www.dnd5eapi.co" +
                          _monsterJson["results"][index]["url"]));
                  var temparray = widget.data["monsters"];
                  temparray.add(jsonDecode(nestedArrayRemover(respons.body)));
                  widget.group
                      .set({"monsters": temparray}, SetOptions(merge: true));
                  Navigator.pop(context);
                },
                child: Text(_monsterJson["results"][index]["name"]));
          },
        ),
      ),
    ]);
  }
}
