class Validators {

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Name";
    }

    if (value.length > 50) {
      return "Maximum 50 characters allowed";
    }

    return null;
  }

  static String? mobileValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Mobile Number";
    }

    if (value.length != 10) {
      return "Mobile must be 10 digits";
    }

    return null;
  }
  static String? addressValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Address is required";
    }

    if (value.length < 10) {
      return "Enter valid address";
    }

    return null;
  }

}