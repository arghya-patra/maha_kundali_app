import 'dart:convert';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServiceManager {
  static String userID = '';
  static String tokenID = '';
  static String userBranchID = '';

  static String profileURL = '';
  static String userName = '';
  static String userEmail = '';
  static String userMobile = '';
  static String userDob = '';
  static String userAltMobile = '';
  static String designation = '';
  static bool isVerified = false;

  static String deliveryName = '';
  // static String deliveryAddress = '';

  static String userAddress = '';
  static String addressID = '';
  static String roleAs = '';

  void setUser(String userID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', userID);
  }

  void getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') ?? '';
    //getUserData();---need to use later
  }

  void setToken(String userID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tokenID', userID);
  }

  void getTokenID() async {
    final prefs = await SharedPreferences.getInstance();
    tokenID = prefs.getString('tokenID') ?? '';
    //getUserData();---need to use later
  }

  void setAddressID(String addressID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('addressID', addressID);
  }

  void getAddressID() async {
    final prefs = await SharedPreferences.getInstance();
    addressID = prefs.getString('addressID') ?? '';
  }

  void removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userID');
    prefs.remove('tokenID');
    // prefs.remove('addressID');
    userID = '';
    tokenID = '';
    // addressID = '';
  }

  void getUserData() async {
    String url = APIData.login;
    print(url);
    var res = await http.post(Uri.parse(url), body: {
      'action': 'user-details',
      'authorizationToken': ServiceManager.tokenID, //8100007581
    });
    var data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print(data.toString());
      userName = '${data['userDetails']['name']}';
      userEmail = '${data['userDetails']['email']}';
      profileURL = '${data['userDetails']['logo']}';
      userMobile = data['userDetails']['mobile'] ?? '';
      // userAltMobile = data['astrologerDetails']['alternative_mob'] ?? '';
      // userDob = data['astrologerDetails']['dob'] ?? '';
      // designation = data['astrologerDetails']['Designation'] ?? '';
      // userBranchID = data['astrologerDetails']['branchId'] ?? '';
      // roleAs = '${data['astrologerDetails']['use_role']}';
    } else {
      // print('Status Code: ${res.statusCode}');
      // print(res.body);
    }
  }

  // void getUserData() async {
  //   String url = APIData.login;
  //   print(url);
  //   var res = await http.get(Uri.parse(url), headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${ServiceManager.tokenID}',
  //   });
  //   if (res.statusCode == 200) {
  //     var data = jsonDecode(res.body);
  //     print(data.toString());
  //     userName = '${data['userDetails']['name']}';
  //     userEmail = '${data['userDetails']['email']}';
  //     profileURL = '${data['userDetails']['profile_image']}';
  //     userMobile = data['userDetails']['mobile'] ?? '';
  //     userAltMobile = data['userDetails']['alternative_mob'] ?? '';
  //     userDob = data['userDetails']['dob'] ?? '';
  //     designation = data['userDetails']['Designation'] ?? '';
  //     userBranchID = data['userDetails']['branchId'] ?? '';
  //     roleAs = '${data['userDetails']['use_role']}';
  //   } else {
  //     // print('Status Code: ${res.statusCode}');
  //     // print(res.body);
  //   }
  // }
}
