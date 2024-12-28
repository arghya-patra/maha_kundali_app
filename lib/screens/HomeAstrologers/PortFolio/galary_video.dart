import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:video_player/video_player.dart';

class AstrologerVideoGalleryScreen extends StatefulWidget {
  const AstrologerVideoGalleryScreen({Key? key}) : super(key: key);

  @override
  _AstrologerVideoGalleryScreenState createState() =>
      _AstrologerVideoGalleryScreenState();
}

class _AstrologerVideoGalleryScreenState
    extends State<AstrologerVideoGalleryScreen> {
  List<Map<String, dynamic>> videos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  // Fetch Videos from API
  Future<void> fetchVideos() async {
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-media',
        'authorizationToken': ServiceManager.tokenID,
        'media': 'video',
        'mode': 'none'
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['isSuccess'] == true) {
          setState(() {
            videos = List<Map<String, dynamic>>.from(data['list']);
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load videos');
        }
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }
  }

  // Delete Video
  Future<void> deleteVideo(String id) async {
    final url =
        'https://api.example.com/videos/delete'; // Replace with actual endpoint
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'id': id},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['isSuccess'] == true) {
          setState(() {
            videos.removeWhere((video) => video['id'] == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video deleted successfully')),
          );
        } else {
          throw Exception('Failed to delete video');
        }
      } else {
        throw Exception('Failed to delete video');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }
  }

  // Show Add Video Modal
  void showAddVideoModal() {
    final TextEditingController videoUrlController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Video',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: videoUrlController,
                decoration: const InputDecoration(
                  labelText: 'Video URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (videoUrlController.text.isNotEmpty) {
                    addVideo(videoUrlController.text.trim());
                  }
                },
                child: const Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Video',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this video?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteVideo(id);
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Add Video
  Future<void> addVideo(String videoUrl) async {
    final url =
        'https://api.example.com/videos/add'; // Replace with actual endpoint
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'file_name': videoUrl},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['isSuccess'] == true) {
          setState(() {
            videos.add({
              'id': data['newVideo']
                  ['id'], // Assuming the API sends new video ID
              'file_name': videoUrl,
            });
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video added successfully')),
          );
        } else {
          throw Exception('Failed to add video');
        }
      } else {
        throw Exception('Failed to add video');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }
  }

  // Show Video Player Dialog
  void showVideoPlayer(String videoUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: VideoPlayerScreen(videoUrl: videoUrl),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrologer Video Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddVideoModal,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : videos.isEmpty
              ? const Center(
                  child: Text(
                    'No videos available. Add a new video!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 16 / 9,
                  ),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return GestureDetector(
                      onTap: () => showVideoPlayer(video['file_name']),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(video['file_name']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () =>
                                  showDeleteConfirmationDialog(video['id']),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

// Video Player Screen
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}




// class AstrologerVideoGalleryScreen extends StatefulWidget {
//   const AstrologerVideoGalleryScreen({Key? key}) : super(key: key);

//   @override
//   _AstrologerVideoGalleryScreenState createState() =>
//       _AstrologerVideoGalleryScreenState();
// }

// class _AstrologerVideoGalleryScreenState
//     extends State<AstrologerVideoGalleryScreen> {
//   List<Map<String, dynamic>> videos = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchVideos();
//   }

//   // Fetch Videos from API
//   Future<void> fetchVideos() async {
   
//     try {
//     String url = APIData.login;
//       var response = await http.post(Uri.parse(url), body: {
//         'action': 'astrologer-media',
//         'authorizationToken': ServiceManager.tokenID,
//         'media': 'video',
//         'mode': 'none'
//       });

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['isSuccess'] == true) {
//           setState(() {
//             videos = List<Map<String, dynamic>>.from(data['list']);
//             isLoading = false;
//           });
//         } else {
//           throw Exception('Failed to load videos');
//         }
//       } else {
//         throw Exception('Failed to load videos');
//       }
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${error.toString()}')),
//       );
//     }
//   }

//   // Delete Video
//   Future<void> deleteVideo(String id) async {
//     final url = 'https://api.example.com/videos/delete'; // Replace with actual endpoint
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: {'id': id},
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['isSuccess'] == true) {
//           setState(() {
//             videos.removeWhere((video) => video['id'] == id);
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Video deleted successfully')),
//           );
//         } else {
//           throw Exception('Failed to delete video');
//         }
//       } else {
//         throw Exception('Failed to delete video');
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${error.toString()}')),
//       );
//     }
//   }

//   // Add Video
//   Future<void> addVideo(String videoUrl) async {
//     final url = 'https://api.example.com/videos/add'; // Replace with actual endpoint
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: {'file_name': videoUrl},
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['isSuccess'] == true) {
//           setState(() {
//             videos.add({
//               'id': data['newVideo']['id'], // Assuming the API sends new video ID
//               'file_name': videoUrl,
//             });
//           });
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Video added successfully')),
//           );
//         } else {
//           throw Exception('Failed to add video');
//         }
//       } else {
//         throw Exception('Failed to add video');
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${error.toString()}')),
//       );
//     }
//   }

//   // Show Add Video Modal
//   void showAddVideoModal() {
//     final TextEditingController videoUrlController = TextEditingController();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => Padding(
//         padding: MediaQuery.of(context).viewInsets,
//         child: Container(
//           padding: const EdgeInsets.all(16.0),
//           height: 200,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Add New Video',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: videoUrlController,
//                 decoration: const InputDecoration(
//                   labelText: 'Video URL',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   if (videoUrlController.text.isNotEmpty) {
//                     addVideo(videoUrlController.text.trim());
//                   }
//                 },
//                 child: const Text('Upload'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Confirmation Dialog for Deletion
//   void showDeleteConfirmationDialog(String id) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text(
//           'Delete Video',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text('Are you sure you want to delete this video?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               deleteVideo(id);
//             },
//             child: const Text(
//               'Yes',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Astrologer Video Gallery'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: showAddVideoModal,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : videos.isEmpty
//               ? const Center(
//                   child: Text(
//                     'No videos available. Add a new video!',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 )
//               : GridView.builder(
//                   padding: const EdgeInsets.all(8.0),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 10,
//                     childAspectRatio: 16 / 9,
//                   ),
//                   itemCount: videos.length,
//                   itemBuilder: (context, index) {
//                     final video = videos[index];
//                     return Stack(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             image: DecorationImage(
//                               image: NetworkImage(
//                                 'https://img.youtube.com/vi/${Uri.parse(video['file_name']).pathSegments.last}/hqdefault.jpg',
//                               ),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: GestureDetector(
//                             onTap: () => showDeleteConfirmationDialog(video['id']),
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                 color: Colors.red,
//                                 shape: BoxShape.circle,
//                               ),
//                               padding: const EdgeInsets.all(8.0),
//                               child: const Icon(
//                                 Icons.delete,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//     );
//   }
// }
