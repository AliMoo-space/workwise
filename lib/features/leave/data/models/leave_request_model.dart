import 'package:workwise/features/leave/domain/entity/leave_request_entity.dart';

class LeaveRequestModel extends LeaveRequestEntity {
  const LeaveRequestModel({
    required super.leaveTypeId,
    required super.startDate,
    required super.endDate,
    required super.reason,
    super.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'leave_type_id': leaveTypeId,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
      if (image != null) 'image': image,
    };
  }
}
