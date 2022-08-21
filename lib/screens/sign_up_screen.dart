import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/login_screen.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../widget/text_input_widget.dart';
import '../widget/text_field_widget.dart';

import '../utils/colors.dart';

import '../models/auth_models.dart';

import '../resources/auth_methods.dart';
import '../resources/storage_methods.dart';

import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController userNameTextEditingController =
      TextEditingController();

  final TextEditingController emailTextEditingController =
      TextEditingController();

  final TextEditingController passwordTextEditingController =
      TextEditingController();

  final TextEditingController bioTextEditingController =
      TextEditingController();

  var _isSignUpLoading = false;
  ByteData? imageData;
  Uint8List? pickedImage;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void selectImage() async {
    final userPickedImage = await Utils().pickImage(ImageSource.gallery);
    if (userPickedImage != null) {
      setState(() {
        pickedImage = userPickedImage;
      });
    } else {
      //print("image returned null");
    }
  }

  void navigateToLogInScreen() {
    Navigator.of(context).pushReplacementNamed(LogInScreen.routeName);
  }

  Future<void> signUpHandler() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isSignUpLoading = true;
      });
      String result = await AuthMethods().signUpUserWithEmail(
          userNameTextEditingController.text,
          emailTextEditingController.text,
          passwordTextEditingController.text,
          bioTextEditingController.text,
          pickedImage!);
      if (result == "success") {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          );
        }));
      } else {
        Utils().showSnackbar(result, context);
      }
      setState(() {
        _isSignUpLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    rootBundle
        .load('assets/default_profile_pic.png')
        .then((data) => setState(() {
              this.imageData = data;
              pickedImage = imageData!.buffer.asUint8List();
            }));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userNameTextEditingController.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    bioTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.vertical,
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(children: [
              Flexible(
                fit: FlexFit.tight,
                child: Container(),
              ),
              // Instagram Logo
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 60,
              ),
              SizedBox(
                height: 15,
              ),
              // User profile picker
              Stack(
                children: [
                  pickedImage != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: MemoryImage(pickedImage!))
                      : const CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage('./assets/default_profile_pic.png')),
                  Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(Icons.add_a_photo),
                      ))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      // Username field
                      TextFieldWidget(
                          controller: userNameTextEditingController,
                          labelTxt: "Username",
                          hintTxt: "Enter your username",
                          typeOfFields: Auth_models.others,
                          txtInputType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 15,
                      ),
                      // Email field
                      TextFieldWidget(
                          controller: emailTextEditingController,
                          labelTxt: "Email",
                          hintTxt: "Enter your email address",
                          typeOfFields: Auth_models.email,
                          txtInputType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 15,
                      ),
                      // Password
                      TextFieldWidget(
                        controller: passwordTextEditingController,
                        labelTxt: "Password",
                        hintTxt: "Enter your Password",
                        typeOfFields: Auth_models.password,
                        txtInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Bio
                      TextFieldWidget(
                        controller: bioTextEditingController,
                        labelTxt: "Bio",
                        hintTxt: "Enter your bio",
                        txtInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  )),

              // Sign up Button
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                onTap: signUpHandler,
                child: Ink(
                  //alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: _isSignUpLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Center(child: Text("Sign up")),
                ),
              ),
              Flexible(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Do you have an account?"),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: navigateToLogInScreen,
                      child: const Text(
                        "Log in",
                        style: TextStyle(color: blueColor),
                      ))
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
