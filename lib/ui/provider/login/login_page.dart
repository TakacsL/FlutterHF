import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_page.dart';
import 'package:flutter_homework/ui/bloc/login/login_page.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/login/login_bloc.dart';

class LoginPageProvider extends StatefulWidget {

  final LoginPageBloc loginbloc;

  const LoginPageProvider({super.key, required this.loginbloc});

  @override
  State<LoginPageProvider> createState() => _LoginPageProviderState();
}

class _LoginPageProviderState extends State<LoginPageProvider> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _initializePage());
  }

  //TODO: Try auto-login on model
  void _initializePage() async {
    debugPrint('AutoLogin fired, token is : ${GetIt.I<SharedPreferences>().getString("token") ?? 'null'}');
      if (GetIt.I<SharedPreferences>().getString("token") != null) {
        BlocProvider.of<LoginBloc>(context).add(LoginAutoLoginEvent());
      }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(context, '/list');
          }
          if (state is LoginLoading) context.loaderOverlay.show();
          else context.loaderOverlay.hide();
          if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.props[0] as String)),
            );
            Navigator.pushReplacementNamed(context, 'home');
          }
      },
      child: const LoginPageBloc(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class LoginBlocListener extends BlocListener {
  LoginBlocListener({required super.listener});

}
