import 'package:bloc/bloc.dart';
import 'package:bloc_finals_exam/models/task.dart';
import 'package:equatable/equatable.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    // on<AddTask>((_onAddTask)
    on<AddTask>((event, emit) {
      final state = this.state;
      emit(TasksState(allTasks: List.from(state.allTasks)..add(event.task)));
    });

    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }
  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {}
  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {}
}
