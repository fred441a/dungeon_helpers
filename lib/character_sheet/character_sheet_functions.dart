import 'package:flutter/material.dart';

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
        return 5;
      }
    case 2:
    case 3:
      {
        return 4;
      }
    case 4:
    case 5:
      {
        return 3;
      }
    case 6:
    case 7:
      {
        return 2;
      }
    case 8:
    case 9:
      {
        return 1;
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

class Abilitymodifiers extends StatelessWidget {
  const Abilitymodifiers({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
        ClipOval(
            child: Container(
          width: percentHeight(0.08, context),
          height: percentHeight(0.08, context),
          color: const Color.fromRGBO(225, 225, 225, 1),
          child: Center(
            child: Column(
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Divider(),
                Text(
                  modifier(abilityModifier(value)),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ))
      ],
    );
  }
}
