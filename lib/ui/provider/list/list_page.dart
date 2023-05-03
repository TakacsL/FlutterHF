import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_page.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ListPageProvider extends StatefulWidget {
  const ListPageProvider({Key? key}) : super(key: key);

  @override
  State<ListPageProvider> createState() => _ListPageProviderState();
}

class _ListPageProviderState extends State<ListPageProvider> {
  @override
  void initState() {
    super.initState();
    debugPrint("Provider initState");
    SchedulerBinding.instance.addPostFrameCallback((_) => _initializePage());
  }

  //TODO: Fetch user list from model
  void _initializePage() async {
    debugPrint("Provider Initialitze Page");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListBloc, ListState>(
      listener: (context, state) {
        if (state is ListLoading) context.loaderOverlay.show();
        if (state is ListLoaded) {
          debugPrint("ListLoaded caught");
          context.loaderOverlay.hide();
        }
          if (state is ListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.props[0] as String)),
            );
          }
      },
      child: const ListPageBloc(),
    );
  }
}
