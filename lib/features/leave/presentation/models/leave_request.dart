import 'package:workwise/generated/app_localizations.dart';

class LeaveRequest {
  final String id;
  final String type;
  final String startDate;
  final String endDate;
  final String status;

  const LeaveRequest({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  static const _requests = [
    LeaveRequest(
      id: 'annual-1',
      type: 'Annual',
      startDate: 'May 20',
      endDate: 'May 24',
      status: 'approved',
    ),
    LeaveRequest(
      id: 'casual-1',
      type: 'Casual',
      startDate: 'June 10',
      endDate: 'June 11',
      status: 'pending',
    ),
    LeaveRequest(
      id: 'sick-1',
      type: 'Sick',
      startDate: 'July 05',
      endDate: 'July 06',
      status: 'rejected',
    ),
  ];

  static LeaveRequest? findById(String id) {
    for (final request in _requests) {
      if (request.id == id) {
        return request;
      }
    }
    return null;
  }

  String get dateRange => '$startDate - $endDate';

  String localizedType(AppLocalizations localization) {
    return switch (type) {
      'Annual' => localization.annualLeave,
      'Casual' => localization.casualLeave,
      'Sick' => localization.sickLeave,
      _ => type,
    };
  }

  String localizedStatus(AppLocalizations localization) {
    return switch (status) {
      'approved' => localization.approved,
      _ => status,
    };
  }
}
