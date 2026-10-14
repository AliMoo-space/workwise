// import 'package:equatable/equatable.dart';
// import 'package:workwise/features/AIAssistant/domain/entities/policy_assistant_entity.dart';

// abstract class PolicyAssistantState extends Equatable {
//   const PolicyAssistantState();

//   @override
//   List<Object?> get props => [];
// }

// class PolicyAssistantInitial extends PolicyAssistantState {
//   const PolicyAssistantInitial();
// }

// class PolicyAssistantLoading extends PolicyAssistantState {
//   const PolicyAssistantLoading();
// }

// class PolicyAssistantSuccess extends PolicyAssistantState {
//   final PolicyAssistantEntity policyAssistant;

//   const PolicyAssistantSuccess(this.policyAssistant);

//   @override
//   List<Object?> get props => [policyAssistant];
// }

// class PolicyAssistantFailure extends PolicyAssistantState {
//   final String message;

//   const PolicyAssistantFailure(this.message);

//   @override
//   List<Object?> get props => [message];
// }

import 'package:equatable/equatable.dart';
import 'package:workwise/features/AIAssistant/data/models/chat_message.dart';

abstract class PolicyAssistantState extends Equatable {
  final List<ChatMessage> messages;
  final bool isRestoringMessages;
  final bool isSending;

  const PolicyAssistantState({
    this.messages = const [],
    this.isRestoringMessages = false,
    this.isSending = false,
  });

  @override
  List<Object?> get props => [messages, isRestoringMessages, isSending];
}

class PolicyAssistantInitial extends PolicyAssistantState {
  const PolicyAssistantInitial({
    super.messages,
    super.isRestoringMessages = true,
    super.isSending = false,
  });
}

class PolicyAssistantLoading extends PolicyAssistantState {
  const PolicyAssistantLoading({
    required super.messages,
    super.isSending = true,
  });
}

class PolicyAssistantSuccess extends PolicyAssistantState {
  const PolicyAssistantSuccess({
    required super.messages,
    super.isSending = false,
  });
}

class PolicyAssistantFailure extends PolicyAssistantState {
  final String message;

  const PolicyAssistantFailure({
    required this.message,
    required super.messages,
    super.isSending = false,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
