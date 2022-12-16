import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mhike/constants/routes.dart';
import 'package:mhike/services/auth/auth_service.dart';
import 'package:mhike/services/crud/m_hike_service.dart';
import 'package:mhike/services/crud/model/hike.dart';
import 'package:mhike/utilities/generics/get_arguments.dart';
import 'package:mhike/utilities/utility.dart';

class AddHikePage extends StatefulWidget {
  const AddHikePage({super.key});

  @override
  State<AddHikePage> createState() => _AddHikePageState();
}

class _AddHikePageState extends State<AddHikePage> {
  late final MHikeService _mHikeService;

  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  String? _coverImage;

  Hike? _hike;

  late final TextEditingController _titleController;
  late final TextEditingController _lengthController;
  late final TextEditingController _estimatedTimeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;

  final difficultyLevels = [
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

  String? _selectedDifficultyLevel;
  String? _selectedParkingAvailability;
  Hike? widgetHike;

  DateTime _currentOrSelectedOrDateTime = DateTime.now();
  String _date = "Select Hike Date";

  @override
  void initState() {
    _mHikeService = MHikeService();
    _titleController = TextEditingController();
    _lengthController = TextEditingController();
    _estimatedTimeController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _lengthController.dispose();
    _estimatedTimeController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<Hike?> getHikeDetail(BuildContext context) async {
    final widgetHike = context.getArgument<Hike>();

    if (widgetHike != null) {
      _hike = widgetHike;
      _coverImage = widgetHike.coverImage;
      _titleController.text = widgetHike.title;
      _date = DateFormat('yyyy-MM-dd').format(widgetHike.dateTime);
      _selectedDifficultyLevel = widgetHike.difficultyLevel;
      _selectedParkingAvailability =
          widgetHike.parkingAvailability ? 'Yes' : 'No';

      _locationController.text = widgetHike.location;
      _lengthController.text = widgetHike.length.toString();
      _estimatedTimeController.text = widgetHike.estimatedTime;
      if (widgetHike.description != null) {
        _descriptionController.text = widgetHike.description!;
      }

      return widgetHike;
    }
    return null;
  }

  Future addNewOrUpdateHike() async {
    // get current user
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final user = await _mHikeService.getUser(null, email);

    // get form details
    final title = _titleController.text;
    final dateTime = _currentOrSelectedOrDateTime;
    final difficultyLevel = _selectedDifficultyLevel;
    final parkingAvailability =
        _selectedParkingAvailability == 'Yes' ? true : false;
    double length = double.parse(_lengthController.text);
    final estimatedTime = _estimatedTimeController.text;
    final location = _locationController.text;
    final description = _descriptionController.text;

    // if hike not null than update
    if (_hike != null) {
      Hike updateHike = Hike(
        id: _hike!.id,
        userEmail: _hike!.userEmail,
        coverImage: _coverImage!,
        title: title,
        dateTime: dateTime,
        difficultyLevel: difficultyLevel!,
        parkingAvailability: parkingAvailability,
        location: location,
        length: length,
        estimatedTime: estimatedTime,
        description: description,
      );

      _mHikeService.updateHike(hike: updateHike);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        hikeDetailRoute,
        arguments: updateHike,
      );
    } else {
      // create new hike object and add new
      Hike newHike = Hike(
        userEmail: email,
        title: title,
        coverImage: _coverImage!,
        dateTime: dateTime,
        difficultyLevel: difficultyLevel!,
        parkingAvailability: parkingAvailability,
        location: location,
        length: length,
        estimatedTime: estimatedTime,
        description: description,
      );
      _mHikeService.addHike(
        user: user,
        newHike: newHike,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        homeRoute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff282b41),
      appBar: AppBar(
        backgroundColor: const Color(0xff282b41),
        elevation: 0,
        title: const Text('Edit or Add Hike'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  addNewOrUpdateHike();
                }
              },
              icon: Image.asset(
                'assets/images/plus.png',
                color: Colors.white,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: getHikeDetail(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 55, 59, 87),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: IconButton(
                                iconSize: 160,
                                onPressed: () async {
                                  ImagePicker()
                                      .pickImage(source: ImageSource.gallery)
                                      .then((imgFile) async {
                                    String imgString = Utility.base64String(
                                        await imgFile!.readAsBytes());

                                    setState(() {
                                      _coverImage = imgString;
                                    });
                                  });
                                },
                                icon: _coverImage != null
                                    ? Image.memory(
                                        Utility.dataFromBase64String(
                                          _coverImage!,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/icons/add-image.png',
                                        color: Colors.white12,
                                      ),
                              ),
                            ),

                            const Divider(
                              height: 14,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              controller: _titleController,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Can\'t be empty';
                                }
                                return null;
                              },
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
                                          _date =
                                              DateFormat('yyyy-MM-dd').format(
                                            _currentOrSelectedOrDateTime,
                                          );
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _date.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                  hint: const Text("Difficulty level"),
                                  borderRadius: BorderRadius.circular(22),
                                  dropdownColor: const Color(0xFF4f536b),
                                  isExpanded: true,
                                  value: _selectedDifficultyLevel,
                                  items: difficultyLevels
                                      .map(buildMenuItem)
                                      .toList(),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        _selectedDifficultyLevel = value;
                                      },
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select difficulty level';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const Divider(
                              height: 14,
                              color: Colors.transparent,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                  hint: const Text("Parking Availability"),
                                  borderRadius: BorderRadius.circular(22),
                                  dropdownColor: const Color(0xFF4f536b),
                                  isExpanded: true,
                                  value: _selectedParkingAvailability,
                                  items: parkingAvailability
                                      .map(buildMenuItem)
                                      .toList(),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        _selectedParkingAvailability = value;
                                      },
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select parking availability';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const Divider(
                              height: 14,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              controller: _lengthController,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Can\'t be empty';
                                }
                                return null;
                              },
                            ),
                            const Divider(
                              height: 14,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              controller: _locationController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: InputDecoration(
                                fillColor: Colors.white12,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 20,
                                ),
                                hintText: 'Location',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Can\'t be empty';
                                }
                                return null;
                              },
                            ),
                            const Divider(
                              height: 14,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              controller: _estimatedTimeController,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              decoration: InputDecoration(
                                fillColor: Colors.white12,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 20,
                                ),
                                hintText: 'Estimated time',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Can\'t be empty';
                                }
                                return null;
                              },
                            ),
                            const Divider(
                              height: 14,
                              color: Colors.transparent,
                            ),
                            TextField(
                              controller: _descriptionController,
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

              default:
                return const CircularProgressIndicator();
            }
          }),
      //  SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      //     child: Container(
      //       padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
      //       decoration: BoxDecoration(
      //         color: const Color.fromARGB(255, 55, 59, 87),
      //         borderRadius: BorderRadius.circular(22),
      //       ),
      //       child: Column(
      //         children: [
      //           Material(
      //             color: Colors.transparent,
      //             child: IconButton(
      //               iconSize: 160,
      //               onPressed: () {
      //                 print('object');
      //               },
      //               icon: Image.asset(
      //                 'assets/images/add-image.png',
      //                 color: Colors.white12,
      //               ),
      //             ),
      //           ),

      //           const Divider(
      //             height: 14,
      //             color: Colors.transparent,
      //           ),
      //           TextField(
      //             controller: _titleController,
      //             keyboardType: TextInputType.text,
      //             maxLines: 1,
      //             decoration: InputDecoration(
      //               fillColor: Colors.white12,
      //               contentPadding: const EdgeInsets.symmetric(
      //                 horizontal: 24,
      //                 vertical: 20,
      //               ),
      //               hintText: 'Hike place name',
      //               border: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               enabledBorder: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               focusedBorder: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               filled: true,
      //             ),
      //           ),
      //           const Divider(
      //             height: 14,
      //             color: Colors.transparent,
      //           ),
      //           // date picker
      //           ElevatedButton(
      //             onPressed: () {
      //               showDatePicker(
      //                 context: context,
      //                 initialDate: _currentOrSelectedOrDateTime,
      //                 firstDate: DateTime(2000),
      //                 lastDate: DateTime(2050),
      //                 helpText: 'Select Hike Date',
      //               ).then(
      //                 (value) {
      //                   if (value != null) {
      //                     setState(
      //                       () {
      //                         _currentOrSelectedOrDateTime = value;
      //                         _date = DateFormat('yyyy-MM-dd')
      //                             .format(_currentOrSelectedOrDateTime);
      //                       },
      //                     );
      //                   }
      //                 },
      //               );
      //             },
      //             style: ElevatedButton.styleFrom(
      //               alignment: Alignment.centerLeft,
      //               backgroundColor: Colors.white12,
      //               minimumSize: const Size(double.infinity, 60),
      //               elevation: 0,
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(22),
      //               ),
      //             ),
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 8),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Text(
      //                     _date.toString(),
      //                     style: const TextStyle(color: Colors.white),
      //                   ),
      //                   const Text(
      //                     'Select',
      //                     style: TextStyle(color: Colors.white60),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           const Divider(
      //             height: 14,
      //             color: Colors.transparent,
      //           ),
      //           Container(
      //             padding:
      //                 const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      //             decoration: BoxDecoration(
      //               color: Colors.white12,
      //               borderRadius: BorderRadius.circular(22),
      //             ),
      //             child: DropdownButtonHideUnderline(
      //               child: DropdownButton(
      //                 hint: const Text("Difficulty level"),
      //                 borderRadius: BorderRadius.circular(22),
      //                 dropdownColor: const Color(0xFF4f536b),
      //                 isExpanded: true,
      //                 value: selectedDifficultyLevel,
      //                 items: difficultyLevels.map(buildMenuItem).toList(),
      //                 onChanged: (value) {
      //                   setState(
      //                     () {
      //                       selectedDifficultyLevel = value;
      //                     },
      //                   );
      //                 },
      //               ),
      //             ),
      //           ),
      //           const Divider(
      //             height: 14,
      //             color: Colors.transparent,
      //           ),
      //           Container(
      //             padding:
      //                 const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      //             decoration: BoxDecoration(
      //               color: Colors.white12,
      //               borderRadius: BorderRadius.circular(22),
      //             ),
      //             child: DropdownButtonHideUnderline(
      //               child: DropdownButton(
      //                 hint: const Text("Parking Availability"),
      //                 borderRadius: BorderRadius.circular(22),
      //                 dropdownColor: const Color(0xFF4f536b),
      //                 isExpanded: true,
      //                 value: selectedParkingAvailability,
      //                 items: parkingAvailability.map(buildMenuItem).toList(),
      //                 onChanged: (value) {
      //                   setState(
      //                     () {
      //                       selectedParkingAvailability = value;
      //                     },
      //                   );
      //                 },
      //               ),
      //             ),
      //           ),
      //           const Divider(
      //             height: 14,
      //             color: Colors.transparent,
      //           ),
      //           TextField(
      //             controller: _lengthController,
      //             keyboardType: TextInputType.number,
      //             maxLines: 1,
      //             decoration: InputDecoration(
      //               fillColor: Colors.white12,
      //               contentPadding: const EdgeInsets.symmetric(
      //                 horizontal: 24,
      //                 vertical: 20,
      //               ),
      //               hintText: 'Hike length (in miles)',
      //               border: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               enabledBorder: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               focusedBorder: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               filled: true,
      //             ),
      //           ),
      //           const Divider(
      //             height: 14,
      //             color: Colors.transparent,
      //           ),
      //           TextField(
      //             controller: _estimatedTimeController,
      //             keyboardType: TextInputType.text,
      //             maxLines: 1,
      //             decoration: InputDecoration(
      //               fillColor: Colors.white12,
      //               contentPadding: const EdgeInsets.symmetric(
      //                 horizontal: 24,
      //                 vertical: 20,
      //               ),
      //               hintText: 'Estimated time',
      //               border: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               enabledBorder: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               focusedBorder: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               filled: true,
      //             ),
      //           ),
      //           const Divider(
      //             height: 14,
      //             color: Colors.transparent,
      //           ),
      //           TextField(
      //             controller: _descriptionController,
      //             keyboardType: TextInputType.text,
      //             maxLines: 6,
      //             decoration: InputDecoration(
      //               fillColor: Colors.white12,
      //               contentPadding: const EdgeInsets.symmetric(
      //                 horizontal: 24,
      //                 vertical: 20,
      //               ),
      //               hintText: 'Description',
      //               border: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               enabledBorder: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               focusedBorder: OutlineInputBorder(
      //                 borderSide: Divider.createBorderSide(context),
      //                 borderRadius: BorderRadius.circular(22.0),
      //               ),
      //               filled: true,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
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
