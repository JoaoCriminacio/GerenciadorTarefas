import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/dao/tarefa_dao.dart';
import 'package:gerenciador_tarefas/model/tarefa.dart';
import 'package:gerenciador_tarefas/pages/filtro_page.dart';
import 'package:gerenciador_tarefas/widget/conteudo_form_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaTarefasPage extends StatefulWidget {

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {

  static const ACAO_EDITAR = 'editar';
  static const ACAO_DELETAR = 'deletar';

  final _tarefas = <Tarefa>[];
  final _dao = TarefaDao();

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
            onPressed: _abrirFiltro,
            icon: const Icon(Icons.list),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _atualizarLista();
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
          return PopupMenuButton(
            child: ListTile(
              title: Text('${tarefa.id} - ${tarefa.descricao}'),
              subtitle: Text(tarefa.prazo != null ? 'Prazo: ${tarefa.prazoFormatado}' : ''),
            ),
            itemBuilder: (BuildContext context) => criarItemMenuPopup(),
            onSelected: (String valorSelecionado) {
              if (valorSelecionado == ACAO_EDITAR) {
                _abrirForm(tarefaAtual: tarefa);
              } else {
                _excluir(tarefa);
              }
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  List<PopupMenuEntry<String>>criarItemMenuPopup() {
    return [
      PopupMenuItem<String>(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Editar'),
            )
          ],
        )
      ),
      PopupMenuItem<String>(
          value: ACAO_DELETAR,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Deletar'),
              )
            ],
          )
      )
    ];
  }

  void _excluir(Tarefa tarefa) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.amber),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Atenção')
                ),
              ],
            ),
            content: Text('Esse registro será removido definitivamente!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar')
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (tarefa.id == null) {
                      return;
                    }

                    _dao.excluir(tarefa.id!).then((success) {
                      if (success) {
                        _atualizarLista();
                      }
                    });
                  },
                  child: Text('Ok')
              ),
            ],
          );
        }
    );
  }

  void _abrirFiltro() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores) {
      if (alterouValores == true) {
        _atualizarLista();
      }
    });
  }

  void _abrirForm({ Tarefa? tarefaAtual}) {
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
                        _dao.salvar(novaTarefa).then((success) {
                          if (success) {
                            _atualizarLista();
                          }
                        });
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

  void _atualizarLista() async {
    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao = prefs.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO) ?? Tarefa.CAMPO_ID;
    final usaOrdemDecrescente = prefs.getBool(FiltroPage.USAR_ORDEM_DECRESCENTE) ?? true;
    final filtroDescricao = prefs.getString(FiltroPage.CHAVE_FILTRO_DESCRICAO) ?? '';

    final tarefas = await _dao.listar(
      filtro: filtroDescricao,
      campoOrdenacao: campoOrdenacao,
      usarOrdemDecrescente: usaOrdemDecrescente
    );
    setState(() {
      _tarefas.clear();
      if (tarefas.isNotEmpty) {
        _tarefas.addAll(tarefas);
      }
    });
  }
}