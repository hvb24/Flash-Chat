import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LoginScreen extends StatefulWidget {
  static const String id = '/loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

String email='';
String password='';
bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration:kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
                textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')
            ),
            SizedBox(
              height: 24.0,
            ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Material(
            elevation: 5.0,
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(
              onPressed:() async {
               setState(() {
                _isLoading = true;
                   });
                   try {
                    final user = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                   if (user != null) {
                  Navigator.pushNamed(context, ChatScreen.id);
                   }
                   setState(() {
                     _isLoading = false;
                   });
}

catch(e){
print(e);
}},
              minWidth: 200.0,
              height: 42.0,
              child:
                _isLoading ? Center(child: CircularProgressIndicator( color: Colors.white,),): Text('Login',
                style: TextStyle(color: Colors.white),)
              ),
            ),
          ),


          ],
        ),
      ),
    );
  }
}
// RoundedButton(onPressed: () async {
// setState(() {
// _isLoading = true;
// });
// try {
// final user = await _auth.signInWithEmailAndPassword(
// email: email, password: password);
// if (user != null) {
// Navigator.pushNamed(context, ChatScreen.id);
// }
// }
// catch(e){
// print(e);
// }
// },colour: Colors.lightBlueAccent, title: 'Log in',)