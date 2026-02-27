import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/model/tarefa.dart';
import 'package:gerenciador_tarefas/widget/conteudo_form_dialog.dart';

class ListaTarefasPage extends StatefulWidget {

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {

  final _tarefas = <Tarefa>[
    Tarefa(id: 1, descricao: 'Fazer atividade avaliativa 1', prazo: DateTime.now().add(const Duration(days: 5)))
  ];

  var ultimoId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Nova Tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      centerTitle: true,
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

    return ListView.separated(
        itemCount: _tarefas.length,
        itemBuilder: (BuildContext context, int index) {
          final tarefa = _tarefas[index];
          return ListTile(
            title: Text('${tarefa.id} - ${tarefa.descricao}'),
            subtitle: Text('Prazo: ${tarefa.prazoFormatado}'),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  void _abrirForm({ Tarefa? tarefaAtual, int? indice }) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(tarefaAtual == null ? 'Nova Tarefa' : 'Alterar a Tarefa: ${tarefaAtual.id}'),
            content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')
              ),
              TextButton(
                  onPressed: (){
                    if (key.currentState != null && key.currentState!.dadosValidados()) {
                      setState(() {
                        final novaTarefa = key.currentState!.novaTarefa;
                        if (indice == null) {
                          novaTarefa.id = ++ultimoId;
                          _tarefas.add(novaTarefa);
                        } else {
                          _tarefas[indice] = novaTarefa;
                        }
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Salvar')
              )
            ],
          );
        }
    );
  }
}