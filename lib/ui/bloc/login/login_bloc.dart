import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>((event, emit) async {
      debugPrint(event.toString());

      emit(LoginLoading());

      debugPrint("now sending post to /login");
      var jsonToString;
      try {
        final token = await GetIt.I<Dio>().post(
          '/login',
          data: {
            'email': event.props[0],
            'password': event.props[1],
          },
        );
        jsonToString = jsonDecode(token.toString());
        emit(LoginSuccess());
        if (event.props[2] == true) GetIt.I<SharedPreferences>().setString('token', jsonToString['token']);
      } catch (error) {
        debugPrint(error.toString());
        emit(LoginError(error.toString()));
      }
      });
    }

  LoginState get initialState => LoginForm();

}
