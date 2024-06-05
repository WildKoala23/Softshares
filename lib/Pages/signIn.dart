import 'package:flutter/material.dart';
import "package:dev_icons/dev_icons.dart";

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  bool hidePassword = true;

  bool validInput() {
    if (usernameController.text == '' || passwordController.text == '') {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: myAppBar(colorScheme),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Log In',
                style: TextStyle(fontSize: 32),
              ),
              Column(
                children: [
                  facebookBtn(colorScheme),
                  const SizedBox(
                    height: 25,
                  ),
                  googleBtn(colorScheme),
                  myDivider(colorScheme),
                  userTextfield(colorScheme),
                  passwordFieldtext(colorScheme),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: colorScheme.onPrimary,
                        ),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                        )),
                  )
                ],
              ),
              continueBtn(context, colorScheme)
            ],
          ),
        ),
      ),
    );
  }

  Container continueBtn(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 45,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: colorScheme.onPrimary,
            backgroundColor: colorScheme.primary,
          ),
          onPressed: () {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formkey.currentState!.validate()) {
              // If the form is valid, continue to homepage
              //Later, implement verification with DB
              Navigator.pushNamed(context, '/home');
            }
          },
          child: const Text('Continue')),
    );
  }

  Container passwordFieldtext(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter password';
          }
          return null;
        },
        obscureText: hidePassword,
        controller: passwordController,
        decoration: InputDecoration(
            label: Text(
              'password',
              style: TextStyle(color: colorScheme.onTertiary),
            ),
            prefixIcon: Icon(
              Icons.password,
              color: colorScheme.onTertiary,
              size: 32,
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  if (hidePassword == true) {
                    setState(() {
                      hidePassword = false;
                    });
                  } else {
                    setState(() {
                      hidePassword = true;
                    });
                  }
                },
                icon: hidePassword == true
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.onTertiary))),
      ),
    );
  }

  Container userTextfield(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter email/phone number';
          }
          return null;
        },
        controller: usernameController,
        decoration: InputDecoration(
            label: Text(
              'Email/phone number',
              style: TextStyle(color: colorScheme.onTertiary),
            ),
            prefixIcon: Icon(
              Icons.account_circle,
              color: colorScheme.onTertiary,
              size: 32,
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.onTertiary))),
      ),
    );
  }

  Row myDivider(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            height: 50,
            thickness: 1,
            indent: 25,
            endIndent: 15, // Adjust endIndent as needed
            color: colorScheme.onTertiary,
          ),
        ),
        const SizedBox(width: 2),
        const Text(
          'Or',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 2), // Add space between dividers
        Expanded(
          child: Divider(
            height: 50,
            thickness: 1,
            indent: 15, // Adjust indent as needed
            endIndent: 25,
            color: colorScheme.onTertiary,
          ),
        ),
      ],
    );
  }

  Container googleBtn(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 55,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: colorScheme.onSecondary,
              backgroundColor: Colors.transparent,
              side: BorderSide(color: colorScheme.onTertiary),
              elevation: 0),
          onPressed: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                DevIcons.googlePlain,
                size: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Continue with Google',
                textAlign: TextAlign.center,
              )
            ],
          )),
    );
  }

  Container facebookBtn(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 55,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: colorScheme.onSecondary,
              side: BorderSide(color: colorScheme.onTertiary),
              elevation: 0),
          onPressed: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.facebook,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Continue with Facebook',
                textAlign: TextAlign.center,
              )
            ],
          )),
    );
  }

  AppBar myAppBar(ColorScheme colorScheme) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: RichText(
        text: TextSpan(
            text: 'Soft',
            style: TextStyle(color: colorScheme.onSecondary, fontSize: 36),
            children: <TextSpan>[
              TextSpan(
                  text: 'Shares',
                  style: TextStyle(color: colorScheme.secondary, fontSize: 36))
            ]),
      ),
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
            onPressed: () => {Navigator.pushNamed(context, '/SignUp')},
            icon: const Icon(
              Icons.person_add,
              size: 32,
            ))
      ],
    );
  }
}
