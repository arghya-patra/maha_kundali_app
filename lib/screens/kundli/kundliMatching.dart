import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/screens/kundli/matchReport.dart';
import 'package:shimmer/shimmer.dart';

class KundliMatchingScreen extends StatefulWidget {
  @override
  _KundliMatchingScreenState createState() => _KundliMatchingScreenState();
}

class _KundliMatchingScreenState extends State<KundliMatchingScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _boyNameController = TextEditingController();
  final TextEditingController _boyDobController = TextEditingController();
  final TextEditingController _boyTimeController = TextEditingController();
  final TextEditingController _boyPlaceController = TextEditingController();

  final TextEditingController _girlNameController = TextEditingController();
  final TextEditingController _girlDobController = TextEditingController();
  final TextEditingController _girlTimeController = TextEditingController();
  final TextEditingController _girlPlaceController = TextEditingController();

  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    _blinkAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_animationController);

    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _boyNameController.dispose();
    _boyDobController.dispose();
    _boyTimeController.dispose();
    _boyPlaceController.dispose();
    _girlNameController.dispose();
    _girlDobController.dispose();
    _girlTimeController.dispose();
    _girlPlaceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kundli Matching'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Container(height: 200, color: Colors.white),
                  const SizedBox(height: 20),
                  Container(height: 30, width: 200, color: Colors.white),
                  const SizedBox(height: 10),
                  Container(height: 15, color: Colors.white),
                  const SizedBox(height: 5),
                  Container(height: 15, width: 150, color: Colors.white),
                  const SizedBox(height: 30),
                  Container(height: 50, color: Colors.white),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kundli Matching",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Kundli Matching is a process that helps to match the horoscopes of the bride and groom before marriage.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  _buildFormSection(
                      title: "Enter Boy's Details",
                      nameController: _boyNameController,
                      dobController: _boyDobController,
                      timeController: _boyTimeController,
                      placeController: _boyPlaceController),
                  const SizedBox(height: 20),
                  Center(
                    child: FadeTransition(
                      opacity: _blinkAnimation,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFormSection(
                      title: "Enter Girl's Details",
                      nameController: _girlNameController,
                      dobController: _girlDobController,
                      timeController: _girlTimeController,
                      placeController: _girlPlaceController),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KundliMatchingResultScreen(),
                          ),
                        );
                        // Navigate to compatibility results screen
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        backgroundColor: Colors.orange,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text(
                        'Check Compatibility',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFormSection(
      {required String title,
      required TextEditingController nameController,
      required TextEditingController dobController,
      required TextEditingController timeController,
      required TextEditingController placeController}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 176, 184, 255),
              Color.fromARGB(255, 255, 191, 136)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: dobController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, dobController),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Time of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () => _selectTime(context, timeController),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: placeController,
                decoration: const InputDecoration(
                  labelText: 'Place of Birth',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
