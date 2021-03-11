import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_bloc/domain/bloc/todos/todos_bloc.dart';
import 'package:todos_bloc/domain/models/filter_model.dart';
import 'package:todos_bloc/domain/models/todo_model.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  FilterBloc({this.todosBloc})
      : super(todosBloc.state is TodosLoadSuccess
            ? FilterLoadSuccess(
                (todosBloc.state as TodosLoadSuccess).todos,
                VisibilityFilter.all,
              )
            : FilterLoadInProgress()) {
    todosSubscription = todosBloc.listen((state) {
      if (state is TodosLoadSuccess) {
        add(TodosUpdated((todosBloc.state as TodosLoadSuccess).todos));
      }
    });
  }

  @override
  Stream<FilterState> mapEventToState(
    FilterEvent todosEvent,
  ) async* {
    if (todosEvent is FilterUpdated) {
      yield* _mapUpdateFilterToState(todosEvent);
    } else if (todosEvent is TodosUpdated) {
      yield* _mapTodosUpdatedToState(todosEvent);
    }
  }

  Stream<FilterState> _mapUpdateFilterToState(
    FilterUpdated todosEvent,
  ) async* {
    if (todosBloc is FilterLoadSuccess) {
      yield FilterLoadSuccess(
        _mapTodosToFilteredTodos(
          (todosBloc.state as TodosLoadSuccess).todos,
          todosEvent.filter,
        ),
        todosEvent.filter,
      );
    }
  }

  Stream<FilterState> _mapTodosUpdatedToState(
    TodosUpdated todosEvent,
  ) async* {
    final visibilityFilter = state is FilterLoadSuccess
        ? (state as FilterLoadSuccess).activeFilter
        : VisibilityFilter.all;
    yield FilterLoadSuccess(
      _mapTodosToFilteredTodos(
        (todosBloc.state as TodosLoadSuccess).todos,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  Stream<FilterState> _mapUpdatedTodosToState(
    TodosUpdated todosEvent,
  ) async* {}
  List<Todo> _mapTodosToFilteredTodos(
      List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.complete;
      } else {
        return todo.complete;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}
