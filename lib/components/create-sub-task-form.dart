import 'dart:math';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:taskly/models/task.dart';
import 'package:taskly/models/sub-task.dart';
import 'package:taskly/theme/colors/app_colors.dart';
import 'package:taskly/providers/sub-tasks-provider.dart';
import 'package:taskly/@mixins/form_validations_mixin.dart';

class CreateSubTaskForm extends StatefulWidget {
  final Task task;

  const CreateSubTaskForm({super.key, required this.task});

  @override
  State<CreateSubTaskForm> createState() => _CreateSubTaskFormState();
}

class _CreateSubTaskFormState extends State<CreateSubTaskForm>
    with FormValidationsMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  bool isLoading = false;

  Future<void> handleSubmitCreateSubTaskForm() async {
    setState(() => isLoading = true);

    final bool isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      return;
    }

    formKey.currentState?.save();

    try {
      final newSubTask = SubTask(
        id: DateTime.now().microsecondsSinceEpoch.remainder(10000000),
        taskId: widget.task.id,
        title: formData['title'] as String,
      );

      await Provider.of<SubTasksProvider>(context, listen: false)
          .saveSubTask(newSubTask);

      if (mounted) {
        Navigator.pop(context);
      }

      setState(() => isLoading = false);
    } catch (err) {
      print('Error while try to create sub-task: $err');

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error while try to create sub-task!'),
          content: const Text(
              'An error occurred while saving the sub-task. Please try again.'),
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Add new sub-task',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Form(
            key: formKey,
            child: TextFormField(
              style: TextStyle(color: AppColors.contentPrimary),
              decoration: InputDecoration(
                labelText: 'Sub-task name',
              ),
              textInputAction: TextInputAction.send,
              onSaved: (String? value) => formData['title'] = value ?? '',
              onFieldSubmitted: (_) => handleSubmitCreateSubTaskForm(),
              validator: isNotEmpty,
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
                    onPressed: () => handleSubmitCreateSubTaskForm(),
                    icon: Transform.rotate(
                      angle: 45 * pi / 180,
                      child: Icon(IconlyLight.send),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
