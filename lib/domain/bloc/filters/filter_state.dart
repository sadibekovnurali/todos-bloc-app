part of 'filter_bloc.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}

class FilterLoadInProgress extends FilterState {}

class FilterLoadSuccess extends FilterState {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;

  const FilterLoadSuccess(this.filteredTodos, this.activeFilter);

  @override
  List<Object> get props => [filteredTodos, activeFilter];

  @override
  String toString() {
    return 'FilterLoadSuccess: { filteredTodos: $filteredTodos, activeFilter: $activeFilter }';
  }
}
