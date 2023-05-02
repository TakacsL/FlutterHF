import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>((event, emit) async {
      try {
        debugPrint('Starting to fetch list data');
        emit(ListLoading());
        Map<String, dynamic> headers = {
          'Authorization': 'Bearer ${GetIt.I<SharedPreferences>().getString('token') ?? 'null'}',        //TODO megkeresni a login tokent akkor is, ha nincs remember me
        };
        final response = await GetIt.I<Dio>().get('/users', options : Options(
          headers: headers,
        ));
        List<UserItem> responseList = <UserItem>[];
        for (Map<String, String> map in response.data) {
          responseList.add(UserItem(map['name'] ?? 'name', map['avatarUrl'] ?? 'avatarUrl'));
        }
        //List<UserItem> responseList = response.data;
        debugPrint("Response finished, size is ${responseList.length}");
        emit(ListLoaded(responseList));
      }
      catch (e) {
        debugPrint(e.toString());
        emit(ListError(e.toString()));
      }
    });
  }
}
