// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// void main() => runApp(FlashChat());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final storage = FlutterSecureStorage();
    Future<bool> checkLoginStatus() async{
    String value =await storage.read(key: "uid");
    if(value==null){
    return false;
    }
    return true;
    }

    return MaterialApp(

      debugShowCheckedModeBanner: false,


      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool>snapshot){
        if(snapshot.data==false){
         return LoginScreen();
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return Container(
              color: Colors.white38,
              child: Center(child: CircularProgressIndicator()));
        }
        return ChatScreen();
        },
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context)=>  WelcomeScreen(),
        LoginScreen.id : (context)=> LoginScreen(),
        RegistrationScreen.id : (context)=> RegistrationScreen(),
        ChatScreen.id : (context)=> ChatScreen(),


      },
    );
  }
}
