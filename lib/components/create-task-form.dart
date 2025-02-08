import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskly/@mixins/form_validations_mixin.dart';
import 'package:taskly/providers/tasks-provider.dart';
import 'package:taskly/theme/colors/app_colors.dart';

class CreateTaskForm extends StatefulWidget {
  const CreateTaskForm({super.key});

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm>
    with FormValidationsMixin {
  final TextEditingController _taskPriorityController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  bool isLoading = false;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  _showDatePicker(
    BuildContext context,
    void Function(void Function()) setState,
  ) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    ).then((date) {
      if (date == null) {
        return;
      }

      setState(() {
        _selectedDate = date;
        formData['date'] = date;
      });
    });
  }

  _showTimePicker(
    BuildContext context,
    void Function(void Function()) setState,
  ) {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext ctx, Widget? child) {
          final mediaQueryData = MediaQuery.of(ctx);

          return MediaQuery(
            data: mediaQueryData.alwaysUse24HourFormat
                ? mediaQueryData
                : mediaQueryData.copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        }).then((time) {
      if (time == null) {
        return;
      }

      setState(() {
        _selectedTime = time;
        formData['reminderTime'] = time;
      });
    });
  }

  _clearTimePicker(void Function(void Function()) setState) {
    setState(() {
      _selectedTime = null;
      formData.remove('reminderTime');
    });
  }

  Future<void> handleSubmitCreateTaskForm(
    void Function(void Function()) setState,
  ) async {
    setState(() => isLoading = true);

    final bool isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      return;
    }

    formKey.currentState?.save();

    try {
      await Provider.of<TasksProvider>(context, listen: false)
          .saveTask(data: formData);

      if (mounted) {
        Navigator.pop(context);
      }

      setState(() {
        isLoading = false;
        _selectedTime = null;
        _selectedDate = DateTime.now();
        formData.clear();
      });
    } catch (err) {
      setState(() => isLoading = false);
      print('Error while try to create a task: $err');

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error while try to create a task...'),
          content: const Text(
              'An error occurred while saving the task. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _selectedTime = null;
    _selectedDate = DateTime.now();
    _taskPriorityController.dispose();
    formData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<({int value, String label, Color color})> _priorityList = [
      (value: 0, label: 'No priority', color: Colors.grey),
      (value: 1, label: 'Priority 1', color: AppColors.accentBlue),
      (value: 2, label: 'Priority 2', color: AppColors.accentOrange),
      (value: 3, label: 'Priority 3', color: AppColors.error),
    ];

    int dropdownValue = _priorityList.first.value;

    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true, // Permite que o modal ocupe mais espaço
          builder: (ctx) {
            return StatefulBuilder(
              builder: (
                BuildContext context,
                void Function(void Function()) setState,
              ) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add new task',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  style: TextStyle(
                                      color: AppColors.contentPrimary),
                                  decoration: InputDecoration(
                                    labelText: 'Task name',
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onSaved: (String? value) =>
                                      formData['title'] = value ?? '',
                                  validator: isNotEmpty,
                                ),
                                TextFormField(
                                  minLines: 1,
                                  maxLines: 10,
                                  style: TextStyle(
                                      color: AppColors.contentPrimary),
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                  ),
                                  textInputAction: TextInputAction.newline,
                                  onSaved: (String? value) =>
                                      formData['description'] = value ?? '',
                                ),
                                DropdownMenu(
                                  expandedInsets: EdgeInsets.zero,
                                  inputDecorationTheme:
                                      const InputDecorationTheme(),
                                  label: const Text('Priority'),
                                  leadingIcon:
                                      Icon(HugeIcons.strokeRoundedFlag03),
                                  textStyle: const TextStyle(
                                    color: AppColors.contentPrimary,
                                  ),
                                  controller: _taskPriorityController,
                                  onSelected: (int? value) {
                                    if (value != null) {
                                      formData['priority'] = value;
                                    }
                                  },
                                  dropdownMenuEntries:
                                      _priorityList.map((item) {
                                    return DropdownMenuEntry<int>(
                                      value: item.value,
                                      label: item.label,
                                      leadingIcon: Icon(
                                        HugeIcons.strokeRoundedFlag03,
                                        color: item.color,
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: AppColors.borderSecondary,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: TextButton.icon(
                                        onPressed: () =>
                                            _showDatePicker(ctx, setState),
                                        icon: Icon(
                                            HugeIcons.strokeRoundedCalendar02),
                                        label: Text(
                                          DateFormat('dd/MM/y')
                                              .format(_selectedDate),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: AppColors.borderSecondary,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          TextButton.icon(
                                            onPressed: () =>
                                                _showTimePicker(ctx, setState),
                                            icon: Icon(HugeIcons
                                                .strokeRoundedAlarmClock),
                                            label: Text(
                                              _selectedTime != null
                                                  ? '${_selectedTime!.hour.toString()}: ${_selectedTime!.minute.toString()}'
                                                  : 'Reminder',
                                            ),
                                          ),
                                          if (_selectedTime != null)
                                            IconButton(
                                              onPressed: () =>
                                                  _clearTimePicker(setState),
                                              icon: Icon(Icons.close),
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: isLoading
                                ? SpinKitFoldingCube(
                                    color: AppColors.contentBrand,
                                  )
                                : IconButton.filled(
                                    onPressed: () =>
                                        handleSubmitCreateTaskForm(setState),
                                    icon: Transform.rotate(
                                      angle: 45 * pi / 180,
                                      child: Icon(IconlyLight.send),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
