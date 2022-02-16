import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id = 'welcomesccreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin{
  AnimationController controller;
  AnimationController controller2;
  Animation animation;
  Animation animation2;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController( duration: Duration(seconds: 1),
    vsync: this,
    );
    // controller2 = AnimationController( duration: Duration(seconds: 1),
    //   vsync: this,
    // );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOutQuart );

    animation2 = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);
    controller.forward();
    // controller2.forward();
    controller.addListener(() {
      setState(() {

      });

    });
  //   controller2.addListener(() {
  //     setState(() {
  //
  //     });
  //   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation2.value ,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
        SizedBox(
          width: 250.0,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 45.0,
              fontFamily: 'Horizon',
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
            child: AnimatedTextKit(

              // repeatForever: true,
                animatedTexts: [

                  TypewriterAnimatedText('Flash Chat',
                      speed: const Duration(milliseconds: 350),
                  textStyle: TextStyle(fontWeight: FontWeight.bold)),


                ],
              repeatForever: true,

          ),
        ),
      ),

      ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(colour: Colors.lightBlueAccent,title: 'Log in',onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            }),
            RoundedButton(onPressed: () {
    Navigator.pushNamed(context, RegistrationScreen.id);
    },title: 'Register', colour: Colors.blueAccent,)
          ],
        ),
      ),
    );
  }
}

