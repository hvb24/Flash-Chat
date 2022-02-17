import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = '/chatloginScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  String messageText;
  var messages1;
  final CollectionReference = FirebaseFirestore.instance.collection('messages');
  String sender = "";
  String text = "";

  @override
  //INIT
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  getMessages() async {
    final messages = await _firestore.collection('messages').get();

    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
    return messages;
  }

  showMessage() {
    Map<String, String> msg = {
      "sender": sender,
      "text": text,
    };
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // _auth.signOut();
                // Navigator.pop(context);
                getMessages();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading');
                  } else {
                    final messages = snapshot.data?.docs;
                    return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                              key: Key(index.toString()),
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                  title: Text(messages[index].id),
                                  subtitle: Text("papa"),
                                ),
                              ));
                        });

                    // List<Text> messageWidgets = [];
                    // for (var message in messages) { final messageText = message["text"];
                    // final messageSender = message["sender"];
                    // final messageWidget = Text('$messageText from $messageSender');
                    // messageWidgets.add(messageWidget);
                    // }

                    // return Column( children: messageWidgets, );
                  }
                },
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//     if (snapshot.hasData)
//     { final messages = _firestore
//         .collection('message')
//         .snapshots();
//
//     print(messages);
//
//
//
//     // for (var message in messages) {
//     // }
//     // return Column( children: messageWidgets, );
//
//
//     children: snapshot.data.docs.map((DocumentSnapshot document) {
//
//     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//
//     final messageText = data['text'];
//     final messageSender = data['sender'];
//
//     return
//     ListTile(
//     textColor: Colors.black,
//     title: Text(messageText),
//     subtitle: Text(messageSender),
//     );
//
//
//     }
//     ).toList();
//     } else { return Text('No Data Found');
//     }
//
//   }
//   catch(e){print(e);
//   }
//   return Container();
// }
//${snapshot.data[index].sender}



