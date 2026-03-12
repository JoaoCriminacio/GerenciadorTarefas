
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/model/tarefa.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  late final SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _carregarSharedPreferences();
  }

  void _carregarSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      campoOrdenacao = prefs.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO) ?? Tarefa.CAMPO_ID;
      usarOrdemDecrescente = prefs.getBool(FiltroPage.USAR_ORDEM_DECRESCENTE) ?? false;
      descricaoController.text = prefs.getString(FiltroPage.CHAVE_FILTRO_DESCRICAO) ?? '';
    });
  }

  @override
  Widget build (BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(title: Text('Filtro e Ordenação')),
          body: _criarBody(),
        ),
        onWillPop: onVoltarClick,
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
                groupValue: campoOrdenacao,
                onChanged: _onCampoOrdenacaoChanged,
              ),
              Text(_camposParaOrdenacao[campo] ?? ''),
            ],
          ),
        Divider(),
        Row(
          children: [
            Checkbox(
                value: usarOrdemDecrescente,
                onChanged: _onDecrescenteChanged,
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
            onChanged: _onFiltroDescricaoChanged,
          ),
        )
      ],
    );
  }

  Future<bool> onVoltarClick() async {
    Navigator.of(context).pop(alterouValores);
    return true;
  }

  void _onCampoOrdenacaoChanged (String? valor){
    prefs.setString(FiltroPage.CHAVE_CAMPO_ORDENACAO, valor ?? '');
    alterouValores = true;
    setState(() {
      campoOrdenacao = valor ?? '';
    });
  }

  void _onDecrescenteChanged(bool? valor){
    prefs.setBool(FiltroPage.USAR_ORDEM_DECRESCENTE, valor == true);
    alterouValores = true;
    setState(() {
      usarOrdemDecrescente = valor == true;
    });
  }

  void _onFiltroDescricaoChanged(String? valor) {
    prefs.setString(FiltroPage.CHAVE_FILTRO_DESCRICAO, valor ?? '');
    alterouValores = true;
  }
}