
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/network/data_source_interceptor.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_page.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_page.dart';
import 'package:flutter_homework/ui/provider/list/list_page.dart';
import 'package:flutter_homework/ui/provider/login/login_page.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

//DO NOT MODIFY
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureFixDependencies();
  await configureCustomDependencies();
  runApp(const MyApp());
}

//DO NOT MODIFY
Future configureFixDependencies() async {
  var dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ),
  );
  dio.interceptors.add(DataSourceInterceptor());
  GetIt.I.registerSingleton(dio);
  GetIt.I.registerSingleton(await SharedPreferences.getInstance());
  GetIt.I.registerSingleton(<NavigatorObserver>[]);
}

//Add custom dependencies if necessary
Future configureCustomDependencies() async {

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: {         //nem kell a LoginPageBloc() '/'-ként routenak, mert home-ban van megadva leljebb
          '/list': (context) => LoaderOverlay(child: BlocProvider(create: (context) => ListBloc(), child: const ListPageProvider(),))
        },
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const LoaderOverlay(child: LoginPageProvider(loginbloc:LoginPageBloc()),),

        //DO NOT MODIFY
        navigatorObservers: GetIt.I<List<NavigatorObserver>>(),
        //DO NOT MODIFY
        debugShowCheckedModeBanner: false,
      ),
    );


  }
}

/*class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final fnevController = TextEditingController();
  final jelszoController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Felhasználónév',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: fnevController,
                  // The validator receives the text that the user has entered.
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

                    return value!.isNotEmpty && !regex.hasMatch(value)
                        ? 'Írj be egy valós e-mail címet'
                        : null;
                  },
                )
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Jelszó',
                    ),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:CheckboxListTile(
                    title: const Text("Remember me!"),
                    value: rememberMe,
                    onChanged: (bool? value) { setState(() {
                        rememberMe = value!;
                      });},
                  )
              ),

              Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          debugPrint('FNev is :${fnevController.text}');
                          debugPrint('Jelszó is :${jelszoController.text}');
                        }
                      },
                      child: const Text('Bejelentkezés'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}*/


