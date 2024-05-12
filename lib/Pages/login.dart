import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyLoginIn extends StatelessWidget {
  final String username;

  const MyLoginIn({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleWidget(),
      body: Padding(
        padding: const EdgeInsets.only(top: 65.0, bottom: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              actionsInfo(context),
              continueBtn(context)
            ],
          ),
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

  Column actionsInfo(context) {
    return Column(
      children: [
        const Icon(
          Icons.account_circle,
          color: Color(0xff80ADD7),
          size: 180,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Welcome back, \n$username!',
          style: const TextStyle(fontSize: 32, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 30,
        ),
        const Text('Not your account?'),
        ElevatedButton(
            onPressed: () => {Navigator.pushNamed(context, '/SignIn')},
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                foregroundColor:
                    MaterialStateProperty.all(const Color(0xFF4A92FD))),
            child: const Text('Log in with another account')),
      ],
    );
  }

  AppBar titleWidget() {
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
    );
  }
}
