//if the get api is used to fetch the product details
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsScreen extends StatefulWidget {
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Sample product data map with similar products
  final Map<String, dynamic> _product = {
    'title': 'Sample Product',
    'images': ['images/stone.jpeg', 'images/stone2.png', 'images/stone3.jpg'],
    'price': 999.99,
    'discountPrice': 799.99,
    'rating': 4,
    'numRatings': 125,
    'description':
        '• High quality\n• Affordable\n• Durable\n• Stylish\n• Great value for money',
    'reviews': [
      {'user': 'User 1', 'rating': 5, 'comment': 'Amazing product!'},
      {'user': 'User 2', 'rating': 4, 'comment': 'Very good quality.'},
      {'user': 'User 1', 'rating': 5, 'comment': 'Amazing product!'},
      {'user': 'User 2', 'rating': 4, 'comment': 'Very good quality.'},
      {'user': 'User 1', 'rating': 5, 'comment': 'Amazing product!'},
      {'user': 'User 2', 'rating': 4, 'comment': 'Very good quality.'},
      {'user': 'User 1', 'rating': 5, 'comment': 'Amazing product!'},
      {'user': 'User 2', 'rating': 4, 'comment': 'Very good quality.'},
      {'user': 'User 1', 'rating': 5, 'comment': 'Amazing product!'},
      {'user': 'User 2', 'rating': 4, 'comment': 'Very good quality.'},
      {'user': 'User 1', 'rating': 5, 'comment': 'Amazing product!'},
      {'user': 'User 2', 'rating': 4, 'comment': 'Very good quality.'},
      {'user': 'User 1', 'rating': 5, 'comment': 'Amazing product!'},
      {'user': 'User 2', 'rating': 4, 'comment': 'Very good quality.'},

      // Add more reviews here
    ],
    'similarProducts': [
      {
        'title': 'Similar Product 1',
        'image': 'images/book.png',
        'price': 799.99
      },
      {
        'title': 'Similar Product 2',
        'image': 'images/stone.jpeg',
        'price': 899.99
      },
      {
        'title': 'Similar Product 2',
        'image': 'images/show_piece.png',
        'price': 899.99
      },
      {
        'title': 'Similar Product 2',
        'image': 'images/stone.jpeg',
        'price': 899.99
      },
      {
        'title': 'Similar Product 1',
        'image': 'images/book.png',
        'price': 799.99
      },
      {
        'title': 'Similar Product 2',
        'image': 'images/stone.jpeg',
        'price': 899.99
      },
      {
        'title': 'Similar Product 2',
        'image': 'images/show_piece.png',
        'price': 899.99
      },
      {
        'title': 'Similar Product 2',
        'image': 'images/stone.jpeg',
        'price': 899.99
      },
      // Add more similar products here
    ],
    'otherProducts': [
      {
        'title': 'Other Product 1',
        'image': 'images/stone.jpeg',
        'price': 599.99
      },
      {'title': 'Other Product 2', 'image': 'images/book.png', 'price': 699.99},
      {
        'title': 'Other Product 1',
        'image': 'images/stone.jpeg',
        'price': 599.99
      },
      {'title': 'Other Product 2', 'image': 'images/book.png', 'price': 699.99},
      {
        'title': 'Other Product 1',
        'image': 'images/stone.jpeg',
        'price': 599.99
      },
      {'title': 'Other Product 2', 'image': 'images/book.png', 'price': 699.99},
      {
        'title': 'Other Product 1',
        'image': 'images/stone.jpeg',
        'price': 599.99
      },
      {'title': 'Other Product 2', 'image': 'images/book.png', 'price': 699.99},
      {
        'title': 'Other Product 1',
        'image': 'images/stone.jpeg',
        'price': 599.99
      },
      {'title': 'Other Product 2', 'image': 'images/book.png', 'price': 699.99},
      {
        'title': 'Other Product 1',
        'image': 'images/stone.jpeg',
        'price': 599.99
      },
      {'title': 'Other Product 2', 'image': 'images/book.png', 'price': 699.99},
      {
        'title': 'Other Product 1',
        'image': 'images/stone.jpeg',
        'price': 599.99
      },
      {'title': 'Other Product 2', 'image': 'images/book.png', 'price': 699.99},
      {
        'title': 'Other Product 1',
        'image': 'images/stone.jpeg',
        'price': 599.99
      },
      {'title': 'Other Product 2', 'image': 'images/book.png', 'price': 699.99},
      // Add more products here
    ],
    'isFavorite': false,
  };

  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isLoadingMoreProducts = true;

  @override
  void initState() {
    super.initState();
    _isFavorite = _product['isFavorite'];
    // Simulate loading similar products and reviews
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoadingMoreProducts = false;
      });
    });
  }

  void _addToWishlist() {
    setState(() {
      _isFavorite = !_isFavorite;
      _product['isFavorite'] = _isFavorite;
    });
  }

  void _showFullDescription(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Description',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 8),
                Text(
                  _product['description'],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImageModal(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(image),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product['title']),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _addToWishlist,
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Handle cart screen navigation
                },
              ),
              const Positioned(
                right: 4,
                top: 4,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    "1", // Replace with dynamic cart count
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSlider(
                  items: (_product['images'] as List<String>).map((image) {
                    return GestureDetector(
                      onTap: () {
                        _showImageModal(context, image);
                      },
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 300,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                      size: 30,
                    ),
                    onPressed: _addToWishlist,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (_product['images'] as List<String>).map((url) {
                int index = (_product['images'] as List<String>).indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? Colors.orange
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _product['title'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < _product['rating']
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow[700],
                        size: 20,
                      );
                    }),
                  ),
                ),
                Text(
                  "(${_product['numRatings']} reviews)",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.grey),
                  onPressed: () {
                    Share.share('Check out this product: ${_product['title']}');
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "₹${_product['discountPrice'] * _quantity}",
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "₹${_product['price']}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() {
                            if (_quantity > 1) _quantity--;
                          });
                        },
                      ),
                      Text(
                        _quantity.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Colors.orange,
                    labelColor: Colors.orange,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Description"),
                      Tab(text: "Reviews"),
                    ],
                  ),
                  Container(
                    height: 200,
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Product Description",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _product['description'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  _showFullDescription(context);
                                  // Show full description in modal or navigate to a new screen
                                },
                                child: const Text(
                                  "Show more",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _isLoadingMoreProducts
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: ListView.builder(
                                    itemCount: 5, // Number of reviews to show
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(8.0),
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.grey,
                                        ),
                                        title: Container(
                                          color: Colors.grey,
                                          height: 10,
                                          width: 100,
                                        ),
                                        subtitle: Container(
                                          color: Colors.grey,
                                          height: 10,
                                          width: 150,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      (_product['reviews'] as List).length,
                                  itemBuilder: (context, index) {
                                    final review = _product['reviews'][index];
                                    return ListTile(
                                      //  tileColor: Colors.blueGrey[200],
                                      contentPadding: const EdgeInsets.all(8.0),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Text(
                                          review['user'][0],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      title: Text(review['user']),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: List.generate(
                                              5,
                                              (starIndex) => Icon(
                                                starIndex < review['rating']
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: Colors.yellow[700],
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(review['comment']),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //   const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Similar Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _isLoadingMoreProducts
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8, // Number of similar products to show
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  )
                : SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (_product['similarProducts'] as List).length,
                      itemBuilder: (context, index) {
                        final similarProduct =
                            _product['similarProducts'][index];
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  similarProduct['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                similarProduct['title'],
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '₹${similarProduct['price']}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Other Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _isLoadingMoreProducts
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 4, // Number of other products to show
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: (_product['otherProducts'] as List).length,
                    itemBuilder: (context, index) {
                      final otherProduct = _product['otherProducts'][index];
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.asset(
                                otherProduct['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              otherProduct['title'],
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '₹${otherProduct['price']}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle add to cart
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Add to Cart'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle buy now
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








// //If the data id coming from last screen
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:share_plus/share_plus.dart';

// class ProductDetailsScreen extends StatefulWidget {
//   final Map<String, dynamic> product;

//   ProductDetailsScreen({required this.product});

//   @override
//   _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
// }

// class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
//   int _currentImageIndex = 0;
//   int _quantity = 1;
//   bool _isFavorite = false;

//   @override
//   void initState() {
//     super.initState();
//     _isFavorite = widget.product['isFavorite'];
//   }

//   void _addToWishlist() {
//     setState(() {
//       _isFavorite = !_isFavorite;
//       widget.product['isFavorite'] = _isFavorite;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product['title']),
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: Icon(
//                   _isFavorite ? Icons.favorite : Icons.favorite_border,
//                   color: _isFavorite ? Colors.red : Colors.white,
//                 ),
//                 onPressed: _addToWishlist,
//               ),
//               // You can add wishlist count here if needed
//             ],
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart),
//                 onPressed: () {
//                   // Handle cart screen navigation
//                 },
//               ),
//               // Show cart item count
//               const Positioned(
//                 right: 4,
//                 top: 4,
//                 child: CircleAvatar(
//                   radius: 8,
//                   backgroundColor: Colors.red,
//                   child: Text(
//                     "1", // Replace with dynamic cart count
//                     style: TextStyle(fontSize: 12, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 CarouselSlider(
//                   items:
//                       (widget.product['images'] as List<String>).map((image) {
//                     return GestureDetector(
//                       onTap: () {
//                         _showImageModal(context, image);
//                       },
//                       child: Image.asset(
//                         image,
//                         fit: BoxFit.cover,
//                         width: MediaQuery.of(context).size.width,
//                       ),
//                     );
//                   }).toList(),
//                   options: CarouselOptions(
//                     height: 300,
//                     viewportFraction: 1.0,
//                     onPageChanged: (index, reason) {
//                       setState(() {
//                         _currentImageIndex = index;
//                       });
//                     },
//                   ),
//                 ),
//                 Positioned(
//                   right: 10,
//                   top: 10,
//                   child: IconButton(
//                     icon: Icon(
//                       _isFavorite ? Icons.favorite : Icons.favorite_border,
//                       color: _isFavorite ? Colors.red : Colors.white,
//                       size: 30,
//                     ),
//                     onPressed: _addToWishlist,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: (widget.product['images'] as List<String>).map((url) {
//                 int index = widget.product['images'].indexOf(url);
//                 return Container(
//                   width: 8.0,
//                   height: 8.0,
//                   margin: const EdgeInsets.symmetric(
//                       vertical: 10.0, horizontal: 2.0),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: _currentImageIndex == index
//                         ? Colors.orange
//                         : Colors.grey,
//                   ),
//                 );
//               }).toList(),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 widget.product['title'],
//                 style:
//                     const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Row(
//                     children: List.generate(5, (index) {
//                       return Icon(
//                         index < widget.product['rating']
//                             ? Icons.star
//                             : Icons.star_border,
//                         color: Colors.yellow[700],
//                         size: 20,
//                       );
//                     }),
//                   ),
//                 ),
//                 Text(
//                   "(${widget.product['numRatings']} reviews)",
//                   style: const TextStyle(color: Colors.grey, fontSize: 16),
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.share, color: Colors.grey),
//                   onPressed: () {
//                     Share.share(
//                         'Check out this product: ${widget.product['title']}');
//                   },
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Text(
//                     "₹${widget.product['price'] * _quantity}",
//                     style: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.red),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     "₹${widget.product['price']}",
//                     style: const TextStyle(
//                       fontSize: 20,
//                       color: Colors.grey,
//                       decoration: TextDecoration.lineThrough,
//                     ),
//                   ),
//                   const Spacer(),
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.remove_circle_outline),
//                         onPressed: () {
//                           setState(() {
//                             if (_quantity > 1) _quantity--;
//                           });
//                         },
//                       ),
//                       Text(
//                         _quantity.toString(),
//                         style: const TextStyle(fontSize: 20),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.add_circle_outline),
//                         onPressed: () {
//                           setState(() {
//                             _quantity++;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             DefaultTabController(
//               length: 2,
//               child: Column(
//                 children: [
//                   const TabBar(
//                     indicatorColor: Colors.orange,
//                     labelColor: Colors.orange,
//                     unselectedLabelColor: Colors.grey,
//                     tabs: [
//                       Tab(text: "Description"),
//                       Tab(text: "Reviews"),
//                     ],
//                   ),
//                   Container(
//                     height: 300,
//                     child: TabBarView(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Product Description",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               const Text(
//                                 "• Point 1\n• Point 2\n• Point 3\n• Point 4\n• Point 5",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                               const SizedBox(height: 8),
//                               InkWell(
//                                 onTap: () {
//                                   // Show full description in modal or navigate to a new screen
//                                 },
//                                 child: const Text(
//                                   "Show more",
//                                   style: TextStyle(
//                                       color: Colors.blue,
//                                       fontSize: 16,
//                                       decoration: TextDecoration.underline),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ListView.builder(
//                             itemCount: 5,
//                             itemBuilder: (context, index) {
//                               return ListTile(
//                                 leading: CircleAvatar(
//                                   backgroundImage: AssetImage(
//                                       'images/review_user_${index + 1}.jpg'),
//                                 ),
//                                 title: Text("User ${index + 1}"),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: List.generate(5, (i) {
//                                         return Icon(
//                                           i < 4 // Assuming each review has 4 stars
//                                               ? Icons.star
//                                               : Icons.star_border,
//                                           color: Colors.yellow[700],
//                                           size: 16,
//                                         );
//                                       }),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     const Text("This is a great product!"),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Text(
//                 "₹${widget.product['price'] * _quantity}",
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const Spacer(),
//               ElevatedButton(
//                 onPressed: () {
//                   // Add to cart functionality
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                 ),
//                 child: const Text("Add to Cart"),
//               ),
//               const SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: () {
//                   // Buy now functionality
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                 ),
//                 child: const Text("Buy Now"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showImageModal(BuildContext context, String image) {
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         child: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Image.asset(image),
//         ),
//       ),
//     );
//   }
// }
