import 'dart:async';
import 'dart:convert';
import 'package:cos_challenge/core/network_models.dart';
import 'package:cos_challenge/core/snippet.dart';
import 'package:cos_challenge/core/preferences_manager.dart';
import 'package:cos_challenge/utils/json_string_fixer.dart';
import 'package:cos_challenge/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';

part 'vin_search_screen_bloc.freezed.dart';

class VinSearchScreenBloc extends Cubit<VinSearchScreenState> {
  VinSearchScreenBloc()
    : super(VinSearchScreenState(textController: TextEditingController())) {
    _init();
  }

  void _init() async {
    final userId = await PreferencesManager.getUserId();
    emit(state.copyWith(userId: userId));
  }

  void logout() async {
    await PreferencesManager.setUserId(null);
    emit(state.copyWith(event: Event(VinSearchScreenEvent.onLogout())));
  }

  void onVinEntered(String vin) async {
    emit(state.copyWith(isLoading: true, vinData: null));
    try {
      final response = await CosChallenge.httpClient.get(
        Uri.https('anyUrl'),
        headers: {CosChallenge.user: vin},
      );
      if (response.statusCode == 200) {
        final body = JsonStringFixer.fix(response.body);
        final vinData = VinData.fromJson(json.decode(body));
        _onVinDataFetched(vinData);
      } else if (response.statusCode == 300) {
        _decodeVinChoices(response.body);
      } else {
        Map<String, dynamic> error = json.decode(response.body);
        final message = error['message'];
        if (message is! String) return;
        _emitError(VinSearchScreenError.unknown(message));
      }
    } catch (exception) {
      _emitError(_convertExceptionToError(exception));
    }
    emit(state.copyWith(isLoading: false));
  }

  void onVinChoiceSelected(VinData vinData) {
    final vin = vinData.externalId;
    if (vin != null) onVinEntered(vin);
  }

  void _onVinDataFetched(VinData vinData) {
    emit(state.copyWith(vinData: vinData));
    PreferencesManager.setLastVinData(vinData);
  }

  void _decodeVinChoices(String body) {
    Iterable iterator = json.decode(body);
    var vinChoices = List<VinData>.from(
      iterator.map((model) => VinData.fromJson(model)),
    );
    vinChoices.sort((a, b) {
      final similarityA = a.similarity;
      final similarityB = b.similarity;
      if (similarityA == null || similarityB == null) return 0;
      return similarityA > similarityB ? -1 : 1;
    });
    if (vinChoices.isEmpty) {
      _emitError(VinSearchScreenError.notFound());
    }
    emit(
      state.copyWith(
        event: Event(VinSearchScreenEvent.showVinChoices(vinChoices)),
      ),
    );
  }

  void _emitError(VinSearchScreenError error) async {
    final lastVinData = await PreferencesManager.getLastVinData();
    emit(
      state.copyWith(
        event: Event(VinSearchScreenEvent.error(error)),
        vinData: lastVinData,
      ),
    );
  }

  VinSearchScreenError _convertExceptionToError(Object exception) {
    if (exception is ClientException && exception.message == 'Auth') {
      return VinSearchScreenError.auth();
    } else if (exception is TimeoutException) {
      return VinSearchScreenError.timeout();
    } else if (exception is FormatException) {
      return VinSearchScreenError.parser(exception.toString());
    } else {
      return VinSearchScreenError.unknown(exception.toString());
    }
  }
}

@freezed
abstract class VinSearchScreenState with _$VinSearchScreenState {
  const factory VinSearchScreenState({
    @Default(false) bool isLoading,
    String? userId,
    VinData? vinData,
    required TextEditingController textController,
    Event<VinSearchScreenEvent>? event,
  }) = _VinSearchScreenState;
}

@freezed
sealed class VinSearchScreenEvent with _$VinSearchScreenEvent {
  const factory VinSearchScreenEvent.onLogout() = VinSearchScreenEventOnLogout;
  const factory VinSearchScreenEvent.error(VinSearchScreenError error) =
      VinSearchScreenEventError;
  const factory VinSearchScreenEvent.showVinChoices(List<VinData> vinChoices) =
      VinSearchScreenEventShowVinChoices;
}

@freezed
sealed class VinSearchScreenError with _$VinSearchScreenError {
  const factory VinSearchScreenError.auth() = VinSearchScreenErrorAuth;
  const factory VinSearchScreenError.timeout() = VinSearchScreenErrorTimeout;
  const factory VinSearchScreenError.parser(String message) =
      VinSearchScreenErrorParser;
  const factory VinSearchScreenError.notFound() = VinSearchScreenErrorNotFound;
  const factory VinSearchScreenError.unknown(String message) =
      VinSearchScreenErrorUnknown;
}
