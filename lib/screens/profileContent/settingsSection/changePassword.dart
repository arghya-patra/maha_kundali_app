import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reEnterNewPasswordController =
      TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isReEnterNewPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPasswordField(
              controller: _oldPasswordController,
              label: 'Old Password',
              isPasswordVisible: _isOldPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isOldPasswordVisible = !_isOldPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 16.0),
            _buildPasswordField(
              controller: _newPasswordController,
              label: 'New Password',
              isPasswordVisible: _isNewPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 16.0),
            _buildPasswordField(
              controller: _reEnterNewPasswordController,
              label: 'Re-enter New Password',
              isPasswordVisible: _isReEnterNewPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isReEnterNewPasswordVisible = !_isReEnterNewPasswordVisible;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement save functionality here
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isPasswordVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
    );
  }
}
