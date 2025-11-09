import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime datetime = timestamp.toDate();
  final now = DateTime.now();
  final difference = now.difference(datetime);

  String pluralize(int value, String unitSingular, String unitPlural, {String? unitDual}) {
    if (value == 1) {
      return '$unitSingular'; // e.g., "دقيقة"
    } else if (value == 2 && unitDual != null) {
      return '$unitDual'; // e.g., "ساعتين"
    }
    return '$unitPlural'; // e.g., "دقائق", "ساعات", "أيام", "أشهر"
  }

  if (difference.inMinutes < 1) {
    return 'الآن'; // Just now
  } else if (difference.inMinutes < 60) {
    // Less than an hour ago
    final minutes = difference.inMinutes;
    final unit = pluralize(minutes, 'دقيقة', 'دقائق', unitDual: 'دقيقتين');
    return 'قبل $minutes $unit';
  } else if (difference.inHours < 24) {
    // Less than a day ago
    final hours = difference.inHours;
    final unit = pluralize(hours, 'ساعة', 'ساعات', unitDual: 'ساعتين');
    return 'قبل $hours $unit';
  } else if (difference.inDays < 30) {
    // Less than a month ago (approximately)
    final days = difference.inDays;
    final unit = pluralize(days, 'يوم', 'أيام', unitDual: 'يومين');
    return 'قبل $days $unit';
  } else if (difference.inDays < 365) {
    // Less than a year ago (approximately, using 30 days per month)
    final months = (difference.inDays / 30).round();
    // Ensure months is at least 1 if difference.inDays is within this range
    final actualMonths = months > 0 ? months : 1;
    final unit = pluralize(actualMonths, 'شهر', 'أشهر', unitDual: 'شهرين');
    return 'قبل $actualMonths $unit';
  } else {
    // More than a year ago, return the full date
    return DateFormat('yyyy/MM/dd').format(datetime);
  }
}