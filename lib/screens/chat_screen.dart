// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const activeSentButtonColor = Colors.lightBlueAccent;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  User loggedInUser;

  TextEditingController _messageText = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // messagesStream();
  }

  void getCurrentUser() async {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {}
  }

  void messagesStream() async {
    await for (var snapshots in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshots.docs) {}
    }
    // await _fireStore.collection('messages').snapshots().forEach((snapshot) {
    //   for (var message in snapshot.docs) {
    //     print(message.data());
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout_outlined),
              onPressed: () {
                // _auth.signOut();
                // Navigator.pop(context);
                messagesStream();
              }),
        ],
        title: Text("Let's Talk"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/chat_background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _messageText,
                              decoration: kMessageTextFieldDecoration,
                            ),
                          ),
                          IconButton(
                            splashColor: Color.fromARGB(255, 81, 255, 6),
                            onPressed: () {
                              if (_messageText.text.isNotEmpty ||
                                  _messageText.text != ' ') {
                                _fireStore.collection('messages').add({
                                  'sender': loggedInUser.email,
                                  'text': _messageText.text,
                                });
                              }
                              setState(() {
                                _messageText.text = '';
                              });
                            },
                            icon: Icon(Icons.send_outlined),
                            color: Colors.lightBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Container(
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                _fireStore.collection('messages').snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              final messages = snapshot.data.docChanges;
                              List<Text> messagesWidgets = [];
                              for (var message in messages) {
                                final messageText = message.doc['text'];
                                final messageSender = message.doc['sender'];
                                final messageWidget = Text(
                                  '$messageSender :  $messageText',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                                messagesWidgets.add(messageWidget);
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: messagesWidgets,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
