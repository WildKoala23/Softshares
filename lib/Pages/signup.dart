import 'package:dev_icons/dev_icons.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hidePassword = true, hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: myAppBar(context, colorScheme),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0, top: 15.0),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0, top: 10.0),
              child: Column(
                children: [
                  facebookBtn(colorScheme),
                  const SizedBox(
                    height: 25,
                  ),
                  googleBtn(colorScheme),
                  myDivider(colorScheme),
                  firstNameField(colorScheme),
                  lastNameField(colorScheme),
                  emailField(colorScheme),
                  passField(colorScheme),
                  confirmPassField(colorScheme),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: continueBtn(context, colorScheme),
            )
          ],
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
          onPressed: () => {Navigator.pushNamed(context, '/home')},
          child: const Text('Continue')),
    );
  }

  Container confirmPassField(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        obscureText: hideConfirmPassword,
        controller: confirmPasswordController,
        decoration: InputDecoration(
            label: Text(
              'Confirm password',
              style: TextStyle(color: colorScheme.onTertiary),
            ),
            prefixIcon: Icon(
              Icons.password,
              color: colorScheme.onTertiary,
              size: 32,
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  if (hideConfirmPassword == true) {
                    setState(() {
                      hideConfirmPassword = false;
                    });
                  } else {
                    setState(() {
                      hideConfirmPassword = true;
                    });
                  }
                },
                icon: hideConfirmPassword == true
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.onTertiary))),
      ),
    );
  }

  Container passField(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        obscureText: hidePassword,
        controller: passwordController,
        decoration: InputDecoration(
            label: Text(
              'Password',
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

  Container emailField(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
            label: Text(
              'Email',
              style: TextStyle(color: colorScheme.onTertiary),
            ),
            prefixIcon: Icon(
              Icons.account_circle,
              color: Color(0xFF49454F),
              size: 32,
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.onTertiary))),
      ),
    );
  }

  Container firstNameField(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
            label: Text(
              'First name',
              style: TextStyle(color: colorScheme.onTertiary),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.onTertiary))),
      ),
    );
  }

  Container lastNameField(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
            label: Text(
              'Last name',
              style: TextStyle(color: colorScheme.onTertiary),
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
        SizedBox(width: 2),
        Text(
          'Or',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(width: 2), // Add space between dividers
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
              backgroundColor: Colors.transparent,
              foregroundColor: colorScheme.onPrimary,
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

  AppBar myAppBar(BuildContext context, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => {Navigator.pop(context)},
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
    );
  }
}
