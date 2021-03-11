import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Todo extends Equatable {
  final bool complete;
  final String id;
  final String note;
  final String task;

  Todo(this.task, {this.complete = false, String note = '', String id})
      : this.note = note ?? '',
        this.id = id ?? Uuid().v4();

  Todo copyWith({bool complete, String id, String note, String task}) {
    return Todo(
      task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  @override
  List<Object> get props => [complete, id, note, task];

  @override
  String toString() =>
      'TodoModel { complete: $complete, task: $task, note: $note, id: $id }';

  Todo todoEntity() {
    return Todo(task);
  }

  static Todo fromEntity(Todo todoModelentity) {
    return Todo(
      todoModelentity.task,
      complete: todoModelentity.complete ?? false,
      note: todoModelentity.note,
      id: todoModelentity.id ?? Uuid().v4(),
    );
  }
}
