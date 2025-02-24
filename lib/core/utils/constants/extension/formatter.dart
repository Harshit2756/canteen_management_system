import 'package:intl/intl.dart';

import '../enums/enums.dart';

extension AppDateTime on DateTime {
  /// Returns date in "MMM dd, yyyy HH:mm" format
  /// Example: "Jan 25, 2024 14:30"
  String get dateTimeWithMonth {
    return DateFormat('MMM dd, yyyy HH:mm').format(this);
  }

  /// Returns date and time as "Jan 25, 2024 2:30 PM"
  String get fullDateWith12Hour {
    return DateFormat('MMM dd, yyyy h:mm a').format(this);
  }

  /// Returns date as "January 25, 2024"
  String get fullDateWithFullMonth {
    return DateFormat('MMMM dd, yyyy').format(this);
  }

  /// Returns date in "MMM dd, yyyy" format
  /// Example: "Jan 25, 2024"
  String get fullDateWithMonth {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  /// Returns date as "Jan 25, 2024"
  String get fullDateWithShortMonth {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  /// Returns full weekday name
  /// Example: "Monday"
  String get fullWeekday {
    return DateFormat('EEEE').format(this);
  }

  /// Returns date in "yyyy-MM-dd" format
  /// Example: "2024-01-25"
  String get isoDate {
    return DateFormat("yyyy-MM-dd").format(this);
  }

  /// Returns date and time as "2024-01-25 – 14:30"
  String get isoDateTime {
    return DateFormat('yyyy-MM-dd – kk:mm').format(this);
  }

  /// Returns full ISO format "2024-01-25T14:30:45"
  String get isoFull {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(this);
  }

  /// Returns month and year as "January 2024"
  String get monthAndYear {
    return DateFormat('MMMM yyyy').format(this);
  }

  /// Returns date in "dd-MM-yyyy" format
  /// Example: "25-01-2024"
  String get numericDate {
    return DateFormat("dd-MM-yyyy").format(this);
  }

  /// Returns as "25 Jan 2024 at 2:30 PM"
  String get readableDateAndTime {
    return DateFormat("dd MMM yyyy 'at' h:mm a").format(this);
  }

  /// Returns as "Jan 25, 2024 • 2:30 PM"
  String get readableDateAndTime2 {
    return DateFormat("MMM dd, yyyy '•' h:mm a").format(this);
  }

  /// Returns as "Thursday, Jan 25 • 2:30 PM"
  String get readableDateAndTime3 {
    return DateFormat("EEEE, MMM dd '•' h:mm a").format(this);
  }

  /// Returns date in "dd MMM" format
  /// Example: "25 Jan"
  String get shortDateWithMonth {
    return DateFormat("dd MMM").format(this);
  }

  /// Returns date in "MMM d, y" format
  /// Example: "Jan 25, 24"
  String get shortDateWithShortYear {
    return DateFormat("MMM d, y").format(this);
  }

  /// Returns short month and year as "Jan 2024"
  String get shortMonthAndYear {
    return DateFormat('MMM yyyy').format(this);
  }

  /// Returns short weekday name
  /// Example: "Mon"
  String get shortWeekday {
    return DateFormat('EEE').format(this);
  }

  /// Returns time in AM/PM format
  /// Example: "2:30 PM"
  String get time12Hour {
    return DateFormat('h:mm a').format(this);
  }

  /// Returns time as "14:30"
  String get time24Hour {
    return DateFormat('HH:mm').format(this);
  }

  /// Returns time in 24-hour format with seconds
  /// Example: "14:30:45"
  String get time24HourWithSeconds {
    return DateFormat('HH:mm:ss').format(this);
  }
}

extension EnumExtension on Enum {}

extension FormateDataCell on dynamic {
  static String formatCellValue(String? field, dynamic value) {
    if (value == null) return 'N/A';
    switch (field) {
      case 'totalWorkingHours':
        return value.toStringAsFixed(2);
      default:
        if (field != null &&
            (field.contains('Date') || field.contains('date'))) {
          if (value is String) {
            final date = DateTime.parse(value);
            return date.fullDateWithShortMonth;
          } else if (value is DateTime) {
            return value.fullDateWithShortMonth; // Directly use DateTime
          }
        }
        if (field!.contains('Time') || field.contains('time')) {
          if (value is String) {
            final date = DateTime.parse(value).toLocal();
            return date.time12Hour;
          } else if (value is DateTime) {
            return value.time12Hour; // Directly use DateTime
          }
        }
        return value.toString();
    }
  }
}

extension StringToEnumExtension on String {
  AttendanceStatus toAttendanceStatusEnum() {
    return AttendanceStatus.values.firstWhere(
      (element) => element.name == toUpperCase(),
      orElse: () => throw Exception('Invalid AttendanceStatus: $this'),
    );
  }

  AttendaceUser toAttendanceUserEnum() {
    return AttendaceUser.values.firstWhere(
      (element) => element.name == toUpperCase(),
      orElse: () => throw Exception('Invalid AttendaceUser: $this'),
    );
  }

  Status toStatusEnum() {
    return Status.values.firstWhere(
      (element) => element.name == toUpperCase(),
      orElse: () => throw Exception('Invalid VisitorStatus: $this'),
    );
  }

  UserRole toUserRoleEnum() {
    return UserRole.values.firstWhere(
      (element) => element.name == toUpperCase(),
      orElse: () => throw Exception('Invalid UserRole: $this'),
    );
  }
}
