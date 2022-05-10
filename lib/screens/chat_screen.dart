import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatScreen extends StatefulWidget {
  static const String id = '/chatloginScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final messageTextConreller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
   bool isme=true;
  final storage = new FlutterSecureStorage();

  String messageText;
  var messages1;
  final CollectionReference =
      FirebaseFirestore.instance.collection('messages').doc('text');
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



  showMessage() {
    Map<String, String> msg = {
      "sender": sender,
      "text": text,
    };
  }


  readMsg() {
    Map<String, String> msgs = {
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
              onPressed: () async{
                _auth.signOut();
                // var storage;
                await storage.delete(key: "uid");
                
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
                stream: _firestore.collection('messages').orderBy('time',descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading');
                  } else {
                    final messages = snapshot.data?.docs;


                    return ListView.builder(
                      reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          // print(jsonDecode(jsonEncode(messages[index].data())));
                          // print();
                          var message =
                              jsonDecode(jsonEncode(messages[index].data()));
                          final messageText = message["sender"];
                          final currentSender = loggedInUser.email;
                          if(messageText==currentSender){
                            isme=true;
                          }else{
                            isme=false;
                          }



                          return Container(
                            padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 0),
                            child: Column(
                              crossAxisAlignment: isme?CrossAxisAlignment.end:CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message["sender"] == null
                                      ? "NULL"
                                      : message["sender"],
                                  style: TextStyle(fontSize: 11
                                  ,color: Colors.black54),
                                ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Material(
                                  borderRadius: isme ?BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0)
                                  ):
                                  BorderRadius.only(
                                      topRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0)
                                  ),
                                  elevation: 5.0,
                                color: Colors.lightBlueAccent,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
                                  child: Text(

                                    message["text"] == null
                                        ? "NULL"
                                        : message["text"],
                                    style: TextStyle(fontSize: 15,
                                    color: Colors.white),
                                  ),
                                ),
                            ),
                              ),


                              ],
                            )
                          );
                          
                        });
                   
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
                      controller: messageTextConreller,
                      onChanged: (value) {

                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(

                    onPressed: () {
                      messageTextConreller.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'time': DateTime.now(),
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


class MessageBubble extends StatelessWidget {
  // MessageBubble({this.message});

  @override
  Widget build(BuildContext context) {
    final Map<dynamic,dynamic> message= {"text": " ",
      "sender": ""
    };

    return  Material(
      color: Colors.lightBlueAccent,
      child: Text(

        message["text"] == null
            ? "NULL"
            : message["text"],
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
