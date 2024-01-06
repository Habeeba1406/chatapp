import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // email and pw txt controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

//tap to go to reg.pge
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  //login method
  void login(context) async {
    //auth service
    final authService = Authservice();

    //try login
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
    }

    //catch any errors
    catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
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
              "Welcome back,You've been missed",
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
              height: 10,
            ),
            //pw txtfld
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            //login btn
            const SizedBox(
              height: 25,
            ),
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),

            //reg now
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register Now",
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
