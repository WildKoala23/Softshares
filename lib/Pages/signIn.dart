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

  bool hidePassword = true;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Log In',
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
                userTextfield(),
                passwordFieldtext(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(elevation: 0),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                      )),
                )
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

  Container passwordFieldtext() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        obscureText: hidePassword,
        controller: passwordController,
        decoration: InputDecoration(
            label: const Text(
              'password',
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

  Container userTextfield() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: usernameController,
        decoration: const InputDecoration(
            label: Text(
              'Username/email/cellphone',
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

  AppBar myAppBar() {
    return AppBar(
      centerTitle: true,
      leading: const Icon(null),
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
