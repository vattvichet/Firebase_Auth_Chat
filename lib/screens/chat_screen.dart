// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const activeSentButtonColor = Colors.lightBlueAccent;
final _fireStore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  User loggedInUser;

  final _messageText = TextEditingController();

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

  // void messagesStream() async {
  //   await for (var snapshots in _fireStore.collection('messages').snapshots()) {
  //     for (var message in snapshots.docs) {}
  //   }
  //   // await _fireStore.collection('messages').snapshots().forEach((snapshot) {
  //   //   for (var message in snapshot.docs) {
  //   //     print(message.data());
  //   //   }
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    // messagesStream();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout_outlined),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text("Let's Talk"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: StreamBubbles(),
            ),
          ),
        ],
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          child: Padding(
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
        ),
      ),
    );
  }
}

class StreamBubbles extends StatelessWidget {
  const StreamBubbles({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _fireStore.collection('messages').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final messages = snapshot.data.docChanges;
            List<MessageBubble> messagesBubbles = [];
            for (var message in messages) {
              final messageText = message.doc['text'];
              final messageSender = message.doc['sender'];
              final messageBubble = MessageBubble(
                sender: messageSender,
                text: messageText,
              );
              messagesBubbles.add(messageBubble);
            }
            return Expanded(
              child: ListView(
                children: messagesBubbles,
              ),
            );
          },
        ),
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({Key key, this.sender, this.text}) : super(key: key);
  final String sender;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(sender),
        Padding(
          padding: EdgeInsets.all(10),
          child: Material(
            borderRadius: BorderRadius.circular(30),
            elevation: 5,
            color: Colors.lightBlue,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                text,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
