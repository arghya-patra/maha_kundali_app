import 'package:maha_kundali_app/service/serviceManager.dart';

class APIData {
  //Auth profile Api
  static const String baseURL = 'https://mahakundali.hitechmart.in/';

  static const String login = '${baseURL}app-api.php';
  static const String registration = '${baseURL}api/register';

  static const String userDetails = '${baseURL}api/user-info';

  //Header
  static Map<String, String> kHeader = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${ServiceManager.tokenID}',
  };
}
