import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/student_model.dart';
import '../models/subject_model.dart';
import '../providers/api_provider.dart';
import '../utils/validators.dart';
import '../widgets/subject_checkbox.dart';

class AdmissionFormScreen extends StatefulWidget {
  const AdmissionFormScreen({super.key});

  @override
  State<AdmissionFormScreen> createState() => _AdmissionFormScreenState();
}

class _AdmissionFormScreenState extends State<AdmissionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final admissionController = TextEditingController();

  DateTime? dob;
  DateTime? admissionDate;

  List<SubjectModel> subjects = [
    SubjectModel(name: "Maths", id: 1),
    SubjectModel(name: "Science", id: 2),
    SubjectModel(name: "Hindi", id: 3),
    SubjectModel(name: "Gujarati", id: 4),
    SubjectModel(name: "English", id: 5),
    SubjectModel(name: "Urdu", id: 6),
  ];

  Future pickDateTime(TextEditingController controller, bool isDOB) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    DateTime finalDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    controller.text = DateFormat("dd-MMM-yyyy HH:mm").format(finalDate);

    if (isDOB) {
      dob = finalDate;
    } else {
      admissionDate = finalDate;
    }
  }

  int selectedSubjects() {
    return subjects.where((s) => s.isSelected).length;
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Student Admission Screen"),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Student Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: nameController,
                  decoration: inputDecoration("Student Name", Icons.person),
                  validator: Validators.nameValidator,
                  onChanged: (value) {
                    nameController.value = nameController.value.copyWith(
                      text: value.toUpperCase(),
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: addressController,
                  decoration: inputDecoration("Student Address", Icons.home),
                  validator: Validators.addressValidator,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: mobileController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: inputDecoration(
                    "Mobile Number",
                    Icons.phone,
                  ).copyWith(counterText: ""),
                  validator: Validators.mobileValidator,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: dobController,
                  readOnly: true,
                  decoration: inputDecoration(
                    "Date of Birth",
                    Icons.calendar_today,
                  ),
                  onTap: () => pickDateTime(dobController, true),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: admissionController,
                  readOnly: true,
                  decoration: inputDecoration(
                    "Admission Date & Time",
                    Icons.access_time,
                  ),
                  onTap: () => pickDateTime(admissionController, false),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Select Subjects (Minimum 4)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const SizedBox(height: 10),

                ...subjects.map(
                  (subject) => SubjectCheckbox(
                    subject: subject,
                    onChanged: (value) {
                      setState(() {
                        subject.isSelected = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),

                Consumer<ApiProvider>(
                  builder: (context, apiProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: apiProvider.isSaveStudentLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                if (dob == null || admissionDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please select DOB and Admission Date",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (dob!.isAfter(admissionDate!)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "DOB cannot be after admission date",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (selectedSubjects() < 4) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Select minimum 4 subjects",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                List<int> selectedSubjectIds = subjects
                                    .where((s) => s.isSelected)
                                    .map((e) => e.id)
                                    .toList();

                                /// DATE FORMAT
                                String dobString = DateFormat(
                                  "dd-MMM-yyyy HH:mm",
                                ).format(dob!);

                                String admissionString = DateFormat(
                                  "dd-MMM-yyyy HH:mm",
                                ).format(admissionDate!);


                                StudentModel student = StudentModel(
                                  studentName: nameController.text,
                                  studentAddress: addressController.text,
                                  mobileNo: mobileController.text,
                                  dob: dobString,
                                  admissionDate: admissionString,
                                  subjects: selectedSubjectIds,
                                );

                                String message = await apiProvider.saveStudent(
                                  student,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );

                                if (message.toLowerCase().contains("success")) {
                                  Navigator.pop(context, true);
                                }
                              },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        child: apiProvider.isSaveStudentLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : const Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
