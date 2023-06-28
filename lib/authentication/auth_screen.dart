import 'package:flutter/material.dart';
import 'package:food_panda_app/authentication/login.dart';
import 'package:food_panda_app/authentication/register.dart';

 class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.shade200,
                     Colors.amber.shade100
                ],
                begin: const FractionalOffset(0.0,0.0),
                end: const FractionalOffset(1.0,0.0),
                stops: const [0.0,1.0],
                tileMode: TileMode.clamp
                )
             ), ),
             automaticallyImplyLeading: false,
          title: const Text(
            "iFood",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontFamily: "Lobster"
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs:[
            Tab(
              icon: Icon(Icons.lock,
              color: Colors.white,
              ),
              text: "Login",
            ),
             Tab(
              icon: Icon(Icons.person,
              color: Colors.white,
              ),
              text: "Register",
            ), 
          ],
          indicatorColor: Colors.white38,
         indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.cyan.shade200,
                Colors.amber.shade100
              ]
            )
          ),
          child: TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen()
          ]),
        ),
      
        ),
    );

  }
}