import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../widget/text_input_widget.dart';
import '../widget/text_field_widget.dart';

import '../resources/auth_methods.dart';

import '../utils/colors.dart';
import '../utils/utils.dart';

import '../models/auth_models.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = '/login';
  LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailTextEditingController =
      TextEditingController();

  final TextEditingController passwordTextEditingController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _isSigningIn = false;

  void navigateToSignupScreen() {
    Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
  }

  Future<void> loginHandler() async {
    final validated = _formKey.currentState!.validate();
    // If the fields user entered are valid
    if (validated) {
      setState(() {
        _isSigningIn = true;
      });
      final result = await AuthMethods().signIn(
          emailTextEditingController.text, passwordTextEditingController.text);
      if (result == "success") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) {
          return const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          );
        }));
      }
      setState(() {
        _isSigningIn = false;
      });
      Utils().showSnackbar(result, context);
    }
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
              Flexible(child: Container()),
              // Instagram Logo
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 60,
              ),
              const SizedBox(
                height: 15,
              ),

              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFieldWidget(
                          controller: emailTextEditingController,
                          labelTxt: "Email",
                          hintTxt: "Enter your email address",
                          typeOfFields: Auth_models.email,
                          txtInputType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                          controller: passwordTextEditingController,
                          labelTxt: "Password",
                          hintTxt: "Enter your password",
                          typeOfFields: Auth_models.password,
                          txtInputType: TextInputType.emailAddress),
                    ],
                  )),
              const SizedBox(
                height: 15,
              ),

              // Log in button
              InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                onTap: loginHandler,
                child: Ink(
                  //alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  child: _isSigningIn
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Center(child: Text("Log in")),
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              // Sign in with google
              // Sign in with apple

              Flexible(child: Container()),

              // Jump to Sign up screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account"),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: navigateToSignupScreen,
                      child: const Text(
                        "Sign up",
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
