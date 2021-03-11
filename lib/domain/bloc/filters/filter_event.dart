part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();
}

class FilterUpdated extends FilterEvent {
  final VisibilityFilter filter;

  FilterUpdated(this.filter);

  @override
  // TODO: implement props
  List<Object> get props => [filter];

  @override
  String toString() => 'FilterUpdated { filter: $filter }';
}

class TodosUpdated extends FilterEvent {
  final List<Todo> todos;

  const TodosUpdated(this.todos);

  @override
  // TODO: implement props
  List<Object> get props => [todos];

  @override
  String toString() => 'TodosUpdated { todos: $todos }';
}
