import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Numerology/num_detail.dart';

class NumerologyScreen extends StatefulWidget {
  @override
  _NumerologyScreenState createState() => _NumerologyScreenState();
}

class _NumerologyScreenState extends State<NumerologyScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  TextEditingController _dobController = TextEditingController();
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });

    _blinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _blinkAnimation =
        Tween<double>(begin: 0.6, end: 1.0).animate(_blinkController);
  }

  @override
  void dispose() {
    _dobController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  int calculateRulingNumber(String dob) {
    List<int> digits = dob.split(RegExp(r'[\D]')).map(int.parse).toList();
    int sum = digits.fold(0, (a, b) => a + b);

    while (sum >= 10) {
      sum = sum.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return sum;
  }

  void _showRulingNumber(BuildContext context) {
    int rulingNumber = calculateRulingNumber(_dobController.text);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Your Ruling Number is $rulingNumber',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numerology'),
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
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    'Calculate And Select Your Ruling Number to Check Out Your Numerology Predictions',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return ScaleTransition(
                          scale: _blinkAnimation,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NumberDetailScreen(
                                          number: index + 1,
                                        )),
                              );
                              // Navigate to another screen
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/number_${index + 1}.webp',
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${[
                                      "One",
                                      "Two",
                                      "Three",
                                      "Four",
                                      "Five",
                                      "Six",
                                      "Seven",
                                      "Eight",
                                      "Nine"
                                    ][index]}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select Date of Birth',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        _dobController.text = formattedDate;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_dobController.text.isNotEmpty) {
                        _showRulingNumber(context);
                      }
                    },
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
