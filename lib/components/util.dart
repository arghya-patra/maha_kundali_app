import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maha_kundali_app/theme/colors.dart';
import 'package:maha_kundali_app/theme/style.dart';

void toastMessage({required String message, MaterialColor? colors}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: colors ?? kMainColor,
    textColor: kWhiteColor,
    fontSize: 16.0,
  );
}

Color toColor(String? boardColor) {
  if (boardColor == null) {
    return Colors.red;
  }
  var t = int.tryParse(boardColor);
  if (t != null) {
    return Color(t);
  }
  return Colors.red;
}

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

Widget dashLines() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      children: List.generate(
          300 ~/ 5,
          (index) => Expanded(
                child: Container(
                  color: index % 2 != 0 ? Colors.transparent : Colors.grey,
                  height: 1,
                ),
              )),
    ),
  );
}

Widget kDropDownHintText(String text) {
  return Text(text, style: k12Text());
}

// String kAmount(num amount) {
//   NumberFormat indianCurrencyFormat = NumberFormat.currency(
//     locale: 'en_IN',
//     symbol: '₹',
//     decimalDigits: 0,
//   );
//   return indianCurrencyFormat.format(amount) ?? 'NAN';
// }