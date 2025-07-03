import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderRemediesFormScreen extends StatefulWidget {
  @override
  _OrderRemediesFormScreenState createState() =>
      _OrderRemediesFormScreenState();
}

class _OrderRemediesFormScreenState extends State<OrderRemediesFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  Future<void> _selectDOB(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool enable = true, int maxlines = 1, VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      enabled: enable,
      maxLines: maxlines,
      readOnly: onTap != null,
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order submitted"),
          backgroundColor: Colors.green,
        ),
      );

      // Simulate redirect after delay
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Place Order"),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(nameController, 'Name'),
              const SizedBox(height: 12),
              _buildTextField(emailController, 'Email'),
              const SizedBox(height: 12),
              _buildTextField(mobileController, 'Mobile'),
              const SizedBox(height: 12),
              _buildTextField(dobController, 'Date of Birth',
                  onTap: () => _selectDOB(context)),
              const SizedBox(height: 12),
              _buildTextField(landmarkController, 'Landmark'),
              const SizedBox(height: 12),
              _buildTextField(countryController, 'Country'),
              const SizedBox(height: 12),
              _buildTextField(stateController, 'State'),
              const SizedBox(height: 12),
              _buildTextField(cityController, 'City'),
              const SizedBox(height: 12),
              _buildTextField(pincodeController, 'Pincode'),
              const SizedBox(height: 12),
              _buildTextField(addressController, 'Address', maxlines: 2),
              const SizedBox(height: 12),
              _buildTextField(commentController, 'Comment', maxlines: 2),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _submitOrder,
                    child: const Text('Submit Order'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
