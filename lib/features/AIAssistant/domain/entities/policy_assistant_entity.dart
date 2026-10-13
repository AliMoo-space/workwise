import 'package:equatable/equatable.dart';

class PolicyAssistantEntity extends Equatable {
  final String employeeId;
  final String? question;
  final String? answer;

  const PolicyAssistantEntity({
    required this.employeeId,
    this.question,
    this.answer,
  });

  @override
  List<Object?> get props => [employeeId, question, answer];
}
