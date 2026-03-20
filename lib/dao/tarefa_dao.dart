import 'package:gerenciador_tarefas/database/database_provider.dart';
import 'package:gerenciador_tarefas/model/tarefa.dart';

class TarefaDao {
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Tarefa tarefa) async {
    final db = await dbProvider.database;
    final valores = tarefa.toMap();

    if (tarefa.id == null) {
      tarefa.id = await db.insert(Tarefa.NOME_TABELA, valores);
      return true;
    } else {
      final registrosAtualizados = await  db.update(
        Tarefa.NOME_TABELA,
        valores,
        where: '${Tarefa.CAMPO_ID} = ?',
        whereArgs: [tarefa.id]
      );

      return registrosAtualizados > 0;
    }
  }
}