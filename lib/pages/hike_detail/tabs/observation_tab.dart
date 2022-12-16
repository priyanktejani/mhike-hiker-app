import 'package:flutter/material.dart';
import 'package:mhike/services/crud/m_hike_service.dart';
import 'package:mhike/services/crud/model/hike.dart';
import 'package:mhike/services/crud/model/observation.dart';

class ObservationTab extends StatefulWidget {
  final Hike hike;
  const ObservationTab({
    super.key,
    required this.hike,
  });

  @override
  State<ObservationTab> createState() => _ObservationTabState();
}

class _ObservationTabState extends State<ObservationTab> {
  late final MHikeService _mHikeService;
  late final TextEditingController _observationTitleController;
  late final TextEditingController _observationDetailController;

  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  final observationsCategory = [
    "Sightings of animals",
    "Types of vegetation",
    "Weather conditions",
    "Trails conditions",
    "Other"
  ];
  String _selectedObservationsCategory = "Sightings of animals";

  @override
  void initState() {
    _mHikeService = MHikeService();
    _observationTitleController = TextEditingController();
    _observationDetailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _observationTitleController.dispose();
    _observationDetailController.dispose();
    super.dispose();
  }

  Future addNewObservation() async {
    // get form details
    final observationTitle = _observationTitleController.text;
    final observationCategory = _selectedObservationsCategory;
    final observationDetail = _observationDetailController.text;
    final dateTime = DateTime.now();

    // create new hike object
    Observation newObservation = Observation(
      hikeId: widget.hike.id!,
      observationTitle: observationTitle,
      observationCategory: observationCategory,
      observationDetail: observationDetail,
      dateTime: dateTime,
    );

    // add observation
    _mHikeService.addObservation(
      hike: widget.hike,
      newObservation: newObservation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: StreamBuilder(
        stream: _mHikeService.allObservations,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allObservations = snapshot.data as List<Observation>;
                final hikeObservations = allObservations
                    .where(
                        (observations) => observations.hikeId == widget.hike.id)
                    .toList();
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hikeObservations.length + 1,
                  separatorBuilder: (context, index) => const Divider(
                    height: 12,
                    color: Colors.transparent,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 55, 59, 87),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _observationTitleController,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  fillColor: Colors.white12,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 20,
                                  ),
                                  hintText: 'Observation',
                                  border: OutlineInputBorder(
                                    borderSide:
                                        Divider.createBorderSide(context),
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        Divider.createBorderSide(context),
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        Divider.createBorderSide(context),
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
                                color: Colors.transparent,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField(
                                    borderRadius: BorderRadius.circular(22),
                                    dropdownColor: const Color(0xFF4f536b),
                                    isExpanded: true,
                                    value: _selectedObservationsCategory,
                                    items: observationsCategory
                                        .map(buildMenuItem)
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedObservationsCategory = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Can\'t be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.transparent,
                              ),
                              TextFormField(
                                controller: _observationDetailController,
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  fillColor: Colors.white12,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 20,
                                  ),
                                  hintText: 'Detail',
                                  border: OutlineInputBorder(
                                    borderSide:
                                        Divider.createBorderSide(context),
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        Divider.createBorderSide(context),
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        Divider.createBorderSide(context),
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  filled: true,
                                ),
                              ),
                              const Divider(
                                color: Colors.transparent,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    addNewObservation();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(
                                    double.infinity,
                                    56,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  backgroundColor: const Color(0xff282b41),
                                ),
                                child: const Text(
                                  'Add',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final observation = hikeObservations[index - 1];
                    if (observation.hikeId == widget.hike.id) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 55, 59, 87),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              observation.observationTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(
                              color: Colors.transparent,
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.5,
                                vertical: 5,
                              ),
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Text(
                                observation.observationCategory,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.transparent,
                            ),
                            Text(
                              observation.observationDetail,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No Observation',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                );
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
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
