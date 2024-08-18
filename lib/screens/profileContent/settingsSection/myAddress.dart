import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AddMyAddressScreen extends StatefulWidget {
  @override
  _AddMyAddressScreenState createState() => _AddMyAddressScreenState();
}

class _AddMyAddressScreenState extends State<AddMyAddressScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _addresses =
      []; // Dynamic list for addresses

  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  bool _isLoading = true; // Shimmer loading control
  int? _editingIndex; // Track which address is being edited

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Simulate loading data from API
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
        _addresses.addAll([
          // Example addresses
          {
            'addressLine1': '123 Main St',
            'addressLine2': 'Apt 4B',
            'district': 'Central',
            'state': 'State A',
            'pincode': '12345',
          },
          {
            'addressLine1': '456 Elm St',
            'addressLine2': 'Suite 100',
            'district': 'North',
            'state': 'State B',
            'pincode': '67890',
          },
        ]);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    setState(() {
      if (_editingIndex != null) {
        // Update existing address
        _addresses[_editingIndex!] = {
          'addressLine1': _addressLine1Controller.text,
          'addressLine2': _addressLine2Controller.text,
          'district': _districtController.text,
          'state': _stateController.text,
          'pincode': _pincodeController.text,
        };
        _editingIndex = null;
      } else {
        // Add new address
        _addresses.add({
          'addressLine1': _addressLine1Controller.text,
          'addressLine2': _addressLine2Controller.text,
          'district': _districtController.text,
          'state': _stateController.text,
          'pincode': _pincodeController.text,
        });
      }
      // Clear the form
      _addressLine1Controller.clear();
      _addressLine2Controller.clear();
      _districtController.clear();
      _stateController.clear();
      _pincodeController.clear();

      // Switch to the Saved Addresses tab
      _tabController.animateTo(0);
    });
  }

  void _editAddress(int index) {
    setState(() {
      _editingIndex = index;
      _addressLine1Controller.text = _addresses[index]['addressLine1'];
      _addressLine2Controller.text = _addresses[index]['addressLine2'];
      _districtController.text = _addresses[index]['district'];
      _stateController.text = _addresses[index]['state'];
      _pincodeController.text = _addresses[index]['pincode'];

      // Switch to the Add New Address tab
      _tabController.animateTo(1);
    });
  }

  void _deleteAddress(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Addresses'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Saved Addresses'),
              Tab(text: 'Add New Address'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _isLoading ? _buildShimmerLoading() : _buildAddressList(),
            _buildAddressForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressList() {
    return ListView.builder(
      itemCount: _addresses.length,
      itemBuilder: (context, index) {
        final address = _addresses[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title:
                Text('${address['addressLine1']}, ${address['addressLine2']}'),
            subtitle: Text(
                '${address['district']}, ${address['state']} - ${address['pincode']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editAddress(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteAddress(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextField(
            controller: _addressLine1Controller,
            decoration: const InputDecoration(labelText: 'Address Line 1'),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _addressLine2Controller,
            decoration: const InputDecoration(labelText: 'Address Line 2'),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _districtController,
            decoration: const InputDecoration(labelText: 'District'),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _stateController,
            decoration: const InputDecoration(labelText: 'State'),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _pincodeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Pincode'),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _saveAddress,
            child: Text(
              _editingIndex != null ? 'Update Address' : 'Save Address',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
