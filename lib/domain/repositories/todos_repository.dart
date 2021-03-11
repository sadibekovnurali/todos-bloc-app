import 'package:todos_bloc/domain/models/todo_model.dart';

abstract class TodosRepository {
  Future<List<Todo>> loadTodos();

  Future saveTodos(List<Todo> todos);
}
