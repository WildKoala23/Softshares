import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyLoginIn extends StatelessWidget {
  final String username;

  const MyLoginIn({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: titleWidget(colorScheme),
      body: Padding(
        padding: const EdgeInsets.only(top: 65.0, bottom: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [actionsInfo(context, colorScheme), continueBtn(context, colorScheme)],
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
          onPressed: () => {Navigator.pushNamed(context, '/home')},
          child: const Text('Continue')),
    );
  }

  Column actionsInfo(context, ColorScheme colorScheme) {
    return Column(
      children: [
         Icon(
          Icons.account_circle,
          color: colorScheme.primary,
          size: 180,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Welcome back, \n$username!',
          style:  TextStyle(fontSize: 32, color: colorScheme.onSecondary),
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
                    MaterialStateProperty.all( colorScheme.primary)),
            child: const Text('Log in with another account')),
      ],
    );
  }

  AppBar titleWidget(ColorScheme colorScheme) {
    return AppBar(
      centerTitle: true,
      leading: const Icon(null),
      title: RichText(
        text:  TextSpan(
            text: 'Soft',
            style: TextStyle(color: Colors.black, fontSize: 36),
            children: <TextSpan>[
              TextSpan(
                  text: 'Shares',
                  style: TextStyle(color: colorScheme.secondary, fontSize: 36))
            ]),
      ),
    );
  }
}
