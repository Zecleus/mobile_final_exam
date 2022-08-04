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
        allTasks: List.from(state.allTasks)..add(event.task),
        removedTasks: state.removedTasks,
      ));
    });

    on<UpdateTask>((event, emit) {
      final state = this.state;
      final task = event.task;
      final int index = state.allTasks.indexOf(task);

      List<Task> allTasks = List.from(state.allTasks)..remove(task);
      task.isDone == false
          ? allTasks.insert(index, task.copyWith(isDone: true))
          : allTasks.insert(index, task.copyWith(isDone: false));

      emit(
        TasksState(allTasks: allTasks, removedTasks: state.removedTasks),
      );
    });

    on<DeleteTask>((event, emit) {
      final state = this.state;

      emit(TasksState(
          allTasks: state.allTasks,
          removedTasks: List.from(state.allTasks)..remove(event.task)));
    });

    on<RemoveTask>((event, emit) {
      final state = this.state;
      final task = event.task;

      List<Task> allTasks = List.from(state.allTasks)..remove(task);
      List<Task> removedTasks = List.from(state.removedTasks)
        ..add(event.task.copyWith(isDeleted: true));

      emit(TasksState(allTasks: allTasks, removedTasks: removedTasks));
    });
  }
  // void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {}
  // void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {}

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }
}
