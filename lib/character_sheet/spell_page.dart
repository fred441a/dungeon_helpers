import 'package:flutter/material.dart';
import '../general_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpellPage extends StatelessWidget {
  SpellPage({Key? key, required this.data, required this.character})
      : super(key: key);

  Map<String, dynamic> data;
  DocumentReference<Map<String, dynamic>> character;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: percentHeight(0.02, context),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                //TODO make spellcasting ability automatic with class select
                PlusMinusPopUp(context, data["spellcasting ability"],
                        "Spellcasting Ability")
                    .then((value) {
                  character.set(
                      {"spellcasting ability": value}, SetOptions(merge: true));
                });
              },
              child: Dinglebob(
                editable: false,
                label: "Spellcasting Ability",
                value: modifier(data["spellcasting ability"]),
              ),
            ),
            Spacer(),
            Dinglebob(
              label: "Spell Save DC",
              editable: false,
              value: (data["spellcasting ability"] +
                      proficiencyBonus(data["xp"]) +
                      8)
                  .toString(),
            ),
            Spacer(),
            Dinglebob(
              label: "Spell Attack Bonus",
              editable: false,
              value:
                  (data["spellcasting ability"] + proficiencyBonus(data["xp"]))
                      .toString(),
            ),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => SpellAdder(
                        character: character,
                        data: data,
                      ));
            },
            child: Text("Add Spell +")),
        Container(
          height: percentHeight(.60, context),
          child: ListView(
            children: [
              const Text(
                "Cantrip",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "cantrips", character: character),
              Text(
                "Level 1 - Spellslots: ${data["spells"]["spellslots"][1]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 1", character: character),
              Text(
                "Level 2 - Spellslots: ${data["spells"]["spellslots"][2]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 2", character: character),
              Text(
                "Level 3 - Spellslots: ${data["spells"]["spellslots"][3]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 3", character: character),
              Text(
                "Level 4 - Spellslots: ${data["spells"]["spellslots"][4]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 4", character: character),
              Text(
                "Level 5 - Spellslots: ${data["spells"]["spellslots"][5]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 5", character: character),
              Text(
                "Level 6 - Spellslots: ${data["spells"]["spellslots"][6]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 6", character: character),
              Text(
                "Level 7 - Spellslots: ${data["spells"]["spellslots"][7]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 7", character: character),
              Text(
                "Level 8 - Spellslots: ${data["spells"]["spellslots"][8]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 8", character: character),
              Text(
                "Level 9 - Spellslots: ${data["spells"]["spellslots"][9]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SpellsList(data: data, level: "level 9", character: character),
            ],
          ),
        )
      ],
    );
  }
}

class Spell extends StatelessWidget {
  Spell(
      {Key? key,
      required this.ability,
      required this.character,
      required this.level,
      required this.data,
      required this.url})
      : super(key: key);

  final String ability;
  DocumentReference<Map<String, dynamic>> character;
  int level;
  Map<String, dynamic> data;
  String url;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SpellSheet(url: url)));
            },
            child: Text(ability)),
        Spacer(),
        OutlinedButton(
          onPressed: () {
            var tempArray = data["spells"]["spellslots"];
            tempArray[level] = tempArray[level] - 1;
            character.set({
              "spells": {"spellslots": tempArray}
            }, SetOptions(merge: true));
          },
          child: Icon(Icons.local_fire_department),
        ),
      ],
    );
  }
}

class SpellSheet extends StatelessWidget {
  SpellSheet({Key? key, required this.url}) : super(key: key);
  String url;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
        future: http.get(Uri.parse(url)),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            Map data = jsonDecode(snapshot.data!.body);
            return Scaffold(
              appBar: AppBar(
                title: Text(data["name"]),
              ),
              body: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Casting time: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(data["casting_time"])
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Range: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(data["range"])
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Components: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(data["components"].toString())
                    ],
                  ),
                  data["material"] != null
                      ? Row(
                          children: [
                            const Text(
                              "Material: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Flexible(child: Text(data["material"]))
                          ],
                        )
                      : Container(),
                  Row(
                    children: [
                      const Text(
                        "Duration: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(data["duration"])
                    ],
                  ),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data["desc"][0]),
                  const Text(
                    "At Higher Levels",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  data["higher_level"] != null
                      ? Text(data["higher_level"][0])
                      : const Text("Nothing happens at a higher level"),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("ERROR"),
              ),
              body: Text(snapshot.error.toString()),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("loading..."),
            ),
            body: Text("Loading..."),
          );
        });
  }
}

