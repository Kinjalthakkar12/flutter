import 'package:flutter/material.dart';
import 'package:food_panda_app/authentication/auth_screen.dart';
import 'package:food_panda_app/global/global.dart';

 class MyDrawer extends StatelessWidget
  {
 
  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        children: [
          Container(
            padding:const EdgeInsets.only(top: 25,bottom: 10),
            child: Column(
              children:  [
                //header drawer
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  child: Padding(
                    padding:EdgeInsets.all(1.0),
                     child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photoUrl")!
                        ),
                      ),
                     ),
                     ),
                ),
                SizedBox(height: 10,),
                Text(sharedPreferences!.getString("name")!,
                style: TextStyle(
                  color:Colors.red,
                  fontSize: 20
                ))
              ],),
          ),
        const SizedBox(height: 12,),
          //body drawer
          Container(
            padding:const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                const   Divider(
                    height: 10,
                    thickness: 2,
                    color: Colors.grey,
                   ),
                   ListTile(
                    leading:const Icon(Icons.home,color: Colors.black,),
                    title:const Text(
                      "Home",
                    style: TextStyle(
                      color: Colors.black
                    ),
                    ),
                    onTap: ()
                    {
                       firebaseAuth.signOut().then((value) =>
            {
              Navigator.push(context, MaterialPageRoute(builder: (C)=> const AuthScreen() )) 
            });
                    },
                   ),
                   const Divider(
                    height: 10,
                    thickness: 2,
                    color: Colors.grey,
                   ),                  
                    ListTile(
                    leading:const Icon(Icons.monetization_on,color: Colors.black,),
                    title:const Text(
                      "My Earnings",
                    style: TextStyle(
                      color: Colors.black
                    ),
                    ),
                    onTap: ()
                    {

                    },
                   ),
                  const  Divider(
                    height: 10,
                    thickness: 2,
                    color: Colors.grey,
                   ),
                    ListTile(
                    leading:const Icon(Icons.reorder,color: Colors.black,),
                    title:const Text(
                    "New Orders",
                    style: TextStyle(
                      color: Colors.black
                    ),
                    ),
                    onTap: ()
                    {

                    },
                   ),
                 const  Divider(
                    height: 10,
                    thickness: 2,
                    color: Colors.grey,
                   ),
                    ListTile(
                    leading:const Icon(Icons.local_shipping,color: Colors.black,),
                    title:const Text(
                      "History-Orders",
                    style: TextStyle(
                      color: Colors.black
                    ),
                    ),
                    onTap: ()
                    {

                    },
                   ),
                const Divider(
                    height: 10,
                    thickness: 2,
                    color: Colors.grey,
                   ),
                    ListTile(
                    leading:const Icon(Icons.exit_to_app,color: Colors.black,),
                    title:const Text(
                      "Sign Out",
                    style: TextStyle(
                      color: Colors.black
                    ),
                    ),
                    onTap: ()
                    {

                    },
                   ),
                   const Divider(
                    height: 10,
                    thickness: 2,
                    color: Colors.grey,
                   ), 
                  
            ],),

          )
        ]
       ),
    );
  }
}