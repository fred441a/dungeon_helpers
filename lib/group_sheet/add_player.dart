import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_manager/nfc_manager.dart';

class AddPlayerPage extends StatefulWidget {
  AddPlayerPage({Key? key, required this.groupData, required this.data})
      : super(key: key);
  DocumentReference<Map<String, dynamic>> groupData;
  Map<String, dynamic> data;

  @override
  State<AddPlayerPage> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late Barcode result;

  late QRViewController controller;

  bool _usecamera = true;

  @override
  void initState() {
    NFCAvailable();
    super.initState();
  }

  void NFCAvailable() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      if (Platform.isAndroid) {
        NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
          if (tag.data["ndef"]["cachedMessage"]["records"][0]["type"][0] !=
              84) {
            print("Not Text NFC");
            return;
          }

          String characterId = String.fromCharCodes(
              tag.data["ndef"]["cachedMessage"]["records"][0]["payload"]);
          characterId = characterId.replaceAll("en", "");

          AddCharacter(characterId);
          Future.delayed(Duration(seconds: 1)).then((value) {
            NfcManager.instance.stopSession();
          });
        });
      }
      setState(() {
        _usecamera = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a player to the group"),
      ),
      body: _usecamera
          ? QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            )
          : Center(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _usecamera = true;
                        });
                      },
                      child: const Text("Use QR code")),
                  const Icon(
                    Icons.nfc,
                    size: 150,
                    color: Colors.black,
                  ),
                  const Text("Place minifig on NFC chip")
                ],
              ),
            ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      HapticFeedback.vibrate();
      AddCharacter(scanData.code);
      controller.dispose();
    });
  }

  void AddCharacter(String characterId) async {
    Navigator.pop(context);

    DocumentReference<Map<String, dynamic>> dbrefrence =
        FirebaseFirestore.instance.collection("Characters").doc(characterId);

    DocumentSnapshot<Map<String, dynamic>> db = await dbrefrence.get();

    Map<String, dynamic> dbdata = db.data() as Map<String, dynamic>;

    if (dbdata == null) {
      print("This char does not exist!");
      return;
    }

    List member = widget.data["members"];
    if (member.contains(dbrefrence)) {
      Navigator.pop(context);
      return;
    }
    member.add(dbrefrence);

    widget.groupData.set({"members": member}, SetOptions(merge: true));
  }
}
