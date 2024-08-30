import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _RecoveryState();
}

class _RecoveryState extends State<ChangePassword> {
  TextEditingController newPassCx = TextEditingController();
  TextEditingController confirmPasslCx = TextEditingController();

  bool hidePassword = true;
  bool hideConfirm = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: myAppBar(colorScheme),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 18.0),
                    child: Text(
                      'Recover password',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  continueBtn(
                      colorScheme: colorScheme,
                      onContinue: () {
                        //Add logic
                      })
                ],
              ),
            )),
      ),
    );
  }

  Container continueBtn({
    required ColorScheme colorScheme,
    required VoidCallback onContinue,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
        ),
        onPressed: onContinue,
        child: const Text('Continue'),
      ),
    );
  }

  AppBar myAppBar(ColorScheme colorScheme) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back),
      ),
      title: RichText(
        text: TextSpan(
          text: 'Soft',
          style: TextStyle(color: colorScheme.onSecondary, fontSize: 36),
          children: <TextSpan>[
            TextSpan(
              text: 'Shares',
              style: TextStyle(color: colorScheme.secondary, fontSize: 36),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
