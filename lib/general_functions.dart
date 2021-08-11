import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

int level(int xp) {
  if (xp < 300) {
    return 1;
  } else if (xp >= 300 && xp < 900) {
    return 2;
  } else if (xp >= 900 && xp < 2700) {
    return 3;
  } else if (xp >= 2700 && xp < 6500) {
    return 4;
  } else if (xp >= 6500 && xp < 14000) {
    return 5;
  } else if (xp >= 14000 && xp < 23000) {
    return 6;
  } else if (xp >= 23000 && xp < 34000) {
    return 7;
  } else if (xp >= 34000 && xp < 48000) {
    return 8;
  } else if (xp >= 48000 && xp < 64000) {
    return 13;
  } else if (xp >= 140000 && xp < 165000) {
    return 14;
  } else if (xp >= 165000 && xp < 195000) {
    return 15;
  } else if (xp >= 195000 && xp < 225000) {
    return 16;
  } else if (xp >= 225000 && xp < 265000) {
    return 17;
  } else if (xp >= 265000 && xp < 305000) {
    return 18;
  } else if (xp >= 305000 && xp < 355000) {
    return 19;
  } else if (xp > 355000) {
    return 20;
  }
  throw Exception("Incorrect xp value");
}

int proficiencyBonus(int xp) {
  if (level(xp) < 5) {
    return 2;
  } else if (level(xp) >= 5 && level(xp) < 9) {
    return 3;
  } else if (level(xp) >= 9 && level(xp) < 13) {
    return 4;
  } else if (level(xp) >= 13 && level(xp) < 17) {
    return 5;
  } else if (level(xp) > 17) {
    return 6;
  }
  throw Exception("Something went wrong in the profeciency bonus function");
}

String modifier(int modifier) {
  if (modifier >= 0) {
    return "+" + modifier.toString();
  }
  return modifier.toString();
}

int abilityModifier(int ability) {
  switch (ability) {
    case 1:
      {
        return -5;
      }
    case 2:
    case 3:
      {
        return -4;
      }
    case 4:
    case 5:
      {
        return -3;
      }
    case 6:
    case 7:
      {
        return -2;
      }
    case 8:
    case 9:
      {
        return -1;
      }
    case 10:
    case 11:
      {
        return 0;
      }
    case 12:
    case 13:
      {
        return 1;
      }
    case 14:
    case 15:
      {
        return 2;
      }
    case 16:
    case 17:
      {
        return 3;
      }
    case 18:
    case 19:
      {
        return 4;
      }
    case 20:
    case 21:
      {
        return 5;
      }
    case 22:
    case 23:
      {
        return 6;
      }
    case 24:
    case 25:
      {
        return 7;
      }
    case 26:
    case 27:
      {
        return 8;
      }
    case 28:
    case 29:
      {
        return 9;
      }
    case 30:
      {
        return 10;
      }
  }
  throw Exception("ability score has to be between 1 and 30");
}

double percentWidth(double percent, BuildContext context) {
  return MediaQuery.of(context).size.width * percent;
}

double percentHeight(double percent, BuildContext context) {
  return MediaQuery.of(context).size.height * percent;
}

void emptyfunc(value) {}

//TODO fix so you cant enter dicmal numbers (cause that shit breaks the code)

class Abilitymodifiers extends StatelessWidget {
  Abilitymodifiers(
      {Key? key,
      required this.label,
      required this.value,
      this.fontSize = 18,
      this.heigth = 0.08,
      this.width = 0.08,
      this.labelfontsize = 22,
      this.update = emptyfunc})
      : super(key: key);

  final String label;
  final int value;
  double fontSize;
  double labelfontsize;
  double heigth;
  double width;

