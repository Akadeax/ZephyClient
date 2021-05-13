import 'package:timeago/timeago.dart';

String timestampToShortForm(int unix) {
  var date = DateTime.fromMillisecondsSinceEpoch(unix * 1000);
  return format(date, locale: "en_short");
}