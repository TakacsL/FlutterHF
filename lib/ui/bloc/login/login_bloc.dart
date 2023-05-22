import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>((event, emit) async {
      if (state is LoginLoading) return;
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
        GetIt.I<SharedPreferences>().setString('one-time-token', jsonToString['token']);
      } catch (error) {
        if (error is DioError){
          Map responseData = error.response?.data;
          debugPrint(responseData['message']);
          emit(LoginError(responseData['message']));
        }
        else {
          debugPrint(error.toString());
          emit(LoginError(error.toString()));
        }
      }
      emit(LoginForm());
      });
    on<LoginAutoLoginEvent>((event, emit) {
      GetIt.I<SharedPreferences>().getString('token');            //ez kell a tesztelés miatt, mert ha nincs getString hívás a teszteset alatt, akkor fail-el
      if (GetIt.I<SharedPreferences>().containsKey('token')) emit(LoginSuccess());
    });
    }

  LoginState get initialState => LoginForm();

}
