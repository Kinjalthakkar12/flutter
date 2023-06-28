import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_panda_app/global/global.dart';
import 'package:food_panda_app/mainScreens/home_screen.dart';
import 'package:food_panda_app/widgets/custom_text_field.dart';
import 'package:food_panda_app/widgets/error_dialog.dart';
import 'package:food_panda_app/widgets/loading_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:shared_preferences/shared_preferences.dart';

 class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
 {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  
  
  XFile? imageXfile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageUrl = " ";
  String  completeAddress = " ";


  Future<void> _getImage() async
  {
    imageXfile = await _picker.pickImage(source: ImageSource.gallery);

   setState(() {
     imageXfile;
   });
  }
  
    getCurrentLocation() async 
    {
      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      position = newPosition;
      placeMarks = await placemarkFromCoordinates(
      position!.latitude, 
      position!.longitude
      );

      Placemark pMark = placeMarks![0];

     completeAddress = '${pMark.subThoroughfare}  ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea},${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country} ';
      
      var locationController;
      locationController.text = completeAddress;
   
    }

    Future<void> formValidation() async
    {
     if(imageXfile == null)
     {
      showDialog(
        context: context,
       builder: (c)
       {
          return ErrorDialog(
            message: "Please select an image.",
          );
       }
       );
     }
     else 
     {
       if(passwordcontroller.text == confirmPasswordcontroller.text)
       {
      if (confirmPasswordcontroller.text.isNotEmpty && emailcontroller.text.isNotEmpty && namecontroller.text.isNotEmpty && phonecontroller.text.isNotEmpty && locationcontroller.text.isNotEmpty)
           {
           // start uploading image
           showDialog(
            context: context,
             builder:(c)
             {
              return LoadingDialog(
                message: "Registering Account.",);
             }
             );
             String fileName = DateTime.now().millisecondsSinceEpoch.toString();
             fstorage.Reference reference = fstorage.FirebaseStorage.instance.ref().child("sellers").child(fileName);
             fstorage.UploadTask uploadTask = reference.putFile(File(imageXfile!.path));
             fstorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
             await taskSnapshot.ref.getDownloadURL().then((url) {
              sellerImageUrl = url;


              //save info in to firestore
              authenticateSellerAndSignUp();

             } );
           } 
      else
           {
              showDialog(
        context: context,
       builder: (c)
       {
          return ErrorDialog(
            message: "Please write the complete required info for Registration.",
          );
       }
       );    
           }
       }
       else
       {
          showDialog(
        context: context,
       builder: (c)
       {
          return ErrorDialog(
            message: "Password do not match.",
          );
       }
       );    
       }
     }
    }

   void authenticateSellerAndSignUp() async
    {
      User? currentUser;
     


      await firebaseAuth.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
        ).then((auth) {
          currentUser = auth.user;
        }).catchError((error){
          Navigator.pop(context);
          showDialog(
            context: context, 
            builder:(c)
            {
            return ErrorDialog(
              message: error.message.toString(),
            );
            }
            );
        });
        if (currentUser != null)
        {
        saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);

        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
        });
    }
    }

   Future saveDataToFirestore(User currentUser)  async 
   {
     FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "sellerUID" : currentUser.uid,
      "sellerEmail" : currentUser.email,
      "sellerName" : namecontroller.text.trim(),
      "sellerAvatarUrl" : sellerImageUrl,
      "phoneName" : phonecontroller.text.trim(),
      "address" : completeAddress,
      "status" : "approved",
      "earrings" : 0.0,
       "lat" : position?.latitude,
       "lng" : position?.longitude,
     });

     // save data locally
      sharedPreferences = await SharedPreferences.getInstance();
     await sharedPreferences!.setString("uid",currentUser.uid);
      await sharedPreferences!.setString("email",currentUser.email.toString());
     await sharedPreferences!.setString("name",namecontroller.text.trim());
     await sharedPreferences!.setString("photoUrl",sellerImageUrl);
   }



  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
    child:Container(
     child: Column(
      mainAxisSize: MainAxisSize.max,
        children:[
          SizedBox(height: 10,),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage: imageXfile==null ? null : FileImage(File(imageXfile!.path)),
              child: imageXfile == null 
                  ?
                  Icon(
                    Icons.add_photo_alternate,
                    size: MediaQuery.of(context).size.width * 0.20,
                    color: Colors.grey,
                  ) : null,
          ),
          ),
          SizedBox(height: 10,),
          Form(
            key: _formkey,
            child: Column(
              children: [
                     CustomTextField(
                      data: Icons.person,
                     controller: namecontroller,
                     hintText: "Name",
                     isObsecre: false,
                     ),
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
                      CustomTextField(
                      data: Icons.lock,
                     controller: confirmPasswordcontroller,
                     hintText: "Confirm Password",
                     isObsecre: true,
                     ),
                      CustomTextField(
                      data: Icons.phone,
                     controller: phonecontroller,
                     hintText: "Phone",
                     isObsecre: false,
                     ),
                     CustomTextField(
                      data: Icons.my_location,
                     controller: locationcontroller,
                     hintText: "Cafe/Restaurant Address",
                     isObsecre: false,
                     enabled: true,
                     ),
                     Container(
                      width: 320,
                      height: 40,
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                              label:  const Text(
                                "Get My Current Location",
                                style: TextStyle(
                                  color: Colors.white),
                              ),
                              icon: Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                getCurrentLocation();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )
                              ),
                      ),
                     )
            ],),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10)
            ),
            onPressed: () {
              formValidation();
            },
            child:  const Text("Sign Up",
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
            ) 
            ),
          const  SizedBox(height: 30,)
         
  ] ),
   ));
  }
}