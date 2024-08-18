import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailsScreen extends StatefulWidget {
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final List<Map<String, dynamic>> orders = [
    {
      'image': 'images/book.png',
      'title': 'Product 1',
      'quantity': 1,
      'price': 29.99,
      'status': 'Delivered',
    },
    {
      'image': 'images/book.png',
      'title': 'Product 2',
      'quantity': 2,
      'price': 49.99,
      'status': 'Shipped',
    },
    {
      'image': 'images/book.png',
      'title': 'Product 3',
      'quantity': 1,
      'price': 19.99,
      'status': 'Delivered',
    },
  ];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showCancelOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Cancel Reason',
                  border: OutlineInputBorder(),
                ),
                items: ['Reason 1', 'Reason 2', 'Reason 3']
                    .map((reason) => DropdownMenuItem<String>(
                          value: reason,
                          child: Text(reason),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Additional Comments',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderTile(Map<String, dynamic> order, int index) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(order['image'], width: 80),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order['title'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Quantity: ${order['quantity']}'),
                      Text('Price: \$${order['price']}'),
                    ],
                  ),
                ),
                Icon(
                  order['status'] == 'Delivered'
                      ? Icons.check_circle
                      : Icons.local_shipping,
                  color: order['status'] == 'Delivered'
                      ? Colors.green
                      : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (order['status'] == 'Delivered') ...[
                  const Text('Rate Product: '),
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {
                      // Implement rating logic
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {
                      // Implement rating logic
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {
                      // Implement rating logic
                    },
                  ),
                ],
                const Spacer(),
                if (order['status'] != 'Delivered')
                  TextButton(
                    onPressed: () => _showCancelOptions(index),
                    child: const Text('Cancel Order',
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
            if (order['status'] == 'Delivered')
              TextButton(
                onPressed: () {
                  // Implement exchange logic
                },
                child: const Text('Exchange',
                    style: TextStyle(color: Colors.blue)),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
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
          ? ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 120,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderTile(orders[index], index);
              },
            ),
    );
  }
}
