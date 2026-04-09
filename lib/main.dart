import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/pages/filtro_page.dart';
import 'package:gerenciador_tarefas/pages/lista_tarefas_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Tarefas',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        primaryColor: Colors.black,
      ),
      home: ListaTarefasPage(),
      routes: {
        FiltroPage.ROUTE_NAME: (BuildContext context) => FiltroPage(),
      },
    );
  }
}
