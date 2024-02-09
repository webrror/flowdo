import 'package:flowdo/common/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// LQDateFormatter provides methods to format a date/time string
///
/// - `customDateTime()`
class FLDateFormatter {
  /// Method to convert Date/Time
  ///
  /// From [any] to [any] format
  ///
  /// Provide method with raw date in String format, the input format (defaults to `DateFormats.isoFormatUTC` format) and the output format.
  ///
  /// Method outputs a String with the entered output format
  String customDateTime({
    required String inputString,
    DateTime? inputDatetime,
    String inputFormat = DateTimeFormats.isoFormatLocal,
    required String outputFormat,
  }) {
    try {
      if (inputDatetime != null) {
        return DateFormat(outputFormat).format(inputDatetime);
      } else if (inputString.trim().isEmpty) {
        throw Exception("inputFromApiString should not be empty");
      } else {
        DateTime temp = DateFormat(inputFormat).parse(inputString);
        return DateFormat(outputFormat).format(temp);
      }
    } catch (e) {
      debugPrint("ERROR :: FLDateFormatter :: customDateTime() :: ${e.toString()}");
      throw Exception(e);
    }
  }
}