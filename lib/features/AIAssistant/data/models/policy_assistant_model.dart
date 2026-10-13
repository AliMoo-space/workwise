import 'package:workwise/features/AIAssistant/domain/entities/policy_assistant_entity.dart';

final class PolicyAssistantModel extends PolicyAssistantEntity {
  const PolicyAssistantModel({
    required super.employeeId,
    super.question,
    super.answer,
  });

  factory PolicyAssistantModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return PolicyAssistantModel(
      employeeId: data['employee_id'] as String,
      answer: data['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'employee_id': employeeId, 'question': question};
  }
}

// import 'package:workwise/features/AIAssistant/domain/entities/policy_assistant_entity.dart';
// final class PolicyAssistantModel extends PolicyAssistantEntity {
//   const PolicyAssistantModel({
//     required super.employeeId,
//     super.question,
//     super.answer,
//   });
//   factory PolicyAssistantModel.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     final data = json['data'];
//     if (data is! Map<String, dynamic>) {
//       throw const FormatException(
//         'Invalid policy assistant data',
//       );
//     }
//     final employeeId = data['employee_id'];
//     final answer = data['answer'];
//     if (employeeId is! String) {
//       throw const FormatException(
//         'Invalid employee ID in policy assistant response',
//       );
//     }
//     if (answer != null && answer is! String) {
//       throw const FormatException(
//         'Invalid answer in policy assistant response',
//       );
//     }
//     return PolicyAssistantModel(
//       employeeId: employeeId,
//       answer: answer as String?,
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'employee_id': employeeId,
//       if (question != null) 'question': question,
//       if (answer != null) 'answer': answer,
//     };
//   }
// }
