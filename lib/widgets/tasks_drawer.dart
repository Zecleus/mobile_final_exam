import 'package:flutter/material.dart';

import '../blocs/bloc_exports.dart';
import '../screens/recycle_bin_screen.dart';
import '../screens/tabs_screen.dart';
import '../test_data.dart';

class TasksDrawer extends StatefulWidget {
  const TasksDrawer({Key? key}) : super(key: key);

  @override
  State<TasksDrawer> createState() => _TasksDrawerState();
}

class _TasksDrawerState extends State<TasksDrawer> {
  _switchToDarkTheme(BuildContext context, bool isDarkTheme) {
    if (isDarkTheme) {
      return context.read<SwitchBloc>().add(SwitchOnEvent());
    } else {
      return context.read<SwitchBloc>().add(SwitchOffEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              child: Text(
                'Task Drawer',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return ListTile(
                  leading: const Icon(Icons.folder_special),
                  title: const Text('My Tasks'),
                  trailing: Text(
                    '${state.pendingTasks.length} | ${state.pendingTasks.length}', //first number is for completed, second number should be for all tasks
                  ),
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    TabsScreen.path,
                  ),
                );
              },
            ),
            const Divider(),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Recycle Bin'),
                  trailing: Text('${state.removedTasks.length}'),
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    RecycleBinScreen.path,
                  ),
                );
              },
            ),
            const Divider(),
            const Expanded(child: SizedBox()),
            BlocBuilder<SwitchBloc, SwitchState>(
              builder: (context, state) {
                return ListTile(
                  leading: BlocBuilder<SwitchBloc, SwitchState>(
                    builder: (context, state) {
                      return Switch(
                        value: state.switchValue,
                        onChanged: (newValue) =>
                            _switchToDarkTheme(context, newValue),
                      );
                    },
                  ),
                  title: state.switchValue
                      ? const Text('Switch to Light Mode')
                      : const Text('Switch to Dark Mode'),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
