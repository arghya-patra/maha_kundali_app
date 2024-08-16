import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/productDetailScreen.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/wishListScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<Map<String, dynamic>> products = [
    {
      "id": 1,
      "title": "Gemstone",
      "image": "images/stone.jpeg",
      "price": 199.99,
      "discountedPrice": 149.99,
      "rating": 4.5,
      "numRatings": 120,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 2,
      "title": "Astrology Book",
      "image": "images/book.png",
      "price": 59.99,
      "discountedPrice": 49.99,
      "rating": 4.0,
      "numRatings": 85,
      "isOffer": false,
      "isFavorite": false,
    },
    {
      "id": 3,
      "title": "Show Piece",
      "image": "images/show_piece.png",
      "price": 299.99,
      "discountedPrice": 249.99,
      "rating": 4.8,
      "numRatings": 150,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 4,
      "title": "Gemstone",
      "image": "images/stone.jpeg",
      "price": 199.99,
      "discountedPrice": 149.99,
      "rating": 4.5,
      "numRatings": 120,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 5,
      "title": "Astrology Book",
      "image": "images/book.png",
      "price": 59.99,
      "discountedPrice": 49.99,
      "rating": 4.0,
      "numRatings": 85,
      "isOffer": false,
      "isFavorite": false,
    },
    {
      "id": 6,
      "title": "Show Piece",
      "image": "images/show_piece.png",
      "price": 299.99,
      "discountedPrice": 249.99,
      "rating": 4.8,
      "numRatings": 150,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 7,
      "title": "Gemstone",
      "image": "images/stone.jpeg",
      "price": 199.99,
      "discountedPrice": 149.99,
      "rating": 4.5,
      "numRatings": 120,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 8,
      "title": "Astrology Book",
      "image": "images/book.png",
      "price": 59.99,
      "discountedPrice": 49.99,
      "rating": 4.0,
      "numRatings": 85,
      "isOffer": false,
      "isFavorite": false,
    },
    {
      "id": 9,
      "title": "Show Piece",
      "image": "images/show_piece.png",
      "price": 299.99,
      "discountedPrice": 249.99,
      "rating": 4.8,
      "numRatings": 150,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 10,
      "title": "Gemstone",
      "image": "images/stone.jpeg",
      "price": 199.99,
      "discountedPrice": 149.99,
      "rating": 4.5,
      "numRatings": 120,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 11,
      "title": "Astrology Book",
      "image": "images/book.png",
      "price": 59.99,
      "discountedPrice": 49.99,
      "rating": 4.0,
      "numRatings": 85,
      "isOffer": false,
      "isFavorite": false,
    },
    {
      "id": 12,
      "title": "Show Piece",
      "image": "images/show_piece.png",
      "price": 299.99,
      "discountedPrice": 249.99,
      "rating": 4.8,
      "numRatings": 150,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 13,
      "title": "Gemstone",
      "image": "images/stone.jpeg",
      "price": 199.99,
      "discountedPrice": 149.99,
      "rating": 4.5,
      "numRatings": 120,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 14,
      "title": "Astrology Book",
      "image": "images/book.png",
      "price": 59.99,
      "discountedPrice": 49.99,
      "rating": 4.0,
      "numRatings": 85,
      "isOffer": false,
      "isFavorite": false,
    },
    {
      "id": 15,
      "title": "Show Piece",
      "image": "images/show_piece.png",
      "price": 299.99,
      "discountedPrice": 249.99,
      "rating": 4.8,
      "numRatings": 150,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 16,
      "title": "Gemstone",
      "image": "images/stone.jpeg",
      "price": 199.99,
      "discountedPrice": 149.99,
      "rating": 4.5,
      "numRatings": 120,
      "isOffer": true,
      "isFavorite": false,
    },
    {
      "id": 17,
      "title": "Astrology Book",
      "image": "images/book.png",
      "price": 59.99,
      "discountedPrice": 49.99,
      "rating": 4.0,
      "numRatings": 85,
      "isOffer": false,
      "isFavorite": false,
    },
    {
      "id": 18,
      "title": "Show Piece",
      "image": "images/show_piece.png",
      "price": 299.99,
      "discountedPrice": 249.99,
      "rating": 4.8,
      "numRatings": 150,
      "isOffer": true,
      "isFavorite": false,
    }
    // Add more products here
  ];

  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> wishlist = [];
  String searchQuery = "";

  @override
  @override
  Widget build(BuildContext context) {
    // Filter the products based on the search query
    List<Map<String, dynamic>> filteredProducts = products.where((product) {
      return product["title"].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Search products...",
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (query) {
            setState(() {
              searchQuery = query;
            });
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Handle cart screen navigation
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      cart.length.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WishlistScreen(),
                ),
              );

              // Handle wishlist screen navigation
            },
          ),
        ],
        backgroundColor: Colors.orange,
      ),
      body: AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,
          ),
          itemCount: filteredProducts.length, // Use filteredProducts here
          itemBuilder: (context, index) {
            var product = filteredProducts[index]; // Use filteredProducts here

            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      print(index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                              //product: product,
                              ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                          child: Container(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 4.0),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: product["isOffer"]
                                ? const BorderSide(
                                    color: Colors.orange, width: 2)
                                : BorderSide.none,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  product["image"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product["title"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "₹${product["discountedPrice"]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "₹${product["price"]}",
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Colors.yellow[700],
                                            size: 16),
                                        const SizedBox(width: 2),
                                        Text(
                                          "${product["rating"]} (${product["numRatings"]})",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      product["isFavorite"]
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: product["isFavorite"]
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        product["isFavorite"] =
                                            !product["isFavorite"];
                                        if (product["isFavorite"]) {
                                          wishlist.add(product);
                                        } else {
                                          wishlist.remove(product);
                                        }
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.shopping_cart_outlined),
                                    onPressed: () {
                                      setState(() {
                                        cart.add(product);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (product["isOffer"])
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "OFFER",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.orangeAccent.withOpacity(0.1),
    );
  }
}
