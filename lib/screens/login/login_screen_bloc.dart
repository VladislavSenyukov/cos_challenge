import 'package:cos_challenge/core/preferences_manager.dart';
import 'package:cos_challenge/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_screen_bloc.freezed.dart';

class LoginScreenBloc extends Cubit<LoginScreenState> {
  LoginScreenBloc()
    : super(LoginScreenState(textController: TextEditingController())) {
    _updateUserIdText();
  }

  void _updateUserIdText() async {
    final userId = await PreferencesManager.getUserId();
    if (userId != null) {
      state.textController.text = userId;
      return;
    }
    await Future.delayed(Duration(seconds: 1));
    emit(state.copyWith(event: Event(LoginScreenEvent.focusTextField())));
  }

  void loginWithUserId(String userId) async {
    if (userId.isEmpty) return;
    emit(state.copyWith(isLoading: true));
    await Future.delayed(Duration(seconds: 1));
    await PreferencesManager.setUserId(userId.replaceAll(' ', ''));
    emit(
      state.copyWith(
        isLoading: false,
        event: Event(LoginScreenEvent.onLoginSuccessful()),
      ),
    );
  }
}

@freezed
abstract class LoginScreenState with _$LoginScreenState {
  const factory LoginScreenState({
    @Default(false) bool isLoading,
    required TextEditingController textController,
    Event<LoginScreenEvent>? event,
  }) = _LoginScreenState;
}

@freezed
sealed class LoginScreenEvent with _$LoginScreenEvent {
  const factory LoginScreenEvent.onLoginSuccessful() =
      LoginScreenEventOnLoginSuccessful;
  const factory LoginScreenEvent.focusTextField() =
      LoginScreenEventFocusTextField;
}
