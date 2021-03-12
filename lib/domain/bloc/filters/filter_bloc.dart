import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_bloc/domain/bloc/todos/todos_bloc.dart';
import 'package:todos_bloc/domain/models/filter_enums.dart';
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
    FilterEvent event,
  ) async* {
    if (event is FilterUpdated) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is TodosUpdated) {
      yield* _mapTodosUpdatedToState(event);
    }
  }

  Stream<FilterState> _mapUpdateFilterToState(
    FilterUpdated event,
  ) async* {
    if (todosBloc is FilterLoadSuccess) {
      yield FilterLoadSuccess(
        _mapTodosToFilteredTodos(
          (todosBloc.state as TodosLoadSuccess).todos,
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilterState> _mapTodosUpdatedToState(
    TodosUpdated event,
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
