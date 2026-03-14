import 'package:flutter/material.dart';
import '../models/subject_model.dart';

class SubjectCheckbox extends StatelessWidget {

  final SubjectModel subject;
  final Function(bool?) onChanged;

  const SubjectCheckbox({
    super.key,
    required this.subject,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(subject.name),
      value: subject.isSelected,
      onChanged: onChanged,
    );
  }
}