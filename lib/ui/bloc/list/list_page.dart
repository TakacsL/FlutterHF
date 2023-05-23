import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPageBloc extends StatefulWidget {
  const ListPageBloc({super.key});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {

  //late Future<Widget> myListView;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ListBloc>(context).add(ListLoadEvent());
  }

  Widget getList() {
    List<Widget> list = <Widget>[];
    if (BlocProvider.of<ListBloc>(context).state is ListLoaded){
      var it = (BlocProvider.of<ListBloc>(context).state as ListLoaded).props.iterator;
      it.moveNext();
      for (UserItem i in (it.current as List)) {
              list.add(Padding(padding: const EdgeInsets.all(16.0), child: Row(
                children: [
                  Image(
                    image: NetworkImage(i.avatarUrl),
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
    return BlocConsumer<ListBloc, ListState> (
        listener: (context, state) {
          if (state is ListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.props[0] as String)),
            );
          }
          if (state is ListLoading) {
            try {
              context.loaderOverlay.show();
            }
            catch (e) {
              debugPrint(e.toString());
            }
          } else {
            try {
              context.loaderOverlay.hide();
            }
            catch (e) {
              debugPrint(e.toString());
            }
          }
        }
        ,
        builder: (context, state) {
          if (state is ListLoaded) {
            return Scaffold(body: loaded());
          } else {
            return Scaffold(body:loadingStill());
          }
        }
    );
  }

  Widget loadingStill() => const Center(child: CircularProgressIndicator(),);

  Widget  loaded() {
    return ScaffoldMessenger(child:
        Scaffold(
        appBar: AppBar(
          title: const Text('Flutter HF'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
                GetIt.I<SharedPreferences>().clear();
                debugPrint("Sharedpreferences getString('token') should be null, it is ${GetIt.I<SharedPreferences>().getString('token') ?? 'null'}");
              },
            ),
          ],
        ),
        body: Center(
            child: Padding(padding: const EdgeInsets.all(10), child: getList(),)
        ),
      )
    );
  }
}
