import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_panda_app/global/global.dart';
import 'package:food_panda_app/mainScreens/home_screen.dart';
import 'package:image_picker/image_picker.dart';

class MenusUploadScreen extends StatefulWidget {
  
  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen>
 {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  
  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  


   defaultScreen()
   {
    return Scaffold(
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
        title: const Text(
         "Add New Menu",
          style: TextStyle(
            fontSize: 30,
            fontFamily: "Lobster"
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          },
        ),
      //   // actions: [
      //   //   IconButton(
      //   //     icon: const Icon(Icons.post_add,color: Colors.cyan,),
      //   //     onPressed: (){
      //   //       Navigator.push(context, MaterialPageRoute(builder: (c)=> MenusUploadScreen()));
      //   //     },
      //   //   )
      //   // ],
       ),
       body: Container(
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
             ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Icon(Icons.shop_2,color: Colors.white,size: 200,),
            ElevatedButton(
              onPressed: ()
              {
                 takeImage(context);
              },             
              child:const Text(
                "Add New Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                ),
                style: ButtonStyle(
                backgroundColor : MaterialStateProperty.all<Color>(Colors.amber),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                )
                  ),
                )
            ],),
        ),
         ),
    );
   }

   takeImage(mContext)
   {
     return showDialog(
      context: mContext, 
      builder: (context)
      {
        return SimpleDialog(
          title:const Text(
            "Menu Image",
            style: TextStyle(
              color: Colors.amber,
               fontWeight: FontWeight.bold
              ),),
          children: [
           SimpleDialogOption(
            child: const Text(
              "Capture With Camera",
              style: TextStyle(
                color: Colors.grey
              ),
              ),
              onPressed: captureImageWithCamera,
           ),
           SimpleDialogOption(
            child:const Text(
              "Select From Gallery",
              style: TextStyle(
                color: Colors.grey
              ),
              ),
              onPressed: pickImageFromGallery,
           ),
            SimpleDialogOption(
            child:const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.red
              ),
              ),
              onPressed: ()=> Navigator.pop(context)
           ),
          ],
        );
      },
     );
   }



  captureImageWithCamera() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
      );
      setState(() {
        imageXFile;
      });
  }
   pickImageFromGallery() async
   {
      Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
      );
      setState(() {
        imageXFile;
      });  
   }

   MenusUploadFormScreen()
   {
    return Scaffold(
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
        title: const Text(
         "Uploading New Menu",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Lobster"
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()
          {
            clearMenuUploadForm();
            // Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          },
        ),   
        actions: [
          TextButton( 
            onPressed: ()
            {
 
            }, 
            child:const Text(
              "Add",
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 18,
               // fontFamily: "Lobster",
               // letterSpacing: 2
              ),
              )
            )
         ], 
       ),
       body: ListView(
        children: [
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(imageXFile!.path)
                      ),
                      fit: BoxFit.cover
                      )
                  ),
                ),               
                 ),
            ),
          ),
          const  Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ListTile(
            leading:const Icon(Icons.perm_device_info,color: Colors.cyan,),
            title: Container(
              width: 250,
           child: TextField(
            style: TextStyle(color: Colors.black),
            controller: shortInfoController,
            decoration:const InputDecoration(
              hintText: "menu info",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none
               )
            )
             ),
          ),
        const  Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ListTile(
            leading:const Icon(Icons.title,color: Colors.cyan,),
            title: Container(
              width: 250,
           child: TextField(
            style: TextStyle(color: Colors.black),
            controller: titleController,
            decoration:const InputDecoration(
              hintText: "menu title",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none
               )
            )
             ),
          ),
          const  Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ]),
    );
   }
    
    clearMenuUploadForm()
    {
      setState(() {        
       shortInfoController.clear();
       titleController.clear();
       imageXFile = null;
      });
    }


  @override
  Widget build(BuildContext context)
   {
    return imageXFile == null ? defaultScreen() : MenusUploadFormScreen();
  }
}