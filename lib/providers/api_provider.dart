import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/student_model.dart';
import '../models/subject_model.dart';
import '../services/api_service.dart';

class ApiProvider extends ChangeNotifier {
  List<SubjectModel> subjects = [];

  bool isFetchSubjectsLoading = false;
  bool isSaveStudentLoading = false;

  Future<void> fetchSubjects() async {
    isFetchSubjectsLoading = true;
    notifyListeners();

    try {
      subjects = await ApiService.getSubjects();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isFetchSubjectsLoading = false;
      notifyListeners();
    }
  }

  Future<String> saveStudent(StudentModel student) async {
    isSaveStudentLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/Candidate/SaveStudentDetails"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(student.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        fetchSubjects();
        return data["message"] ??
            data["Message"] ??
            "Student saved successfully";
      } else {
        debugPrint("Failed with status: ${response.statusCode}");
        return "Something went wrong";
      }
    } catch (e) {
      return "Error: $e";
    } finally {
      isSaveStudentLoading = false;
      notifyListeners();
    }
  }
}
