import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class AstrologerDashboard extends StatefulWidget {
  @override
  _AstrologerDashboardState createState() => _AstrologerDashboardState();
}

class _AstrologerDashboardState extends State<AstrologerDashboard> {
  Map<String, dynamic> apiData = {};
  List<String> _banners = [];
  bool showAllVideos = false;

  @override
  void initState() {
    _banners = [
      'images/banner1.png',
      'images/banner2.jpg',
      'images/banner3.jpeg',
    ];
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String url = APIData.login;
    final response = await http.post(Uri.parse(url), body: {
      'action': 'user-dashboard',
      'authorizationToken': ServiceManager.tokenID
    });
    if (response.statusCode == 200) {
      setState(() {
        apiData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _playVideo(String videoUrl) {
    VideoPlayerController _controller = VideoPlayerController.network(videoUrl);

    _controller.initialize().then((_) {
      setState(() {
        // Ensure the first frame is shown after the video is initialized
      });

      _controller.play();

      // Show the video in a dialog after initialization
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _controller.pause();
                  _controller.dispose(); // Dispose of the controller
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
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
      body: apiData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  CarouselSlider(
                    options: CarouselOptions(
                        height: 150.0, autoPlay: true, viewportFraction: 1.0),
                    items: _banners.map((banner) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: AssetImage(banner),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // Free Services
                  buildSectionTitle('Free Services'),
                  buildFreeServices(),

                  // Customer Stories
                  const SizedBox(height: 10),
                  buildSectionTitle('Watch Videos'),
                  buildWatchVideos(),
                ],
              ),
            ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<dynamic> routes = [
    // Add your routes here for the free services navigation
  ];

  Widget buildFreeServices() {
    return apiData['free_services'] != null
        ? Container(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apiData['free_services'].length,
              itemBuilder: (context, index) {
                final service = apiData['free_services'][index];
                String serviceName = service['name'];
                List<String> words = serviceName.split(' ');
                String formattedServiceName = words.length > 1
                    ? '${words[0]}\n${words.sublist(1).join(' ')}'
                    : serviceName;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      // Add navigation functionality here
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: service['thumb'],
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 241, 111),
                                width: 10,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                service['thumb'],
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedServiceName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 2,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Container();
  }

  Widget buildWatchVideos() {
    final watchVideos = apiData['watch_video'] ?? [];

    if (watchVideos.isEmpty) {
      return Container();
    }

    int visibleItemCount = showAllVideos ? watchVideos.length : 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
            ),
            itemCount: visibleItemCount,
            itemBuilder: (context, index) {
              final video = watchVideos[index];
              return GestureDetector(
                onTap: () => _playVideo(video['file'] ?? ''),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(video['thumbnail'] ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Astrologer ID: ${video['astrologer_id']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Video ID: ${video['id']}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (watchVideos.length > 3)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showAllVideos = !showAllVideos;
                });
              },
              child: Text(
                showAllVideos ? 'View Less' : 'View More',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
