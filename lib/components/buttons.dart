import 'package:flutter/material.dart';
import 'package:maha_kundali_app/theme/colors.dart';
import 'package:maha_kundali_app/theme/style.dart';

class KButton extends StatelessWidget {
  String title;
  Function() onClick;
  Color? color;
  Color? textColor;
  KButton(
      {Key? key,
      required this.title,
      required this.onClick,
      this.color,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: MediaQuery.of(context).size.width * 0.9,
      shape: materialButtonDesign(),
      color: color ?? kButtonColor,
      textColor: textColor ?? kBTextColor,
      onPressed: onClick,
      child: Text(
        title,
        style: k16Style(),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  Color? color;
  LoadingButton({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: MediaQuery.of(context).size.width * 0.9,
      shape: materialButtonDesign(),
      color: color ?? kButtonColor,
      textColor: kBTextColor,
      onPressed: () {},
      child: CircularProgressIndicator(
        color: kWhiteColor,
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  String? title, image;
  Function() onClick;
  LoginButton(
      {required this.title, this.image, required this.onClick, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      color: kButtonColor,
      textColor: kWhiteColor,
      shape: materialButtonDesign(),
      minWidth: MediaQuery.of(context).size.width * 0.9,
      onPressed: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title!),
          SizedBox(width: 10.0),
          //Image.asset(image!, height: 25),
        ],
      ),
    );
  }
}

Widget paymentButton(
  BuildContext context, {
  IconData? leadingIcon,
  required String title,
  required String image,
  required Function() onClick,
}) {
  return Container(
    decoration: blurCurveDecor(context),
    child: ListTile(
      leading: leadingIcon != null
          ? Icon(leadingIcon,
              color: Theme.of(context).scaffoldBackgroundColor != Colors.black
                  ? kMainColor
                  : kWhiteColor)
          : Image.asset(
              image,
              height: 25,
            ),
      title: Text(title),
      trailing: Icon(Icons.chevron_right_outlined,
          color: Theme.of(context).scaffoldBackgroundColor != Colors.black
              ? kMainColor
              : kWhiteColor),
      onTap: onClick,
    ),
  );
}

ListTile profileButton(IconData iconData, String title, Function() onClicked) {
  return ListTile(
    // contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    leading: Icon(iconData, color: kMainColor),
    title: Text(title),
    trailing: Icon(Icons.chevron_right_outlined),
    onTap: onClicked,
  );
}

class SmallButton extends StatelessWidget {
  String title;
  Function() onClick;
  Color? color;
  Color? textColor;
  SmallButton(
      {Key? key,
      required this.title,
      required this.onClick,
      this.color,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 35,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: color ?? kButtonColor,
      textColor: textColor ?? kBTextColor,
      onPressed: onClick,
      child: Text(
        title,
        style: k16Style(),
      ),
    );
  }
}

class ArrowButton extends StatelessWidget {
  String title;
  Function() onClick;
  ArrowButton({super.key, required this.title, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          SizedBox(width: 10),
          Icon(
            Icons.arrow_forward,
            size: 14,
          ),
        ],
      ),
    );
  }
}

Expanded managementButton(
  BuildContext context, {
  required Function() onClick,
  required String title,
  required String image,
  Color? color,
  // IconData? iconData,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: roundedContainerDesign(context).copyWith(
            color: color,
            boxShadow: boxShadowDesign(),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 50.0),
              Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              Text(title, style: TextStyle(color: Colors.black)), Spacer(),
              Icon(Icons.arrow_forward_outlined)
            ],
          ),
        ),
      ),
    ),
  );
}
