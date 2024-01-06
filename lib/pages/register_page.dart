import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/button.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  //email &pw txt controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmpwController = TextEditingController();

//tap to go to login.pg
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  //register method
  void register(BuildContext context) async {
    //get auth service
    final auth = Authservice();

    auth.signUpWithEmailPassword(
      _emailController.text,
      _pwController.text,
    );

    //pswrd match->create
    if (_pwController == _confirmpwController) {
      try {
        auth.signUpWithEmailPassword(_emailController.text, _pwController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    }

    //pswrd error/dont match->tell user to fix
    else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text('Password dont match..Try again'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(
              height: 50,
            ),

            //welcome back msg
            Text(
              "Let's create an account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //email tx
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(
              height: 25,
            ),

            //pw txtfld
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(
              height: 25,
            ),

            //confirm pw
            MyTextField(
              hintText: "confirm Password",
              obscureText: true,
              controller: _confirmpwController,
            ),

            const SizedBox(
              height: 25,
            ),
            //login btn

            MyButton(
              text: "Register",
              onTap: () => register(context),
            ),

            const SizedBox(
              height: 25,
            ),

            //reg now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
