import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/firebase_auth_methods.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool onHovered = false;
  String? imageUrl;
  final _emailct = TextEditingController();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Profile',
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              String uniqueFileName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              ImagePicker imagePicker = ImagePicker();
                              XFile? file = await imagePicker.pickImage(
                                  source: ImageSource.gallery);

                              if (file == null) return;

                              Reference referenceRoot =
                                  FirebaseStorage.instance.ref();
                              Reference referenceDirImages =
                                  referenceRoot.child('profilepictures');
                              Reference referenceImageToUpload =
                                  referenceDirImages.child(uniqueFileName);
                              try {
                                await referenceImageToUpload
                                    .putFile(File(file.path));
                                imageUrl = await referenceImageToUpload
                                    .getDownloadURL();
                                final docUser = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid);
                                final newUser = {"profilepicture": imageUrl};
                                await docUser.update(newUser);
                              } catch (e) {}
                            },
                            hoverColor: Colors.brown,
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color:
                                              Theme.of(context).primaryColor),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          snapshot.data?["profilepicture"],
                                          width: 105,
                                          height: 105,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> OpenEmailDialog(BuildContext context, User user) {
    return showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              title: Text(
                'Update email',
                style: TextStyle(color: Theme.of(context).iconTheme.color),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              content: TextField(
                controller: _emailct,
                decoration: InputDecoration(
                  hintText: user.email,
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  hintStyle: TextStyle(
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.7)),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _emailct.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                    });

                    if (!_validate) {
                      user.updateEmail('ruiflorencio@gmail.com');
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                )
              ],
            )));
  }
}
