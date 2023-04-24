import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final dio = Dio();

  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>((event, emit) {
      sendRequest(event).listen((state) {
        emit(state);
      });
    });
  }




  LoginState get initialState => LoginForm();

  @override
  Stream<LoginState> mapEventToState(LoginState currentState, LoginEvent event,) async* {
    debugPrint(currentState.toString());
    if (currentState is LoginForm) {
      yield LoginLoading();

      debugPrint("now sending post to /login");
      try {
        final token = await dio.post('/login', data: {'email': event.props[0], 'password': event.props[1]});

        yield LoginSuccess();
        if (event.props[2] == true) debugPrint("Itt kéne elmenteni a SaredPreferencesbe a tokent");
      } catch (error) {
        debugPrint(error.toString());
        yield LoginError(error.toString());
      }
    }
  }

  Stream<LoginState> sendRequest(LoginEvent event) async* {
    debugPrint(event.toString());

    yield LoginLoading();

    debugPrint("now sending post to /login");
    try {
      final token = await dio.post('/login', data: {'email': event.props[0], 'password': event.props[1]});

      yield LoginSuccess();
      if (event.props[2] == true) debugPrint("Itt kéne elmenteni a SaredPreferencesbe a tokent");
    } catch (error) {
      debugPrint(error.toString());
      yield LoginError(error.toString());
    }
  }
}
