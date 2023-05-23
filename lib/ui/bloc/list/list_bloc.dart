import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>((event, emit) async {
      if (state is ListLoading) return;
      try {
        debugPrint('Starting to fetch list data');
        emit(ListLoading());
        /*Map<String, dynamic> headers;
        if (GetIt.I<SharedPreferences>().containsKey('token')) {
          headers = {
            'Authorization': 'Bearer ${GetIt.I<SharedPreferences>().getString('token')}',
          };
        } else {
          headers = {
          'Authorization': 'Bearer ${GetIt.I<SharedPreferences>().getString('one-time-token') ?? 'null'}',
        };
        }
        GetIt.I<Dio>().options = BaseOptions(headers: headers);*/
        /*final response = await GetIt.I<Dio>().get('/users', options : Options(
           headers: headers,
        ));*/
        var response;
        List<UserItem> responseList = <UserItem>[];
          response = await GetIt.I<Dio>().get('/users');
          for (Map<String, String> map in response.data) {
            responseList.add(UserItem(
                map['name'] ?? 'name', map['avatarUrl'] ?? 'avatarUrl'));
          }

        //List<UserItem> responseList = response.data;
        debugPrint("Response finished, size is ${responseList.length}");
        emit(ListLoaded(responseList));
      }
      catch (error) {
        if (error is DioError){
          Map responseData = error.response?.data;
          debugPrint(responseData['message']);
          emit(ListError(responseData['message']));
        }
        else {
          debugPrint(error.toString());
          emit(ListError(error.toString()));
        }
      }
    });
  }
}
