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
  static String balance = '';
  void setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', name);
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('username') ?? '';
    //getUserData();---need to use later
  }

  void setUserLogo(String logo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('logo', profileURL);
  }

  void getUseLogo() async {
    final prefs = await SharedPreferences.getInstance();
    profileURL = prefs.getString('logo') ?? '';
    //getUserData();---need to use later
  }

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

  void setRole(String roleAs) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('role_as', roleAs);
  }

  void getRole() async {
    final prefs = await SharedPreferences.getInstance();
    roleAs = prefs.getString('role_as') ?? '';
  }

  void setBalance(String balance) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('balance', balance);
  }

  void getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    balance = prefs.getString('balance') ?? '';
  }

  void removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userID');
    prefs.remove('tokenID');
    prefs.remove('logo');
    prefs.remove('username');
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
