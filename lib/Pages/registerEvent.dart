import 'package:flutter/material.dart';
import 'package:softshares/Components/customRadioBtn.dart';
import 'package:softshares/Components/customTextField.dart';
import 'package:softshares/Pages/customFieldTextForm.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/fieldClass.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.id});
  final int id;

  @override
  State<Register> createState() => _RegisterState();
}

Map<String, List<String>> formItens = {};

class _RegisterState extends State<Register> {
  final API api = API();
  List<Field> fields = [];
  List<Widget> widgets = [];
  List<TextEditingController> controllers = [];
  bool loaded = false;

  void buildForm() {
    List<Widget> aux = [];
    List<TextEditingController> aux_cx = [];
    for (var item in fields) {
      TextEditingController cx = TextEditingController();
      aux_cx.add(cx);
      switch (item.type) {
        case 'Text':
          aux.add(customTextField(
            label: item.name,
            numericInput: false,
            controller: cx,
          ));
          break;
        case 'Int':
          aux.add(customTextField(
            label: item.name,
            numericInput: true,
            controller: cx,
          ));
          break;
        case 'Radio':
          aux.add(customRadioBtn(
            label: item.name,
            options: item.options!,
            controller: cx,
          ));
          break;
      }
    }
    setState(() {
      controllers = aux_cx;
      widgets = aux;
      loaded = true;
    });
  }

  Future<void> getForm() async {
    fields = await api.getForm(widget.id);
    print('HERE');
    buildForm();
  }

  @override
  void initState() {
    super.initState();
    getForm();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              if (!loaded)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widgets.length,
                  itemBuilder: (context, index) {
                    return widgets[index];
                  },
                ),
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(colorScheme.onPrimary),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(colorScheme.primary)),
                onPressed: () {
                  for (var controller in controllers) {
                    print(controller.text);
                  }
                },
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
