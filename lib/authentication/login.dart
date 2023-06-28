import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_panda_app/authentication/auth_screen.dart';
import 'package:food_panda_app/global/global.dart';
import 'package:food_panda_app/mainScreens/home_screen.dart';
import 'package:food_panda_app/widgets/custom_text_field.dart';
import 'package:food_panda_app/widgets/error_dialog.dart';
import 'package:food_panda_app/widgets/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

 class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> 
{
final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
 TextEditingController  emailcontroller = TextEditingController();
 TextEditingController passwordcontroller = TextEditingController();

 formValidation()
 {
   if(emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty)
   {
       //login
       loginNow();
   }else
   {
     showDialog(
      context: context, 
     builder: (c)
      {
        return ErrorDialog(
          message: "Please write email/password.",
        );
     }
     );
   }
 }

   loginNow() async
   {
      showDialog(
      context: context, 
     builder: (c)
      {
        return LoadingDialog(
          message: "Checking Credntial",
        );
     }
     ); 


     User? currentUser;
     await firebaseAuth.signInWithEmailAndPassword(
      email: emailcontroller.text.trim(),
      password: passwordcontroller.text.trim()
      ).then((auth) {
     currentUser = auth.user!;
      }).catchError((error){
        Navigator.pop(context);
         showDialog(
      context: context, 
     builder: (c)
      {
        return ErrorDialog(
          message: error.message.toString(),
        );
     }
     );
      });
      if (currentUser != null)
      {
          readDataAndSetDataLocally(currentUser!);
      }
    
   }
    
    Future readDataAndSetDataLocally(User currentUser) async 
    {
      await FirebaseFirestore.instance.collection("sellers")
      .doc(currentUser.uid)
      .get()
      .then((snapahot)  async {
        if(snapahot.exists){
         await sharedPreferences!.setString("uid",currentUser.uid);
       await sharedPreferences!.setString("email",snapahot.data()!["sellerEmail"]);
       await sharedPreferences!.setString("uid",snapahot.data()!["sellerName"]);
       await sharedPreferences!.setString("photoUrl",snapahot.data()!["sellerAvatarUrl"]); 

        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen())); 

        }
      else
      {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen())); 

         showDialog(
      context: context, 
     builder: (c)
      {
        return ErrorDialog(
          message: "no record found.",
        );
     }
     );  


      }
      });
    }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset("assets/images/login.jpg",
              height: 270,
              ),
              ),
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                    CustomTextField(
                      data: Icons.email,
                     controller: emailcontroller,
                     hintText: "Email",
                     isObsecre: false,
                     ),
                      CustomTextField(
                      data: Icons.lock,
                     controller: passwordcontroller,
                     hintText: "Password",
                     isObsecre: true,
                     ),
            ]),
          ),
           ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10)
            ),
            onPressed: () {
              formValidation();
            },
            child:  const Text("Login",
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
            ) 
            ),
          const  SizedBox(height: 30,)
             
      ]),
    );
  }
}