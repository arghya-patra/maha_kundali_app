import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/productDetailScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

class AstrologerProfileScreen extends StatefulWidget {
  String? id;
  AstrologerProfileScreen({this.id});

  @override
  _AstrologerProfileScreenState createState() =>
      _AstrologerProfileScreenState();
}

class _AstrologerProfileScreenState extends State<AstrologerProfileScreen>
    with TickerProviderStateMixin {
  Future<Map<String, dynamic>>? _astrologerDetails;
  late AnimationController _controller;
  late Animation<double> _animation;
  VideoPlayerController? _videoPlayerController;
  //late YoutubePlayerController _youtubePlayerController;
  bool isFollowing = false;
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    _astrologerDetails = fetchAstrologerDetails();
    print(["*&*&*&*&", _astrologerDetails]);

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchAstrologerDetails() async {
    String url = APIData.login;
    print(url.toString());
    print(widget.id);
    var response = await http.post(Uri.parse(url), body: {
      'action': 'astrologer-profile',
      'authorizationToken': ServiceManager.tokenID,
      'user_id': widget.id
    });
    var data = jsonDecode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      print(["^&^&^", data]);
      setState(() {
        isFollowing =
            data['astrologerDetails']['follow'] == 'no' ? false : true;
        isFavourite =
            data['astrologerDetails']['favorite'] == 'no' ? false : true;
      });
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load astrologer details');
    }
  }

  toggleFollowStatus(String astrologerId) async {
    final String url = APIData.login;

    try {
      final response = await http.post(Uri.parse(url), body: {
        'action':
            isFollowing ? 'delete-follow-astrologer' : 'add-follow-astrologer',
        'authorizationToken': ServiceManager.tokenID,
        'astrologer_id': astrologerId,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 200) {
        setState(() {
          isFollowing = !isFollowing;
        });
        fetchAstrologerDetails();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFollowing ? 'Followed' : 'Unfollowed'),
            backgroundColor: Colors.deepOrange,
          ),
        );
      } else {
        throw Exception(data['error'] ?? 'Failed to update follow status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> toggleFavouriteStatus(String astrologerId) async {
    final String url = APIData.login;

    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': isFavourite
            ? 'delete-favorite-astrologer'
            : 'add-favorite-astrologer',
        'authorizationToken': ServiceManager.tokenID,
        'astrologer_id': astrologerId,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 200) {
        setState(() {
          isFavourite = !isFavourite;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFavourite
                ? 'Added to Favourites'
                : 'Removed from Favourites'),
            backgroundColor: Colors.deepOrange,
          ),
        );
      } else {
        throw Exception(data['error'] ?? 'Failed to update favourite status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void playVideo(String videoUrl) {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }
    _videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
  }

  Widget buildVideoPlayer() {
    return _videoPlayerController != null &&
            _videoPlayerController!.value.isInitialized
        ? AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController!),
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget buildShimmerEffect(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(75),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 20,
            width: 200,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            height: 20,
            width: 100,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrologer Profile'),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _astrologerDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: buildShimmerEffect(context));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load data'));
          } else {
            final astrologerDetails = snapshot.data!['astrologerDetails'];
            final productList = snapshot.data!['astrologer_product_list'];
            final photoGalleryList = snapshot.data!['photo_gallery_list'];
            final videoGalleryList = snapshot.data!['video_gallery_list'];
            final availabilityList = snapshot.data!['availability_list'];
            final reviewList = snapshot.data!['review_list'];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, top: 16, bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile image on the left
                        CircleAvatar(
                          radius: 50, // Reduced size for better alignment
                          backgroundImage:
                              NetworkImage(astrologerDetails['logo']),
                        ),
                        const SizedBox(width: 16),

                        // Name and Specialization on the right
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                astrologerDetails['name'],
                                style: const TextStyle(
                                  fontSize: 22, // Adjusted font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                astrologerDetails['specialization'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          toggleFollowStatus(widget.id!);
                        },
                        icon: Icon(
                          isFollowing ? Icons.check_circle : Icons.person_add,
                          color: Colors.deepOrange,
                        ),
                        label: Text(
                          isFollowing ? 'Following' : 'Follow',
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.deepOrange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          toggleFavouriteStatus(widget.id!);
                        },
                        icon: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.deepOrange,
                        ),
                        label: Text(
                          isFavourite ? 'Favourited' : 'Add to Favourite',
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.deepOrange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(
                    color: Colors.deepOrange,
                    thickness:
                        1.5, // Slightly thinner divider for a cleaner look
                    // indent: 16,
                    // endIndent: 16,
                  ),

                  // Chat button with padding
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange, // Background color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.chat_bubble, color: Colors.white),
                      label: const Text(
                        'Chat Now',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  // Padding to add spacing between sections
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      astrologerDetails['company_desc'],
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  const Divider(color: Colors.deepOrange, thickness: 2),

                  // Continue with other sections like products, gallery, availability, etc.
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Products',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print(productList[index]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  productId: productList[index]['product_id'],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0), // Reduced horizontal padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: productList[index]
                                        ['product_photo'],
                                    placeholder: (context, url) =>
                                        const SpinKitFadingCircle(
                                      color: Colors.deepOrange,
                                      size: 50.0,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Adjusted Text widget for product title
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width:
                                        150, // Fixed width for consistent layout
                                    child: Text(
                                      productList[index]['product_title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            14, // Slightly smaller font size
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow
                                          .ellipsis, // Handle long text
                                      maxLines: 1, // Limit to one line
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  productList[index]['product_price'],
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(color: Colors.deepOrange, thickness: 2),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Photo Gallery',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photoGalleryList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              // Show dialog with the larger image
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Container(
                                    height: 400, // Set the height of the dialog
                                    width: 300, // Set the width of the dialog
                                    child: CachedNetworkImage(
                                      imageUrl: photoGalleryList[index]['file'],
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: photoGalleryList[index]['file'],
                                placeholder: (context, url) =>
                                    const SpinKitFadingCircle(
                                  color: Colors.deepOrange,
                                  size: 50.0,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // const Divider(color: Colors.deepOrange, thickness: 2),
                  // const Padding(
                  //   padding: EdgeInsets.all(16.0),
                  //   child: Text(
                  //     'Video Gallery',
                  //     style:
                  //         TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // Container(
                  //   height: 150,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: videoGalleryList.length,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             playVideo(videoGalleryList[index]['file']);
                  //             showModalBottomSheet(
                  //               context: context,
                  //               builder: (context) {
                  //                 return buildVideoPlayer();
                  //               },
                  //             );
                  //           },
                  //           child: Container(
                  //             height: 150,
                  //             width: 150,
                  //             color: Colors.grey[200],
                  //             child: Stack(
                  //               children: [
                  //                 const Center(
                  //                   child: Icon(
                  //                     Icons.play_circle_fill,
                  //                     color: Colors.deepOrange,
                  //                     size: 50,
                  //                   ),
                  //                 ),
                  //                 CachedNetworkImage(
                  //                   imageUrl: videoGalleryList[index]['file'],
                  //                   placeholder: (context, url) =>
                  //                       const SpinKitFadingCircle(
                  //                     color: Colors.deepOrange,
                  //                     size: 50.0,
                  //                   ),
                  //                   errorWidget: (context, url, error) =>
                  //                       const Icon(Icons.error),
                  //                   height: 150,
                  //                   width: 150,
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  const Divider(color: Colors.deepOrange, thickness: 2),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, left: 16.0),
                    child: Text(
                      'Availability',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        ...availabilityList.map<Widget>((availability) {
                          String day = availability.keys.first;
                          String time = availability[day]!;
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    _getDayIcon(day),
                                    color: Colors.deepOrange,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '$day: $time',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  // Container(
                  //   height: 100,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: availabilityList.length,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //           width: 100,
                  //           decoration: BoxDecoration(
                  //             color: Colors.deepOrangeAccent,
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               availabilityList[index]['availability_time'],
                  //               style: const TextStyle(
                  //                   color: Colors.white,
                  //                   fontWeight: FontWeight.bold),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  const Divider(color: Colors.deepOrange, thickness: 2),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Reviews',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviewList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print(reviewList[index]);
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(reviewList[index]['logo']),
                                  radius: 30,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reviewList[index]['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      _formatDate(reviewList[index]['date']),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    _buildStarRating(reviewList[index]['rate']),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate); // Ensure it's in ISO format
      return DateFormat('d MMM y').format(parsedDate); // e.g., 23 Jun 2025
    } catch (e) {
      return rawDate; // fallback if format fails
    }
  }

  Widget _buildStarRating(String rating) {
    // Convert the string rating to an integer
    int rateValue = int.tryParse(rating) ?? 0; // Default to 0 if parsing fails
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(
        Icon(
          i <= rateValue ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        ),
      );
    }
    return Row(
      children: stars,
    );
  }

  IconData _getDayIcon(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return Icons.calendar_today;
      case 'tuesday':
        return Icons.calendar_today;
      case 'wednesday':
        return Icons.calendar_today;
      case 'thursday':
        return Icons.calendar_today;
      case 'friday':
        return Icons.calendar_today;
      case 'saturday':
        return Icons.calendar_today;
      case 'sunday':
        return Icons.calendar_today;
      default:
        return Icons.calendar_today;
    }
  }
}




//--------bofre modify chat buutton
//SingleChildScrollView(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Center(
            //         child: CircleAvatar(
            //           radius: 75,
            //           backgroundImage: NetworkImage(
            //               'https://mahakundali.hitechmart.in/uploads/supplier/1721132166_0.jpg'
            //               //astrologerDetails['logo']

            //               ),
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       Center(
            //         child: Text(
            //           astrologerDetails['name'],
            //           style: const TextStyle(
            //             fontSize: 24,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Center(
            //         child: Text(
            //           astrologerDetails['specialization'],
            //           style: TextStyle(
            //             fontSize: 16,
            //             color: Colors.grey[700],
            //           ),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       Center(
            //         child: ElevatedButton.icon(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.deepOrange, // Background color
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 24, vertical: 12),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //           ),
            //           icon: const Icon(Icons.chat_bubble, color: Colors.white),
            //           label: const Text(
            //             'Chat Now',
            //             style: TextStyle(fontSize: 16, color: Colors.white),
            //           ),
            //           onPressed: () {
            //             // Handle chat action here
            //             // Navigator.push(
            //             //   context,
            //             //   MaterialPageRoute(
            //             //     builder: (context) => ChatScreen(
            //             //       astrologerId: astrologerDetails['id'], // Pass necessary data
            //             //     ),
            //             //   ),
            //             // );
            //           },
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(16.0),
            //         child: Text(
            //           astrologerDetails['company_desc'],
            //           style: const TextStyle(fontSize: 16),
            //         ),
            //       ),
            //       const Divider(color: Colors.deepOrange, thickness: 2),
            //       const Padding(
            //         padding: EdgeInsets.all(16.0),
            //         child: Text(
            //           'Products',
            //           style:
            //               TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //       Container(
            //         height: 250,
            //         child: ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: productList.length,
            //           itemBuilder: (context, index) {
            //             return Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Column(
            //                 children: [
            //                   ClipRRect(
            //                     borderRadius: BorderRadius.circular(10),
            //                     child: CachedNetworkImage(
            //                       imageUrl: productList[index]['product_photo'],
            //                       placeholder: (context, url) =>
            //                           const SpinKitFadingCircle(
            //                         color: Colors.deepOrange,
            //                         size: 50.0,
            //                       ),
            //                       errorWidget: (context, url, error) =>
            //                           const Icon(Icons.error),
            //                       height: 150,
            //                       width: 150,
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                   const SizedBox(height: 8),
            //                   Text(
            //                     productList[index]['product_title'],
            //                     style: const TextStyle(
            //                         fontWeight: FontWeight.bold),
            //                     textAlign: TextAlign.center,
            //                   ),
            //                   const SizedBox(height: 4),
            //                   Text(
            //                     productList[index]['product_price'],
            //                     style: TextStyle(color: Colors.grey[700]),
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //       const Divider(color: Colors.deepOrange, thickness: 2),
            //       const Padding(
            //         padding: EdgeInsets.all(16.0),
            //         child: Text(
            //           'Photo Gallery',
            //           style:
            //               TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //       Container(
            //         height: 150,
            //         child: ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: photoGalleryList.length,
            //           itemBuilder: (context, index) {
            //             return Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(10),
            //                 child: CachedNetworkImage(
            //                   imageUrl: photoGalleryList[index]['file'],
            //                   placeholder: (context, url) =>
            //                       const SpinKitFadingCircle(
            //                     color: Colors.deepOrange,
            //                     size: 50.0,
            //                   ),
            //                   errorWidget: (context, url, error) =>
            //                       const Icon(Icons.error),
            //                   height: 150,
            //                   width: 150,
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //       const Divider(color: Colors.deepOrange, thickness: 2),
            //       // const Padding(
            //       //   padding: EdgeInsets.all(16.0),
            //       //   child: Text(
            //       //     'Video Gallery',
            //       //     style:
            //       //         TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //       //   ),
            //       // ),
            //       // Container(
            //       //   height: 150,
            //       //   child: ListView.builder(
            //       //     scrollDirection: Axis.horizontal,
            //       //     itemCount: videoGalleryList.length,
            //       //     itemBuilder: (context, index) {
            //       //       return Padding(
            //       //         padding: const EdgeInsets.all(8.0),
            //       //         child: GestureDetector(
            //       //           onTap: () {
            //       //             playVideo(videoGalleryList[index]['file']);
            //       //             showModalBottomSheet(
            //       //               context: context,
            //       //               builder: (context) {
            //       //                 return buildVideoPlayer();
            //       //               },
            //       //             );
            //       //           },
            //       //           child: Container(
            //       //             height: 150,
            //       //             width: 150,
            //       //             color: Colors.grey[200],
            //       //             child: Stack(
            //       //               children: [
            //       //                 const Center(
            //       //                   child: Icon(
            //       //                     Icons.play_circle_fill,
            //       //                     color: Colors.deepOrange,
            //       //                     size: 50,
            //       //                   ),
            //       //                 ),
            //       //                 CachedNetworkImage(
            //       //                   imageUrl: videoGalleryList[index]['file'],
            //       //                   placeholder: (context, url) =>
            //       //                       const SpinKitFadingCircle(
            //       //                     color: Colors.deepOrange,
            //       //                     size: 50.0,
            //       //                   ),
            //       //                   errorWidget: (context, url, error) =>
            //       //                       const Icon(Icons.error),
            //       //                   height: 150,
            //       //                   width: 150,
            //       //                   fit: BoxFit.cover,
            //       //                 ),
            //       //               ],
            //       //             ),
            //       //           ),
            //       //         ),
            //       //       );
            //       //     },
            //       //   ),
            //       // ),
            //       const Divider(color: Colors.deepOrange, thickness: 2),
            //       const Padding(
            //         padding: EdgeInsets.all(16.0),
            //         child: Text(
            //           'Availability',
            //           style:
            //               TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(16.0),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: availabilityList.map<Widget>((availability) {
            //             String day = availability.keys.first;
            //             String time = availability[day];
            //             return Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 4.0),
            //               child: Text('$day: $time',
            //                   style: const TextStyle(fontSize: 16)),
            //             );
            //           }).toList(),
            //         ),
            //       ),
            //       // Container(
            //       //   height: 100,
            //       //   child: ListView.builder(
            //       //     scrollDirection: Axis.horizontal,
            //       //     itemCount: availabilityList.length,
            //       //     itemBuilder: (context, index) {
            //       //       return Padding(
            //       //         padding: const EdgeInsets.all(8.0),
            //       //         child: Container(
            //       //           width: 100,
            //       //           decoration: BoxDecoration(
            //       //             color: Colors.deepOrangeAccent,
            //       //             borderRadius: BorderRadius.circular(10),
            //       //           ),
            //       //           child: Center(
            //       //             child: Text(
            //       //               availabilityList[index]['availability_time'],
            //       //               style: const TextStyle(
            //       //                   color: Colors.white,
            //       //                   fontWeight: FontWeight.bold),
            //       //               textAlign: TextAlign.center,
            //       //             ),
            //       //           ),
            //       //         ),
            //       //       );
            //       //     },
            //       //   ),
            //       // ),
            //       const Divider(color: Colors.deepOrange, thickness: 2),
            //       const Padding(
            //         padding: EdgeInsets.all(16.0),
            //         child: Text(
            //           'Reviews',
            //           style:
            //               TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //       ListView.builder(
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemCount: reviewList.length,
            //         itemBuilder: (context, index) {
            //           return Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: ListTile(
            //               leading: CircleAvatar(
            //                 backgroundImage:
            //                     NetworkImage(reviewList[index]['logo']),
            //               ),
            //               title: Text(reviewList[index]['date'],
            //                   style:
            //                       const TextStyle(fontWeight: FontWeight.bold)),
            //               subtitle: Text(reviewList[index]['rate']),
            //             ),
            //           );
            //         },
            //       ),
            //     ],
            //   ),
            // );






// import 'package:flutter/material.dart';
// import 'package:maha_kundali_app/screens/chats/chatMessageScreen.dart';
// import 'package:shimmer/shimmer.dart';

// class AstrologerProfileScreen extends StatefulWidget {
//   @override
//   _AstrologerProfileScreenState createState() =>
//       _AstrologerProfileScreenState();
// }

// class _AstrologerProfileScreenState extends State<AstrologerProfileScreen>
//     with SingleTickerProviderStateMixin {
//   bool _isLoading = true;
//   bool _isExpanded = false;
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool isFollow = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     );
//     _controller.forward();
//     _loadData();
//   }

//   void _loadData() async {
//     await Future.delayed(
//         const Duration(seconds: 2)); // Simulate network request
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Astrologer Profile'),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.orange, Colors.deepOrange],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           _isLoading ? _buildShimmerEffect() : _buildProfileContent(),
//           _buildFloatingBottomTab(),
//         ],
//       ),
//     );
//   }

//   Widget _buildShimmerEffect() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildShimmerBox(height: 150),
//             const SizedBox(height: 16),
//             _buildShimmerBox(height: 20),
//             const SizedBox(height: 8),
//             _buildShimmerBox(height: 20),
//             const SizedBox(height: 8),
//             _buildShimmerBox(height: 20),
//             const SizedBox(height: 16),
//             _buildShimmerBox(height: 100),
//             const SizedBox(height: 16),
//             _buildShimmerBox(height: 50),
//             const SizedBox(height: 8),
//             _buildShimmerBox(height: 50),
//             const SizedBox(height: 8),
//             _buildShimmerBox(height: 50),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildShimmerBox({required double height}) {
//     return Container(
//       width: double.infinity,
//       height: height,
//       color: Colors.white,
//     );
//   }

//   Widget _buildProfileContent() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(
//           left: 16, right: 16, bottom: 100), // Added bottom padding
//       child: FadeTransition(
//         opacity: _animation,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),
//             _buildProfileSection(),
//             const SizedBox(height: 16),
//             _buildDescriptionSection(),
//             const SizedBox(height: 16),
//             _buildReviewsSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileSection() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const CircleAvatar(
//           radius: 50,
//           backgroundImage: AssetImage(
//               'images/astro3.jpg'), // Replace with actual image asset
//           child: Align(
//             alignment: Alignment.topRight,
//             child: Icon(Icons.verified, color: Colors.blue, size: 20),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Astrologer Name',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const Text('Vedic Astrologer | 10+ years of Experience',
//                   style: TextStyle(color: Colors.black)),
//               const Text('Languages: Hindi, English',
//                   style: TextStyle(color: Colors.black)),
//               const SizedBox(height: 8),
//               const Text('₹500 / minute',
//                   style: TextStyle(fontSize: 18, color: Colors.orange)),
//               const SizedBox(height: 8),
//               _buildRating(3),
//             ],
//           ),
//         ),
//         Column(
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//               ),
//               onPressed: () {
//                 setState(() {
//                   isFollow = !isFollow;
//                 });
//               },
//               child: isFollow ? Text('Unfollow') : Text('Follow'),
//             ),
//             const SizedBox(height: 8),
//             const Text('5000 Followers', style: TextStyle(color: Colors.black)),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRating(double rating) {
//     int fullStars = rating.floor(); // Number of full stars
//     bool hasHalfStar =
//         (rating - fullStars) >= 0.5; // Check if there's a half star
//     int emptyStars =
//         5 - fullStars - (hasHalfStar ? 1 : 0); // Remaining empty stars

//     return Row(
//       children: [
//         // Full Stars
//         for (int i = 0; i < fullStars; i++)
//           const Icon(Icons.star, color: Colors.orange, size: 16),

//         // Half Star
//         if (hasHalfStar)
//           const Icon(Icons.star_half, color: Colors.orange, size: 16),

//         // Empty Stars
//         for (int i = 0; i < emptyStars; i++)
//           const Icon(Icons.star_border, color: Colors.grey, size: 16),

//         // Rating Text
//         const SizedBox(width: 4),
//         Text(
//           rating.toString(),
//           style: const TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }

//   Widget _buildDescriptionSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'About Astrologer',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'This astrologer has 10+ years of experience in Vedic astrology. He has guided thousands of people with his accurate predictions and insightful advice...',
//           maxLines: _isExpanded ? null : 3,
//           overflow: TextOverflow.fade,
//         ),
//         InkWell(
//           onTap: () {
//             setState(() {
//               _isExpanded = !_isExpanded;
//             });
//           },
//           child: Text(
//             _isExpanded ? 'Show less' : 'Show more',
//             style: const TextStyle(
//                 color: Colors.orange, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildReviewsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'User Reviews',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         _buildReviewCard(
//             'John Doe',
//             'Great advice! Really helped me in making life decisions.',
//             5,
//             '2024-08-07'),
//         const SizedBox(height: 16),
//         _buildReviewCard('Jane Smith',
//             'Very accurate predictions, highly recommend!', 4, '2024-08-06'),
//         const SizedBox(height: 16),
//         _buildReviewCard('Samuel Green',
//             'Good experience, but a bit expensive.', 3, '2024-08-05'),
//       ],
//     );
//   }

//   Widget _buildReviewCard(String name, String review, int rating, String date) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const CircleAvatar(
//               radius: 20,
//               backgroundImage: AssetImage(
//                   'images/profile.jpeg'), // Replace with actual image asset
//             ),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 _buildStarRating(rating),
//               ],
//             ),
//             const Spacer(),
//             Text(date, style: const TextStyle(color: Colors.grey)),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(review),
//       ],
//     );
//   }

//   Widget _buildStarRating(int rating) {
//     return Row(
//       children: List.generate(5, (index) {
//         if (index < rating) {
//           return const Icon(Icons.star, color: Colors.orange, size: 16);
//         } else {
//           return const Icon(Icons.star_border, color: Colors.grey, size: 16);
//         }
//       }),
//     );
//   }

//   Widget _buildFloatingBottomTab() {
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 8,
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 icon: const Icon(Icons.call),
//                 label: const Text('Call'),
//                 onPressed: () {
//                   // Handle call action
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 icon: const Icon(Icons.chat),
//                 label: const Text('Chat'),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatScreen(chatId: "1"),
//                     ),
//                   );
//                   // Handle chat action
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