  void Function(String) update;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelfontsize,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/ability_modifier.png"))),
          width: percentHeight(heigth, context),
          height: percentHeight(width, context),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextEdit(
                  value.toString(),
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                  update: update,
                  inputType: TextInputType.number,
                ),
                Text(
                  modifier(abilityModifier(value)),
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Dinglebob extends StatelessWidget {
  Dinglebob(
      {Key? key,
      required this.label,
      required this.value,
      this.update = emptyfunc,
      this.editable = true})
      : super(key: key);

  final String label;
  final String value;
  bool editable;

  void Function(String) update;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: percentWidth(0.20, context),
        height: percentHeight(0.15, context),
        child: Center(
          child: Column(
            children: [
              ClipOval(
                  child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/dinglebob.png"),
                )),
                width: percentHeight(0.06, context),
                height: percentHeight(0.06, context),
                child: Center(
                  child: editable
                      ? TextEdit(
                          value,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          update: update,
                          inputType: TextInputType.number,
                        )
                      : Text(
                          value,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                ),
              )),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }
}

FocusNode textUpdator(TextEditingController _controller, String _dataname,
    DocumentReference<Map<String, dynamic>> _character) {
  FocusNode _focus = FocusNode();
  _focus.addListener(() {
    _character.update({_dataname: _controller.text});
  });
  return _focus;
}

class MiniSheet extends StatelessWidget {
  MiniSheet({Key? key, required this.data}) : super(key: key);
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["name"]),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Container(
              height: 50,
              child: Container(
                width: percentWidth(1, context),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${data['size']} ${data['type']}, ${data['alignment']}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              )),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: percentHeight(0.02, context)),
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Armor Class "),
                  Text(data["armor_class"].toString())
                ],
              ),
              Row(
                children: [
                  const Text("HitPoints "),
                  Text("${data['hit_points']} (${data['hit_dice']})")
                ],
              ),
              Row(
                children: [
                  const Text("Speed: "),
                  Text(data["speed"]
                      .toString()
                      .replaceAll("{", " ")
                      .replaceAll("}", " "))
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Spacer(),
                  Abilitymodifiers(
                    label: "Str",
                    value: data["strength"],
                    width: 0.06,
                    heigth: 0.06,
                    labelfontsize: 14,
                    fontSize: 10,
                  ),
                  const Spacer(),
                  Abilitymodifiers(
                    label: "Dex",
                    value: data["dexterity"],
                    width: 0.06,
                    heigth: 0.06,
                    labelfontsize: 14,
                    fontSize: 10,
                  ),
                  const Spacer(),
                  Abilitymodifiers(
                    label: "Con",
                    value: data["constitution"],
                    width: 0.06,
                    heigth: 0.06,
                    labelfontsize: 14,
                    fontSize: 10,
                  ),
                  const Spacer(),
                  Abilitymodifiers(
                    label: "Int",
                    value: data["intelligence"],
                    width: 0.06,
                    heigth: 0.06,
                    labelfontsize: 14,
                    fontSize: 10,
                  ),
                  const Spacer(),
                  Abilitymodifiers(
                    label: "Wis",
                    value: data["wisdom"],
                    width: 0.06,
                    heigth: 0.06,
                    labelfontsize: 14,
                    fontSize: 10,
                  ),
                  const Spacer(),
                  Abilitymodifiers(
                    label: "Char",
                    value: data["charisma"],
                    width: 0.06,
                    heigth: 0.06,
                    labelfontsize: 14,
                    fontSize: 10,
                  ),
                  const Spacer(),
                ],
              ),
              const Divider(),
              const Text("Proficiencies"),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data["proficiencies"].length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                      "${data['proficiencies'][index]['proficiency']['name']}  " +
                          modifier(data['proficiencies'][index]['value']));
                },
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data["senses"].length,
                itemBuilder: (BuildContext context, int index) {
                  List<String> senses = [];
                  data["senses"].forEach((k, v) => senses.add(
                      k.toString().replaceAll("_", " ") + ": " + v.toString()));
                  return Text(senses[index]);
                },
              ),
              Row(
                children: [const Text("Languages "), Text(data["languages"])],
              ),
              Row(
                children: [
                  Text("Challenge "),
                  Text("${data['challenge_rating']} (${data['xp']} XP)")
                ],
              ),
              const Divider(),
              data["special_abilities"] != null
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data["special_abilities"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Text(data["special_abilities"][index]["name"]),
                            Text(data["special_abilities"][index]["desc"]),
                            const Text("")
                          ],
                        );
                      },
                    )
                  : Text("nothing here"),
              Divider(),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data["actions"].length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Text(data["actions"][index]["name"]),
                      Text(data["actions"][index]["desc"]),
                      const Text("")
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextEdit extends StatelessWidget {
  TextEdit(String this.value,
      {Key? key,
      this.alignment = TextAlign.center,
      required this.update,
      this.style = const TextStyle(),
      this.inputType = TextInputType.text})
      : super(key: key);
  TextAlign alignment;
  late TextEditingController _controller;
  String value;
  void Function(String) update;
  TextStyle style;
  TextInputType inputType;

  FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(text: value);

    _focus.addListener(() {
      update(_controller.text);
    });

    return TextField(
      style: style,
      focusNode: _focus,
      controller: _controller,
      decoration: null,
      textAlign: alignment,
      keyboardType: inputType,
    );
  }
}

Future<int> PlusMinusPopUp(BuildContext context, int value, String label) {
  var completer = Completer<int>();
  int returnval = value;

  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(label),
            content: PlusMinusInput(
              value: value,
              onChanged: (int newval) {
                returnval = newval;
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    completer.complete(returnval);
                    Navigator.pop(context, "done");
                  },
                  child: Text("done"))
            ],
          ));

  return completer.future;
}

class PlusMinusInput extends StatefulWidget {
  PlusMinusInput({Key? key, required this.value, required this.onChanged})
      : super(key: key);
  int value;

  void Function(int) onChanged;

  @override
  _PlusMinusInputState createState() => _PlusMinusInputState();
}

class _PlusMinusInputState extends State<PlusMinusInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              setState(() {
                widget.value++;
              });
              widget.onChanged(widget.value);
            },
            child: Text("+")),
        Text(widget.value.toString()),
        TextButton(
            onPressed: () {
              setState(() {
                widget.value--;
              });
              widget.onChanged(widget.value);
            },
            child: Text("-"))
      ],
    );
  }
}

Future<String> DiceSelector(BuildContext context, String value, String label) {
  var completer = Completer<String>();
  TextEditingController _amountofDice =
      TextEditingController(text: value.split("d")[0]);
  TextEditingController _sidesofDice =
      TextEditingController(text: value.split("d")[1]);

  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(label),
            content: Container(
              width: percentWidth(.8, context),
              child: Row(
                children: [
                  Container(
                    width: percentWidth(.1, context),
                    child: TextField(
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      controller: _amountofDice,
                    ),
                  ),
                  const Text("d"),
                  Container(
                    width: percentWidth(.1, context),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _sidesofDice,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    completer
                        .complete(_amountofDice.text + "d" + _sidesofDice.text);
                    Navigator.pop(context, "done");
                  },
                  child: Text("done"))
            ],
          ));

  return completer.future;
}
