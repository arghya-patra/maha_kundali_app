import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isLoading = true;
  TextEditingController _amountController = TextEditingController();

  List<int> _autoAmounts = [200, 500, 1000, 2000];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  void _onAutoAmountSelected(int amount) {
    setState(() {
      _amountController.text = amount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? _buildShimmerEffect()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWalletBalanceSection(),
                    const SizedBox(height: 20.0),
                    _buildAutoAmountSection(),
                    const SizedBox(height: 20.0),
                    _buildAddAmountField(),
                    const SizedBox(height: 20.0),
                    _buildAddButton(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 100.0,
            color: Colors.white,
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 60.0,
            color: Colors.white,
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 50.0,
            color: Colors.white,
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 50.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildWalletBalanceSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            'Available Balance',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '₹ 12,500',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoAmountSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _autoAmounts.map((amount) {
          return GestureDetector(
            onTap: () => _onAutoAmountSelected(amount),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.orange),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '₹ $amount',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Enter Amount',
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.account_balance_wallet, color: Colors.white),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle payment process
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        backgroundColor: Colors.orange,
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          WavyAnimatedText(
            'Add Amount',
            textStyle: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        isRepeatingAnimation: true,
      ),
    );
  }
}
