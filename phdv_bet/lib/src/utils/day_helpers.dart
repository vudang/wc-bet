// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart';

class DateHelper {
  static DateTime parseDateTime({required String input, String format: "MM/dd/yyyy HH:mm"}) {
    return DateFormat(format).parseUTC(input).toLocal();
  }
}

extension DayUtils on DateTime {
  /// The UTC date portion of a datetime, without the minutes, seconds, etc.
  DateTime get atMidnight {
    return DateTime.utc(year, month, day);
  }

  /// Checks that the two [DateTime]s share the same date.
  bool isSameDay(DateTime d2) {
    return year == d2.year && month == d2.month && day == d2.day;
  }

  String toCurrentTimeZone({String format: "MM/dd/yyyy HH:mm"}) {
    return DateFormat(format).format(this);
  }
}
