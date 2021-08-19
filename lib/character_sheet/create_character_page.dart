import 'package:dungeonhelper/general_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'character_sheet_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CharacterCreationPage extends StatelessWidget {
  CharacterCreationPage({
    Key? key,
  }) : super(key: key);

  final TextEditingController _name = TextEditingController();
  final TextEditingController _class = TextEditingController();
  final TextEditingController _lvl = TextEditingController();
  final TextEditingController _race = TextEditingController();

  late int _str = 1;
  late int _dex = 1;
  late int _con = 1;
  late int _int = 1;
  late int _wis = 1;
  late int _cha = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Character Creator"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Text("Name: "),
              SizedBox(
                width: percentWidth(.5, context),
                child: TextField(
                  controller: _name,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("class: "),
              Sugestivesearch(
                width: percentWidth(.5, context),
                api: "classes",
                controller: _class,
              )
            ],
          ),
          Row(
            children: [
              const Text("Race: "),
              Sugestivesearch(
                width: percentWidth(.5, context),
                api: "races",
                controller: _race,
              )
            ],
          ),
          Row(
            children: [
              const Text("Starting level: "),
              SizedBox(
                width: percentWidth(.5, context),
                child: TextField(
                  controller: _lvl,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(
            height: percentHeight(.05, context),
          ),
          Row(
            children: [
              const Spacer(),
              Dinglebob(
                label: "Strength",
                value: _str.toString(),
                update: (value) {
                  print(value);
                  _str = int.parse(value);
                },
              ),
              const Spacer(),
              Dinglebob(
                label: "Dexterity",
                value: _dex.toString(),
                update: (value) {
                  _dex = int.parse(value);
                },
              ),
              const Spacer(),
              Dinglebob(
                label: "Constitution",
                value: _con.toString(),
                update: (value) {
                  _con = int.parse(value);
                },
              ),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Dinglebob(
                label: "Inteligence",
                value: _int.toString(),
                update: (value) {
                  _int = int.parse(value);
                },
              ),
              const Spacer(),
              Dinglebob(
                label: "Wisdom",
                value: _wis.toString(),
                update: (value) {
                  _wis = int.parse(value);
                },
              ),
              const Spacer(),
              Dinglebob(
                label: "Charisma",
                value: _cha.toString(),
                update: (value) {
                  _cha = int.parse(value);
                },
              ),
              const Spacer(),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DocumentReference<Map<String, dynamic>> character =
              await CreateCharSheet(
                  _name.text, _class.text, _race.text, int.parse(_lvl.text),
                  str: _str,
                  dex: _dex,
                  con: _con,
                  intel: _int,
                  wis: _wis,
                  cha: _cha);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CharacterSheetPage(characterId: character.id)));
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class Sugestivesearch extends StatefulWidget {
  Sugestivesearch(
      {Key? key,
      required this.width,
      this.api = "classes",
      required this.controller})
      : super(key: key);
  double width;
  String api;
  TextEditingController controller;

  @override
  _SugestivesearchState createState() => _SugestivesearchState();
}

class _SugestivesearchState extends State<Sugestivesearch> {
  FocusNode _focusNode = FocusNode();

  LayerLink _layerLink = LayerLink();

  late http.Response _response;
  late Map _body;

  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    http
        .get(Uri.parse("https://www.dnd5eapi.co/api/" + widget.api))
        .then((value) {
      _response = value;
      _body = jsonDecode(_response.body);
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _Overlay();
        Overlay.of(context)!.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
    super.initState();
  }

  OverlayEntry _Overlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var size = renderBox.size;
    return OverlayEntry(
        builder: (context) => Positioned(
            top: offset.dx,
            left: offset.dy,
            child: CompositedTransformFollower(
              offset: Offset(0, size.height),
              showWhenUnlinked: false,
              link: _layerLink,
              child: Material(
                elevation: 4,
                child: SizedBox(
                    height: percentHeight(.2, context),
                    width: widget.width,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _body["count"],
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                        onTap: () {
                          setState(() {
                            widget.controller.text =
                                _body["results"][index]["name"];
                          });

                          _focusNode.unfocus();
                        },
                        title: Text(_body["results"][index]["name"]),
                      ),
                    )),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.width,
        child: TextField(
          onChanged: (value) async {
            http.Response respons = await http.get(Uri.parse(
                "https://www.dnd5eapi.co/api/" +
                    widget.api +
                    "/?name=" +
                    value));
            setState(() {
              _response = respons;
              _body = jsonDecode(_response.body);
            });
            Overlay.of(context)!.setState(() {
              //_overlayEntry = _Overlay();
            });
          },
          controller: widget.controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }
}

//TODO a whole lot
//but first of all you need to set max hitpoints and max spellslots based on class and level
Future<DocumentReference<Map<String, dynamic>>> CreateCharSheet(
    String name, String dndclass, String race, int level,
    {required int str,
    required int dex,
    required int con,
    required int intel,
    required int wis,
    required int cha}) async {
  var db = FirebaseFirestore.instance.collection("Characters");

  http.Response classrespons = await http.get(Uri.parse(
      "https://www.dnd5eapi.co/api/classes/" + dndclass.toLowerCase()));

  Map classdata = {
    "name": dndclass,
    "hit_die": 8,
    "url": null,
    "spellcasting": {
      "spellcasting_ability": {"index": "cha"}
    }
  };

  if (classrespons.statusCode == 200) {
    classdata = jsonDecode(classrespons.body);
  }

  http.Response racerespons = await http.get(
      Uri.parse("https://www.dnd5eapi.co/api/races/" + race.toLowerCase()));

  Map racedata = {"name": race, "url": null, "speed": 0};

  if (racerespons.statusCode == 200) {
    racedata = jsonDecode(racerespons.body);
  }

  Map savingThrows(List data) {
    Map returnmap = {};
    data.forEach((element) {
      switch (element["index"]) {
        case "cha":
          returnmap["charisma"] = true;
          break;
        case "con":
          returnmap["constitution"] = true;
          break;
        case "dex":
          returnmap["dexterity"] = true;
          break;
        case "int":
          returnmap["inteligence"] = true;
          break;
        case "str":
          returnmap["strength"] = true;
          break;
        case "wis":
          returnmap["wisdom"] = true;
      }
    });

    returnmap["charisma"] ??= false;
    returnmap["constitution"] ??= false;
    returnmap["dexterity"] ??= false;
    returnmap["inteligence"] ??= false;
    returnmap["strength"] ??= false;
    returnmap["wisdom"] ??= false;

    return returnmap;
  }

  String ptal() {
    String returnString = "Proficiencies: \n";
    racedata["starting_proficiencies"].forEach((element) {
      returnString += element["name"] + ", ";
    });

    classdata["proficiencies"].forEach((element) {
      returnString += element["name"] + ", ";
    });

    returnString += "\n languages: \n";
    racedata["languages"].forEach((element) {
      returnString += element["name"] + ", ";
    });

    returnString += "\n traits: \n";
    racedata["traits"].forEach((element) {
      returnString += element["name"] + ", ";
    });

    return returnString;
  }

  String equipAndTres() {
    String returnString = "";
    classdata["starting_equipment"].forEach((element) {
      returnString += element["equipment"]["name"] +
          " x" +
          element["quantity"].toString() +
          "\n";
    });

    return returnString;
  }

  List<int> TotalSpellslots() {
    if (classdata["spellcasting"] != null &&
        classdata["name"] != "Paladin" &&
        classdata["name"] != "Monk" &&
        classdata["name"] != "Warlock") {
      switch (level) {
        case 1:
          return [0, 2, 0, 0, 0, 0, 0, 0, 0, 0];
        case 2:
          return [0, 3, 0, 0, 0, 0, 0, 0, 0, 0];
        case 3:
          return [0, 4, 2, 0, 0, 0, 0, 0, 0, 0];
        case 4:
          return [0, 4, 3, 0, 0, 0, 0, 0, 0, 0];
        case 5:
          return [0, 4, 3, 2, 0, 0, 0, 0, 0, 0];
        case 6:
          return [0, 4, 3, 3, 0, 0, 0, 0, 0, 0];
        case 7:
          return [0, 4, 3, 3, 1, 0, 0, 0, 0, 0];
        case 8:
          return [0, 4, 3, 3, 2, 0, 0, 0, 0, 0];
        case 9:
          return [0, 4, 3, 3, 3, 1, 0, 0, 0, 0];
        case 10:
          return [0, 4, 3, 3, 3, 2, 0, 0, 0, 0];
        case 11:
          return [0, 4, 3, 3, 3, 2, 1, 0, 0, 0];
        case 12:
          return [0, 4, 3, 3, 3, 2, 1, 0, 0, 0];
        case 13:
          return [0, 4, 3, 3, 3, 2, 1, 1, 0, 0];
        case 14:
          return [0, 4, 3, 3, 3, 2, 1, 1, 0, 0];
        case 15:
          return [0, 4, 3, 3, 3, 2, 1, 1, 1, 0];
        case 16:
          return [0, 4, 3, 3, 3, 2, 1, 1, 1, 0];
        case 17:
          return [0, 4, 3, 3, 3, 2, 1, 1, 1, 1];
        case 18:
          return [0, 4, 3, 3, 3, 3, 1, 1, 1, 1];
        case 19:
          return [0, 4, 3, 3, 3, 3, 2, 1, 1, 1];
        case 20:
          return [0, 4, 3, 3, 3, 3, 2, 2, 1, 1];
      }
    }
    return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  }

  return db.add({
    "name": name,
    "class": classdata["name"],
    "class url": "https://www.dnd5eapi.co/api/classes" + classdata["url"],
    "userId": FirebaseAuth.instance.currentUser?.uid,
    "xp": xp(level),
    "race": racedata["name"],
    "race url": "https://www.dnd5eapi.co/api/races" + racedata["url"],
    "strength": str,
    "dexterity": dex,
    "constitution": con,
    "inteligence": intel,
    "wisdom": wis,
    "charisma": cha,
    "skills": {
      "Athlectics": 1,
      "Acrobatics": 1,
      "Sleight of hand": 1,
      "Stealth": 1,
      "arcana": 1,
      "history": 1,
      "investigation": 1,
      "Nature": 1,
      "Religion": 1,
      "Animal handeling": 1,
      "Insight": 1,
      "Perception": 1,
      "Survival": 1,
      "Deception": 1,
      "Intimidation": 1,
      "Performance": 1,
      "Persuasion": 1,
    },
    "speed": racedata["speed"],
    "saving throws": savingThrows(classdata["saving_throws"]),
    "weapons": [],
    "hit dice": level.toString() + "d" + classdata["hit_die"].toString(),
    "spellcasting modifier": classdata["spellcasting"] != null
        ? classdata["spellcasting"]["spellcasting_ability"]["index"]
        : null,
    "spells": {
      "spellslots": TotalSpellslots(),
      "total spellslots": TotalSpellslots(),
      "cantrips": [],
      "level 1": [],
      "level 2": [],
      "level 3": [],
      "level 4": [],
      "level 5": [],
      "level 6": [],
      "level 7": [],
      "level 8": [],
      "level 9": [],
    },
    "ptal": ptal(),
    "equipment and treasure": equipAndTres(),
    "max hitpoints": classdata["hit_die"] + abilityModifier(con),
    "hitpoints": classdata["hit_die"] + abilityModifier(con),
  });
}
