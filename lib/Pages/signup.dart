import 'package:dev_icons/dev_icons.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

List<String> cities = ['Viseu', 'Tomar', 'Portoalegre', 'Fundão', 'Vilareal'];

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late String selectedCity;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCity = cities[0];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: myAppBar(context, colorScheme),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                    cityField(colorScheme)
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
            if (_formKey.currentState!.validate()) {
              // If the form is valid, continue to homepage
              //Later, implement verification with DB
              Navigator.pushNamed(context, '/home');
            }
          },
          child: const Text('Continue')),
    );
  }

  Container emailField(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter email';
          }
          return null;
        },
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
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter first name';
          }
          return null;
        },
        controller: firstNameController,
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
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter last name';
          }
          return null;
        },
        controller: lastNameController,
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

  Container cityField(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(7)),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Text('Select Area'),
        underline: SizedBox.shrink(),
        value: selectedCity,
        items: cities.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCity = value!;
          });
        },
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
              foregroundColor: colorScheme.onSecondary,
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
