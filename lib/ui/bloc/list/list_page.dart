import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPageBloc extends StatefulWidget {
  const ListPageBloc({super.key});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {

  late Future<Widget> myListView;

  @override
  void initState() {
    super.initState();
    debugPrint("Page initState");
    BlocProvider.of<ListBloc>(context).add(ListLoadEvent());
    debugPrint("Page initstate done");
  }

  void refreshList() {
    debugPrint("refreshing list, and redrawing");
    //getList().then((value) => myListView = value);
    setState(() {});
  }

  Widget getList() {
    debugPrint("Page getList");
    List<Widget> list = <Widget>[];
    if (BlocProvider.of<ListBloc>(context).state is ListLoaded){
      var it = (BlocProvider.of<ListBloc>(context).state as ListLoaded).props.iterator;
      it.moveNext();
      for (UserItem i in (it.current as List)) {
              list.add(Padding(padding: const EdgeInsets.all(16.0), child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(i.avatarUrl),
                  ),
                  const SizedBox(width: 10.0),
                  Text(i.name),
                ],
              ))
            );
      }
    }
    return ListView(
      shrinkWrap: true,
      children: list,);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Page build");
    return BlocBuilder<ListBloc, ListState> (
        builder: (context, state) {
          if (state is ListLoaded) return loaded();
          else return loadingStill();
        }
    );
  }

  Widget loadingStill() => const Center(child: CircularProgressIndicator(),);

  Widget  loaded() {
    debugPrint("Page build");
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              debugPrint("Logg me out pls"); //TODO logout
              Navigator.pushReplacementNamed(context, '/');
              GetIt.I<SharedPreferences>().remove('token');
              debugPrint("Sharedpreferences getString('token') should be null, it is ${GetIt.I<SharedPreferences>().getString('token') ?? 'null'}");
            },
          ),
        ],
      ),
      body: Center(
          child: Padding(padding: const EdgeInsets.all(10), child: getList(),)
      ),
    );
  }
}
