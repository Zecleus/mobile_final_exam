import 'package:bloc_finals_exam/models/task.dart';
import 'package:equatable/equatable.dart';

import '../bloc_exports.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>((event, emit) {
      final state = this.state;
      emit(TasksState(
        pendingTasks: List.from(state.pendingTasks)..add(event.task),
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: state.removedTasks,
      ));
    });

    on<UpdateTask>((event, emit) {
      final state = this.state;
      final task = event.task;

      List<Task> pendingTasks = state.pendingTasks;
      List<Task> completedTasks = state.completedTasks;

      task.isDone == false
          ? {
              pendingTasks = List.from(pendingTasks)..remove(task),
              completedTasks = List.from(completedTasks)
                ..insert(0, task.copyWith(isDone: true)),
            }
          : {
              completedTasks = List.from(completedTasks)..remove(task),
              pendingTasks = List.from(pendingTasks)
                ..insert(0, task.copyWith(isDone: false)),
            };

      emit(
        TasksState(
            pendingTasks: pendingTasks,
            completedTasks: completedTasks,
            favoriteTasks: state.favoriteTasks,
            removedTasks: state.removedTasks),
      );
    });

    on<DeleteTask>((event, emit) {
      final state = this.state;

      emit(TasksState(
          pendingTasks: state.pendingTasks,
          completedTasks: state.completedTasks,
          favoriteTasks: state.favoriteTasks,
          removedTasks: List.from(state.pendingTasks)..remove(event.task)));
    });

    on<RemoveTask>((event, emit) {
      final state = this.state;
      final task = event.task;

      List<Task> pendingTasks = List.from(state.pendingTasks)..remove(task);
      List<Task> completedTasks = List.from(state.completedTasks)..remove(task);
      List<Task> favoriteTasks = List.from(state.favoriteTasks)..remove(task);
      List<Task> removedTasks = List.from(state.removedTasks)
        ..add(event.task.copyWith(isDeleted: true));

      emit(TasksState(
          pendingTasks: pendingTasks,
          completedTasks: completedTasks,
          favoriteTasks: favoriteTasks,
          removedTasks: removedTasks));
    });

    on<MarkFavoriteOrUnfavoriteTask>((event, emit) {
      final state = this.state;
      List<Task> pendingTasks = state.pendingTasks;
      List<Task> completedTasks = state.completedTasks;
      List<Task> favoriteTasks = state.favoriteTasks;

      if (event.task.isDone == false) {
        if (event.task.isFavorite == false) {
          var taskIndex = pendingTasks.indexOf(event.task);
          pendingTasks = List.from(pendingTasks)
            ..remove(event.task)
            ..insert(taskIndex, event.task.copyWith(isFavorite: true));
          favoriteTasks.insert(0, event.task.copyWith(isFavorite: true));
        } else {
          var taskIndex = pendingTasks.indexOf(event.task);
          pendingTasks = List.from(pendingTasks)
            ..remove(event.task)
            ..insert(taskIndex, event.task.copyWith(isFavorite: false));
          favoriteTasks.remove(event.task);
        }
      } else {
        if (event.task.isFavorite == false) {
          var taskIndex = completedTasks.indexOf(event.task);
          completedTasks = List.from(completedTasks)
            ..remove(event.task)
            ..insert(taskIndex, event.task.copyWith(isFavorite: true));
          favoriteTasks.insert(0, event.task.copyWith(isFavorite: true));
        } else {
          var taskIndex = completedTasks.indexOf(event.task);
          completedTasks = List.from(completedTasks)
            ..remove(event.task)
            ..insert(taskIndex, event.task.copyWith(isFavorite: false));
          favoriteTasks.remove(event.task);
        }
      }

      emit(TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favoriteTasks,
        removedTasks: state.removedTasks,
      ));
    });
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }
}
