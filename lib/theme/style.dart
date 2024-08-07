import 'package:flutter/material.dart';
import 'package:maha_kundali_app/theme/colors.dart';

TextStyle kHeaderStyle({color, size}) =>
    TextStyle(fontSize: size ?? 18, fontWeight: FontWeight.bold, color: color);
TextStyle kWhiteHeaderStyle() =>
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
TextStyle kBoldStyle({color}) =>
    TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color);
TextStyle k14BoldStyle() =>
    TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
TextStyle k14Text() => TextStyle(fontSize: 14);
TextStyle k12Text() => TextStyle(fontSize: 12);
TextStyle k10Text() => TextStyle(fontSize: 10);
TextStyle k16Style() => TextStyle(fontSize: 16);
TextStyle k20BStyle() => TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
TextStyle kLargeStyle() => TextStyle(fontSize: 26, fontWeight: FontWeight.bold);
TextStyle kWhiteTextStyle() => TextStyle(color: kWhiteColor);
TextStyle tagTextStyle() => TextStyle(fontSize: 12, color: kWhiteColor);

TextStyle linkTextStyle(context) => TextStyle(
    color: Theme.of(context).textTheme.bodyMedium?.color,
    fontWeight: FontWeight.bold,
    fontSize: 14);

double kIconSize() => 18.0;
SizedBox kSpace({height}) => SizedBox(height: height ?? 15.0);
Widget kDivider() => Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(thickness: 1),
    );
SizedBox kBottomSpace() => SizedBox(height: 80.0);
double dropdownTextFieldHeight() => 50;

RoundedRectangleBorder materialButtonDesign() {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0));
}

RoundedRectangleBorder bottomSheetRoundedDesign() {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
    top: Radius.circular(15.0),
  ));
}

BoxDecoration containerDesign(context) {
  return BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor != Colors.black
        ? Colors.white
        : kDarkColor,
  );
}

BoxDecoration roundedContainerDesign(context) {
  return BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor != Colors.black
          ? Colors.white
          : kDarkColor,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: boxShadowDesign());
}

BoxDecoration roundedShadedDesign(context) {
  return BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor != Colors.black
        ? Colors.white
        : kDarkColor,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: boxShadowDesign(),
  );
}

BoxDecoration blurCurveDecor(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor != Colors.black
        ? Colors.white.withOpacity(0.9)
        : kDarkColor.withOpacity(0.7),
    borderRadius: BorderRadius.circular(10.0),
  );
}

List<BoxShadow> boxShadowDesign() {
  return [
    BoxShadow(
      color: kMainColor.withOpacity(0.3),
      spreadRadius: 2.0,
      blurRadius: 5.0,
      offset: Offset(1, 2),
    ),
  ];
}

LinearGradient kBottomShadedShadow() {
  return LinearGradient(
    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: const [0.0, 1.0],
    tileMode: TileMode.clamp,
  );
}

BoxDecoration dropTextFieldDesign(context) {
  return BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(15.0),
    border: Border.all(width: 0.5, color: Colors.grey.shade400),
  );
}

Row kRowText(String title, String desc) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: kBoldStyle()),
      Expanded(child: Text(desc)),
    ],
  );
}

Row kRowSpaceText(String title, String desc) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: kBoldStyle()),
      SizedBox(width: 10.0),
      Expanded(child: Text(desc, textAlign: TextAlign.end)),
    ],
  );
}

LinearGradient shadedTopGradient() {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: FractionalOffset.bottomCenter,
    stops: const [0.0, 1.0],
    colors: [Color(0xffA66DD4).withOpacity(0.5), Colors.transparent],
  );
}

BoxDecoration kBackgroundDesign(BuildContext context) {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage('images/bg_image.jpg'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Theme.of(context).scaffoldBackgroundColor != Colors.black
            ? Colors.white.withOpacity(0.5)
            : Colors.black.withOpacity(0.3),
        BlendMode.srcATop,
      ),
    ),
  );
}
