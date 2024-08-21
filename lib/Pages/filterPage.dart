import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  void rightCallback(context) {
    print('Hello :)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          iconR: Icon(Icons.check),
          title: 'Filter',
          rightCallback: rightCallback),
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 14.0),
              child: SizedBox(
                child: Text(
                  'Rating',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            RatingFilter(),
            const Padding(
              padding: EdgeInsets.only(bottom: 14.0, top: 75),
              child: SizedBox(
                child: Text(
                  'Price',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            PriceFilter(),
          ],
        ),
      ),
    );
  }
}

class RatingFilter extends StatefulWidget {
  @override
  _RatingFilterState createState() => _RatingFilterState();
}

class _RatingFilterState extends State<RatingFilter> {
  List<bool> isSelected = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the width available for each button
          double buttonWidth = (constraints.maxWidth / isSelected.length) - 6;

          return ToggleButtons(
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                isSelected[index] =
                    !isSelected[index]; // Toggle the selected state
              });
            },
            borderRadius: BorderRadius.circular(8.0),
            selectedColor: colorScheme.onPrimary,
            fillColor: colorScheme.primary,
            constraints: BoxConstraints(
              minHeight: 50.0,
              minWidth: buttonWidth,
            ),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('1'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('2'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('3'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('4'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('5'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PriceFilter extends StatefulWidget {
  @override
  _PriceFilterState createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  List<bool> isSelected = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the width available for each button
          double buttonWidth = (constraints.maxWidth / isSelected.length) - 6;

          return ToggleButtons(
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                isSelected[index] =
                    !isSelected[index]; // Toggle the selected state
              });
            },
            borderRadius: BorderRadius.circular(8.0),
            selectedColor: colorScheme.onPrimary,
            fillColor: colorScheme.primary,
            constraints: BoxConstraints(
              minHeight: 50.0,
              minWidth: buttonWidth,
            ),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('1'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('2'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('3'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('4'),
              ),
            ],
          );
        },
      ),
    );
  }
}
