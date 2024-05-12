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
    return Scaffold(
      appBar: myAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Sign In',
              style: TextStyle(fontSize: 32),
            ),
            Column(
              children: [
                facebookBtn(),
                const SizedBox(
                  height: 25,
                ),
                googleBtn(),
                myDivider(),
                emailField(),
                passField(),
                confirmPassField(),
              ],
            ),
            continueBtn(context)
          ],
        ),
      ),
    );
  }

  Container continueBtn(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 45,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF80ADD7),
          ),
          onPressed: () => {Navigator.pushNamed(context, '/home')},
          child: const Text('Continue')),
    );
  }

  Container confirmPassField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        obscureText: hideConfirmPassword,
        controller: confirmPasswordController,
        decoration: InputDecoration(
            label: const Text(
              'Confirm password',
              style: TextStyle(color: Color(0xFF79747E)),
            ),
            prefixIcon: const Icon(
              Icons.password,
              color: Color(0xFF49454F),
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
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off)),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF49454F)))),
      ),
    );
  }

  Container passField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        obscureText: hidePassword,
        controller: passwordController,
        decoration: InputDecoration(
            label: const Text(
              'Password',
              style: TextStyle(color: Color(0xFF79747E)),
            ),
            prefixIcon: const Icon(
              Icons.password,
              color: Color(0xFF49454F),
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
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF49454F)))),
      ),
    );
  }

  Container emailField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: emailController,
        decoration: const InputDecoration(
            label: Text(
              'Email',
              style: TextStyle(color: Color(0xFF79747E)),
            ),
            prefixIcon: Icon(
              Icons.account_circle,
              color: Color(0xFF49454F),
              size: 32,
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF49454F)))),
      ),
    );
  }

  Row myDivider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            height: 50,
            thickness: 1,
            indent: 25,
            endIndent: 15, // Adjust endIndent as needed
            color: Color(0xFFCAC4D0),
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
            color: Color(0xFFCAC4D0),
          ),
        ),
      ],
    );
  }

  Container googleBtn() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 55,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Color(0xff79747E)),
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

  Container facebookBtn() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 55,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Color(0xFF79747E)),
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

  AppBar myAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => {Navigator.pop(context)},
      ),
      title: RichText(
        text: const TextSpan(
            text: 'Soft',
            style: TextStyle(color: Colors.black, fontSize: 36),
            children: <TextSpan>[
              TextSpan(
                  text: 'Shares',
                  style: TextStyle(color: Color(0xff00C2FF), fontSize: 36))
            ]),
      ),
    );
  }
}
