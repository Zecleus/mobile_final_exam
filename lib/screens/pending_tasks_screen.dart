import 'package:bloc_finals_exam/models/task.dart';
import 'package:flutter/material.dart';

import '../blocs/bloc_exports.dart';

import '../widgets/tasks_list.dart';

class PendingTasksScreen extends StatelessWidget {
  const PendingTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Chip(
                  label: Text(
                    '${state.pendingTasks.length} Pending | ${state.completedTasks.length} Completed',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TasksList(tasksList: state.pendingTasks),
            ],
          ),
        );
      },
    );
  }
}