class SpellsList extends StatelessWidget {
  SpellsList(
      {Key? key,
      required this.data,
      required this.level,
      required this.character})
      : super(key: key);
  Map<String, dynamic> data;
  String level;
  DocumentReference<Map<String, dynamic>> character;

  @override
  Widget build(BuildContext context) {
    int levelnumber;
    if (level == "cantrips") {
      levelnumber = 0;
    } else {
      levelnumber = int.parse(level.split(" ")[1]);
    }
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: data["spells"][level].length,
      itemBuilder: (BuildContext context, int index) {
        return Spell(
          ability: data["spells"][level][index]["name"],
          url: data["spells"][level][index]["url"],
          character: character,
          level: levelnumber,
          data: data,
        );
      },
    );
  }
}

class SpellAdder extends StatefulWidget {
  SpellAdder({Key? key, required this.character, required this.data})
      : super(key: key);
  DocumentReference<Map<String, dynamic>> character;
  Map<String, dynamic> data;

  @override
  State<SpellAdder> createState() => _SpellAdderState();
}

class _SpellAdderState extends State<SpellAdder> {
  Map _json = {"count": 0, "results": []};

  void updateSearch(String search) async {
    var url = Uri.parse("http://www.dnd5eapi.co/api/spells/?name=" + search);
    var respons = await http.get(url);
    if (this.mounted) {
      setState(() {
        _json = jsonDecode(respons.body);
      });
    }
  }

  @override
  initState() {
    updateSearch("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Spells"),
      content: Column(
        children: [
          SizedBox(
            width: percentWidth(0.8, context),
            child: TextField(
              onChanged: updateSearch,
            ),
          ),
          Container(
            height: percentHeight(0.65, context),
            width: percentWidth(.7, context),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _json["count"],
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: percentWidth(.45, context),
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SpellSheet(
                                              url: "http://www.dnd5eapi.co" +
                                                  _json["results"][index]
                                                      ["url"])));
                            },
                            child: Text(_json["results"][index]["name"])),
                      ),
                      SizedBox(
                        width: percentWidth(0.2, context),
                        child: ElevatedButton(
                            onPressed: () async {
                              var _respons = await http.get(Uri.parse(
                                  "http://www.dnd5eapi.co" +
                                      _json["results"][index]["url"]));
                              Map _spells = jsonDecode(_respons.body);

                              if (_spells["level"] == 0) {
                                List tempArray =
                                    widget.data["spells"]["cantrips"] ?? [];

                                tempArray.add({
                                  "name": _json["results"][index]["name"],
                                  "url": "http://www.dnd5eapi.co" +
                                      _json["results"][index]["url"]
                                });
                                widget.character.set({
                                  "spells": {"cantrips": tempArray}
                                }, SetOptions(merge: true));
                              } else {
                                List tempArray = widget.data["spells"][
                                        "level " +
                                            _spells["level"].toString()] ??
                                    [];
                                tempArray.add({
                                  "name": _json["results"][index]["name"],
                                  "url": "http://www.dnd5eapi.co" +
                                      _json["results"][index]["url"]
                                });
                                widget.character.set({
                                  "spells": {
                                    "level " + _spells["level"].toString():
                                        tempArray
                                  }
                                }, SetOptions(merge: true));
                              }
                            },
                            child: Text("add")),
                      ),
                    ],
                  );
                }),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, "cancle");
            },
            child: Text("Cancle"))
      ],
    );
  }
}
