import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/tarefa.dart';

class ConteudoFormDialog extends StatefulWidget {
  final Tarefa? tarefaAtual;

  ConteudoFormDialog({ Key? key, this.tarefaAtual }): super(key: key);

  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {
  final formkey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final prazoController = TextEditingController();
  final prazoFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.tarefaAtual != null) {
      descricaoController.text = widget.tarefaAtual!.descricao;
      prazoController.text = widget.tarefaAtual!.prazoFormatado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: descricaoController,
            decoration: const InputDecoration(labelText: 'Descrição'),
            validator: (String? valor) {
              if (valor == null || valor.isEmpty) {
                return 'Informe a Descrição';
              }
              return null;
            },
          ),
          TextFormField(
            controller: prazoController,
            decoration: InputDecoration(labelText: 'Prazo',
                prefixIcon: IconButton(
                    onPressed: _mostrarCalendario,
                    icon: Icon(Icons.calendar_today)
                ),
                suffixIcon: IconButton(
                    onPressed: () => prazoController.clear(),
                    icon: Icon(Icons.close)
                ),
            ),
            readOnly: true,
          )
        ],
      )
    );
  }

  void _mostrarCalendario() {
    final dataFormatada = prazoController!.text;
    var data = DateTime.now();

    if (dataFormatada.isNotEmpty) {
      data = prazoFormat.parse(dataFormatada);
    }

    showDatePicker(
        context: context,
        initialDate: data,
        firstDate: data.subtract(Duration(days: 61)),
        lastDate: data.add(Duration(days: 61)),
    ).then((DateTime? dataSelecionada){
      if (dataSelecionada != null) {
        setState(() {
          prazoController.text = prazoFormat.format(dataSelecionada);
        });
      }
    });
  }

  bool dadosValidados() => formkey.currentState?.validate() == true;

  Tarefa get novaTarefa => Tarefa(
      id: widget.tarefaAtual?.id ?? 0,
      descricao: descricaoController.text,
      prazo: prazoController.text.isEmpty ? null : prazoFormat.parse(prazoController.text)
  );
}
