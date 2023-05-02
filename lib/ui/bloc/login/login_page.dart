import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {
  final _formKey = GlobalKey<FormState>();
  final fnevController = TextEditingController();
  final jelszoController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Flutter HF title"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Felhasználónév',
                              ),
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              controller: fnevController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'A felhasználónév mező nem lehet üres';
                                }
                                const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                                    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                                    r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                                    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                                    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                                    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                                    r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                                final regex = RegExp(pattern);

                                return value.isNotEmpty &&
                                    !regex.hasMatch(value)
                                    ? 'Írj be egy valós e-mail címet'
                                    : null;
                              },
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Jelszó',
                              ),
                              obscureText: true,
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              controller: jelszoController,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'A jelszó mező nem lehet üres';
                                }
                                if (value.length <= 6) {
                                  return 'Nem elég hosszú a jelszó';
                                }
                                return null;
                              },
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            child: CheckboxListTile(
                              title: const Text("Remember me!"),
                              value: rememberMe,
                              onChanged: (bool? value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            )
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                debugPrint('FNev is :${fnevController.text}');                    //login@gmail.com
                                debugPrint('Jelszó is :${jelszoController.text}');                //password
                                debugPrint(BlocProvider.of<LoginBloc>(context).state.toString());
                                if (BlocProvider.of<LoginBloc>(context).state is! LoginLoading) {
                                  debugPrint("State is LoginForm adding LoginSubmitEvent");
                                  /*ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  );*/
                                  BlocProvider.of<LoginBloc>(context).add(LoginSubmitEvent(fnevController.text, jelszoController.text, rememberMe));
                                }
                              }
                            },
                            child: const Text('Bejelentkezés'),
                          ),
                        ),
                      ], //children
                    ),
                  )
                ],
              ),
            ),
          );

  }

  @override
  void dispose() {
    super.dispose();
  }
}
