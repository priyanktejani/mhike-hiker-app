import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddHikePage extends StatefulWidget {
  const AddHikePage({super.key});

  @override
  State<AddHikePage> createState() => _AddHikePageState();
}

class _AddHikePageState extends State<AddHikePage> {
  final difficultyLevel = [
    "Easiest",
    "Easy",
    "Moderate",
    "Challenging",
    "Very Difficult",
  ];

  final parkingAvailability = [
    "Yes",
    "No",
  ];

  String? selectedDifficultyLevel;
  String? selectedparkingAvailability;

  DateTime _currentOrSelectedOrDateTime = DateTime.now();
  String _date = "Select Hike Date";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff282b41),
      appBar: AppBar(
        backgroundColor: const Color(0xff282b41),
        elevation: 0,
        title: const Text('Add Hike'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/plus.png',
                color: Colors.white,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 55, 59, 87),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    iconSize: 160,
                    onPressed: () {
                      print('object');
                    },
                    icon: Image.asset(
                      'assets/images/add-image.png',
                      color: Colors.white12,
                    ),
                  ),
                ),

                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                TextField(
                  // controller: _observationController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: InputDecoration(
                    fillColor: Colors.white12,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    hintText: 'Hike place name',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    filled: true,
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                // date picker
                ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: _currentOrSelectedOrDateTime,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
                      helpText: 'Select Hike Date',
                    ).then(
                      (value) {
                        if (value != null) {
                          setState(
                            () {
                              _currentOrSelectedOrDateTime = value;
                              _date = DateFormat('yyyy-MM-dd')
                                  .format(_currentOrSelectedOrDateTime);
                            },
                          );
                        }
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colors.white12,
                    minimumSize: const Size(double.infinity, 60),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _date.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Text(
                          'Select',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: const Text("Difficulty level"),
                      borderRadius: BorderRadius.circular(22),
                      dropdownColor: const Color(0xFF4f536b),
                      isExpanded: true,
                      value: selectedDifficultyLevel,
                      items: difficultyLevel.map(buildMenuItem).toList(),
                      onChanged: (value) {
                        setState(
                          () {
                            selectedDifficultyLevel = value;
                          },
                        );
                      },
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: const Text("Parking Availability"),
                      borderRadius: BorderRadius.circular(22),
                      dropdownColor: const Color(0xFF4f536b),
                      isExpanded: true,
                      value: selectedparkingAvailability,
                      items: parkingAvailability.map(buildMenuItem).toList(),
                      onChanged: (value) {
                        setState(
                          () {
                            selectedparkingAvailability = value;
                          },
                        );
                      },
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                TextField(
                  // controller: _observationController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: InputDecoration(
                    fillColor: Colors.white12,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    hintText: 'Hike length (in miles)',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    filled: true,
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                TextField(
                  // controller: _observationDetailController,
                  keyboardType: TextInputType.text,
                  maxLines: 6,
                  decoration: InputDecoration(
                    fillColor: Colors.white12,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    hintText: 'Description',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

DropdownMenuItem buildMenuItem(String item) {
  return DropdownMenuItem(
    value: item,
    child: Text(
      item,
    ),
  );
}
