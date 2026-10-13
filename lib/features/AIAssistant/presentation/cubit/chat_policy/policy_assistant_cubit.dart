import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/features/AIAssistant/data/models/chat_message.dart';
import 'package:workwise/features/AIAssistant/domain/usecases/ask_policy_question_use_case.dart';

import 'policy_assistant_state.dart';

class PolicyAssistantCubit extends Cubit<PolicyAssistantState> {
  PolicyAssistantCubit({
    required this.askPolicyQuestionUseCase,
    required this.welcomeMessage,
    required this.employeeIdNotAvailableMessage,
    required this.noAnswerMessage,
    required this.unexpectedErrorMessage,
  }) : super(
         PolicyAssistantInitial(
           messages: [ChatMessage(text: welcomeMessage, isUser: false)],
         ),
       );

  final AskPolicyQuestionUseCase askPolicyQuestionUseCase;

  final String welcomeMessage;
  final String employeeIdNotAvailableMessage;
  final String noAnswerMessage;
  final String unexpectedErrorMessage;

  static const String _chatStorageKey = 'policy_assistant_messages';

  final TextEditingController messageController = TextEditingController();

  late final List<ChatMessage> _messages = [
    ChatMessage(text: welcomeMessage, isUser: false),
  ];

  bool _isRestoringMessages = true;
  bool _isSending = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  bool get isRestoringMessages => _isRestoringMessages;

  bool get isSending => _isSending;

  void _emitInitial() {
    if (isClosed) return;

    emit(
      PolicyAssistantInitial(
        messages: List.unmodifiable(_messages),
        isRestoringMessages: _isRestoringMessages,
        isSending: _isSending,
      ),
    );
  }

  Future<void> loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMessages = prefs.getString(_chatStorageKey);

      if (isClosed) return;

      if (savedMessages != null) {
        final decoded = jsonDecode(savedMessages);

        if (decoded is List && decoded.isNotEmpty) {
          _messages
            ..clear()
            ..addAll(
              decoded.map(
                (item) => ChatMessage.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              ),
            );
        }
      }
    } catch (e) {
      debugPrint('Failed to restore policy chat: $e');
    } finally {
      _isRestoringMessages = false;
      _emitInitial();
    }
  }

  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        _chatStorageKey,
        jsonEncode(_messages.map((message) => message.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Failed to save policy chat: $e');
    }
  }

  Future<void> sendCurrentMessage() async {
    final text = messageController.text.trim();

    if (text.isEmpty || _isSending || _isRestoringMessages) {
      return;
    }

    messageController.clear();

    await sendMessage(text);
  }

  Future<void> sendMessage(String text) async {
    final question = text.trim();

    if (question.isEmpty || _isRestoringMessages || _isSending) {
      return;
    }

    _isSending = true;

    _messages.add(ChatMessage(text: question, isUser: true));

    emit(
      PolicyAssistantLoading(
        messages: List.unmodifiable(_messages),
        isSending: true,
      ),
    );

    await _saveMessages();

    if (isClosed) return;

    try {
      final employeeId = sl<LocalStorage>().getEmployeeCode();

      if (employeeId == null || employeeId.toString().trim().isEmpty) {
        await _failLastUserMessage(employeeIdNotAvailableMessage);
        return;
      }

      final result = await askPolicyQuestionUseCase({
        'employee_id': employeeId,
        'question': question,
      });

      if (isClosed) return;

      await result.fold<Future<void>>(
        (failure) async {
          await _failLastUserMessage(failure.message);
        },
        (policyAssistant) async {
          _isSending = false;

          _messages.add(
            ChatMessage(
              text: policyAssistant.answer ?? noAnswerMessage,
              isUser: false,
            ),
          );

          await _saveMessages();

          if (isClosed) return;

          emit(
            PolicyAssistantSuccess(
              messages: List.unmodifiable(_messages),
              isSending: false,
            ),
          );
        },
      );
    } catch (e) {
      if (isClosed) return;

      await _failLastUserMessage(unexpectedErrorMessage);
    }
  }

  Future<void> _failLastUserMessage(String message) async {
    _isSending = false;

    for (int i = _messages.length - 1; i >= 0; i--) {
      final item = _messages[i];

      if (item.isUser && !item.failed) {
        _messages[i] = ChatMessage(text: item.text, isUser: true, failed: true);
        break;
      }
    }

    await _saveMessages();

    if (isClosed) return;

    emit(
      PolicyAssistantFailure(
        message: message,
        messages: List.unmodifiable(_messages),
        isSending: false,
      ),
    );
  }

  Future<void> deleteMessage(int index) async {
    if (index < 0 || index >= _messages.length) {
      return;
    }

    final message = _messages[index];

    // Allow deleting failed user messages only.
    if (!message.isUser || !message.failed) {
      return;
    }

    _messages.removeAt(index);

    await _saveMessages();

    if (isClosed) return;

    emit(
      PolicyAssistantSuccess(
        messages: List.unmodifiable(_messages),
        isSending: _isSending,
      ),
    );
  }

  @override
  Future<void> close() {
    messageController.dispose();
    return super.close();
  }
}
