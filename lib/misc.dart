import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Nothing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
    );
  }
}

class Spacing extends StatelessWidget {
  double spacing;
  Spacing({this.spacing = 10});
  @override
  Widget build(BuildContext context) {
    return new Padding(padding: EdgeInsets.all(spacing));
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class WebContainer extends StatelessWidget {
  Widget child;
  double maxWidth;
  WebContainer({required this.child, this.maxWidth = 1440});
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Container(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

class Circle extends StatelessWidget {
  Color color;
  int radius;
  EdgeInsets? padding;
  Circle({required this.radius, required this.color, this.padding});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        width: radius * 2,
        height: radius * 2,
      ),
    );
  }
}

String money(double? value) {
  if (value == null) return "";
  return NumberFormat.compactSimpleCurrency().format(value);
}

Future<T?> goTo<T>(BuildContext context, Widget view, {fullscreenDialog = false, fullscreenDialogMobileOnly = false}) {
  if (fullscreenDialogMobileOnly) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(child: view);
        });
  }
  return Navigator.of(context).push<T>(MaterialPageRoute(builder: (context) => view, fullscreenDialog: fullscreenDialog));
}

DateTime fromTimeStamp(String timestamp) {
  return Jiffy(timestamp).dateTime;
}

String toTimeStamp(DateTime date) {
  return Jiffy(date).dateTime.toIso8601String();
}

DateTime? fromTimeStampOpt(String? timestamp) {
  if (timestamp == null) return null;
  return Jiffy(timestamp).dateTime;
}

String? toTimeStampOpt(DateTime? date) {
  if (date == null) return null;
  return Jiffy(date).dateTime.toIso8601String();
}

String? enumToString(dynamic type) => type?.name;

// DateTime? fromTimeStampOpt(Timestamp? timestamp) {
//   return timestamp?.toDate();
// }
// Timestamp? toTimeStampOpt(DateTime? date) {
//   return date != null ? Timestamp.fromDate(date) : null;
// }

// DateTime fromTimeStamp(Timestamp timestamp) {
//   return timestamp.toDate();
// }
// Timestamp toTimeStamp(DateTime date) {
//   return Timestamp.fromDate(date);
// }

int enumToInt(dynamic type) => type?.index;


ResponsiveScreenSizeTypes getResponsiveScreenSize(BuildContext context) {
  var screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth < 576) return ResponsiveScreenSizeTypes.xs;
  if (screenWidth < 768) return ResponsiveScreenSizeTypes.sm;
  if (screenWidth < 992) return ResponsiveScreenSizeTypes.md;
  if (screenWidth < 1200) return ResponsiveScreenSizeTypes.lg;
  return ResponsiveScreenSizeTypes.xl;
}

int getItemsPerRow(BuildContext context, {int? xs = 1, int? sm, int? md, int? lg, int? xl}) {
  if (xs == null && sm == null && md == null && lg == null) return 1;
  var screenSizeType = getResponsiveScreenSize(context);
  switch (screenSizeType) {
    case ResponsiveScreenSizeTypes.xs:
      return (xs ?? sm ?? md ?? lg ?? xl )!;
    case ResponsiveScreenSizeTypes.sm:
      return (sm ?? xs ?? md ?? lg ?? xl )!;
    case ResponsiveScreenSizeTypes.md:
      return (md ?? lg ?? sm ?? xs ?? xl )!;
    case ResponsiveScreenSizeTypes.lg:
      return (lg ?? md ?? xl ?? sm ?? xs)!;
    case ResponsiveScreenSizeTypes.xl:
      return (xl ?? lg ?? md ?? sm ?? xs)!;
  }
}

bool isMobile(BuildContext context) {
  return [ResponsiveScreenSizeTypes.xs, ResponsiveScreenSizeTypes.sm, ResponsiveScreenSizeTypes.md].contains(getResponsiveScreenSize(context));
}

enum ResponsiveScreenSizeTypes { xs, sm, md, lg, xl }
