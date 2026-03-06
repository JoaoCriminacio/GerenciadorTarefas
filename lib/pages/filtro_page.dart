
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/model/tarefa.dart';

class FiltroPage extends StatefulWidget {
  static const ROUTE_NAME = '/filtro';
  static const CHAVE_CAMPO_ORDENACAO = 'campoOrdenacao';
  static const USAR_ORDEM_DECRESCENTE = 'usarOrdemDecrescente';
  static const CHAVE_FILTRO_DESCRICAO = 'filtroDescricao';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage> {

  final _camposParaOrdenacao = {
    Tarefa.CAMPO_ID: 'Código',
    Tarefa.CAMPO_DESCRICAO: 'Descrição',
    Tarefa.CAMPO_PRAZO: 'Prazo'
  };

  final descricaoController = TextEditingController();
  String campoOrdenacao = Tarefa.CAMPO_ID;
  bool usarOrdemDecrescente = false;
  bool alterouValores = false;

  @override
  Widget build (BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(title: Text('Filtro e Ordenação')),
          body: _criarBody(),
        ),
        onWillPop: null,
    );
  }

  Widget _criarBody() {
    return ListView(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text('Campo para ordenação')
        ),
        for (final campo in _camposParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: _camposParaOrdenacao,
                onChanged: null,
              ),
              Text(_camposParaOrdenacao[campo] ?? ''),
            ],
          ),
        Divider(),
        Row(
          children: [
            Checkbox(
                value: usarOrdemDecrescente,
                onChanged: null,
            ),
            Text('Usar ordem decrescente')
          ],
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: InputDecoration(labelText: 'Descrição começa com'),
            controller: descricaoController,
            onChanged: null,
          ),
        )
      ],
    );
  }
}