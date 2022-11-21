import 'package:flutter/material.dart';

class ObservationTab extends StatefulWidget {
  const ObservationTab({super.key});

  @override
  State<ObservationTab> createState() => _ObservationTabState();
}

class _ObservationTabState extends State<ObservationTab> {
  late final TextEditingController _observationController;
  late final TextEditingController _observationDetailController;

  final observationsCategory = [
    "Sightings of animals",
    "Types of vegetation",
    "Weather conditions" "Trails conditions",
    "Other"
  ];

  String? selectedObservationsCategory = "Sightings of animals";

  @override
  void initState() {
    _observationController = TextEditingController();
    _observationDetailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _observationController.dispose();
    _observationDetailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _observationController,
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
                    color: Colors.transparent,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        borderRadius: BorderRadius.circular(22),
                        dropdownColor: const Color(0xFF4f536b),
                        isExpanded: true,
                        value: selectedObservationsCategory,
                        items: observationsCategory.map(buildMenuItem).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedObservationsCategory = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  TextField(
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
            );
          }
          return Container(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 55, 59, 87),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trafalgar Tavern to Greenwich Park',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
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
                  child: const Text(
                    'Weather',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                const Text(
                  'The Palace of Westminster was destroyed by fire in 1834. In 1844, it was decided the new buildings for the Houses of Parliament should include a tower and a clock. A massive bell was required and the first attempt (made by John Warner & Sons at Stockton-on-Tees) cracked irreparably. The metal was melted down and the bell recast in Whitechapel in 1858. Big Ben first rang across Westminster on 31 May 1859.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
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
