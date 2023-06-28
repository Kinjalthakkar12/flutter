import 'package:flutter/material.dart';
import 'package:food_panda_app/authentication/auth_screen.dart';
import 'package:food_panda_app/global/global.dart';
import 'package:food_panda_app/uploadScreens/menus_upload_screen.dart';
import 'package:food_panda_app/widgets/my_drawer.dart';

 class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
        title: Text(
          sharedPreferences!.getString("name")!,         
          style: TextStyle(
            fontSize: 30,
            fontFamily: "Lobster"
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,       
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add,color: Colors.cyan,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> MenusUploadScreen()));
            },
          )
        ],
      ),
      body: Center( ),
    );
  }
}