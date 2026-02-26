import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/model/tarefa.dart';

class ListaTarefasPage extends StatefulWidget {

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {

  final _tarefas = <Tarefa>[
    Tarefa(id: 1, descricao: 'Fazer atividade avaliativa 1', prazo: DateTime.now().add(const Duration(days: 5)))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Nova Tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      title: const Text('Tarefas'),
      actions: [
        IconButton(
            onPressed: (){},
            icon: const Icon(Icons.list),
        )
      ],
    );
  }

  Widget _criarBody() {
    if (_tarefas.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma tarefa encontrada!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }

    return Container();
  }
}