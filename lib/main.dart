import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fiscal_printer/generic_printer_bloc.dart';
import 'main_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider<GenericPrinterBloc>(
      create: (context) => GenericPrinterBloc(),
      dispose: (context, bloc) => bloc.dispose(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
