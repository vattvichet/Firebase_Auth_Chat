// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const activeSentButtonColor = Colors.lightBlueAccent;
final _fireStore = FirebaseFirestore.instance;
//
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

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
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0),
          image: DecorationImage(
            image: AssetImage('images/chat_background.png'),
          ),
        ),
        padding: EdgeInsets.all(10),
        child: StreamBubbles(),
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
            child: Container(
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
                          _messageText.text != '') {
                        _fireStore.collection('messages').add({
                          'sender': loggedInUser.email,
                          'text': _messageText.text,
                          'timestamp': FieldValue.serverTimestamp(),
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
          stream: _fireStore
              .collection('messages')
              .orderBy('timestamp')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final messages = snapshot.data.docChanges.reversed;
            List<MessageBubble> messagesBubbles = [];
            for (var message in messages) {
              final messageText = message.doc['text'];
              final messageSender = message.doc['sender'];

              final messageBubble = MessageBubble(
                sender: messageSender,
                text: messageText,
                isMe: loggedInUser.email == messageSender,
              );
              messagesBubbles.add(messageBubble);
            }
            return Expanded(
              child: ListView(
                reverse: true,
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
  const MessageBubble({Key key, this.sender, this.text, this.isMe})
      : super(key: key);
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(0),
          child: Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
            elevation: 5,
            color: Color.fromARGB(255, 121, 157, 193),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              child: Text(isMe ? 'By You' : '$sender'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
            elevation: 5,
            color: isMe
                ? Color.fromARGB(215, 255, 154, 248)
                : Color.fromARGB(215, 185, 233, 134),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                text,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 50),
        ),
      ],
    );
  }
}
