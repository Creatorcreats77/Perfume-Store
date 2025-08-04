import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';

Widget buildInputField({
  required TextEditingController controller,
  required String label,
  required String rule,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 16),
      filled: true,
      fillColor: AppColors.lightBeige,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    ),
    validator: (value) {
      if (rule == 'required') {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your $label';
        }
      } else if (rule == 'phone') {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your $label';
        } else if (!RegExp(r'^\d{8}$').hasMatch(value)) {
          return 'Enter a phone number no need 993 xxxxxxxx';
        }
      } else if (rule == 'code') {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your $label';
        } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
          return 'Code must be exactly 6 digits.';
        }
      } else if (rule == 'number') {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your $label';
        } else if (!RegExp(r'^-?\d*\.?\d+$').hasMatch(value)) {
          return 'Prices should be number';
        }
      } else if (rule == 'discount') {
        if (value == null || value.trim().isEmpty) {
          value = null;
        } else if (!RegExp(r'^-?\d*\.?\d+$').hasMatch(value)) {
          return 'Please enter a valid number';
        }
      } else if (rule == 'password') {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your $label';
        } else if (!RegExp(r'^\d{8}$').hasMatch(value)) {
          return 'Your Password should be more than 8';
        }
      }
      return null;
    },
    keyboardType: rule == 'phone' ? TextInputType.phone : TextInputType.text,
  );
}

Widget buildDescriptionField({
  required TextEditingController controller,
  required String label,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 16),
      filled: true,
      fillColor: AppColors.lightBeige,
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your $label';
      }
      return null;
    },
    maxLines: 5,
    // Allows multiline input
    keyboardType: TextInputType.multiline,
  );
}

void showErrorSnackBar(BuildContext context, String message, String? bgColor) {
  var color = Color(0xF4329C0D);
  if (bgColor == "red"){
    color = Color(0xF4AC3511);
  } else if(bgColor == "yellow"){
    color = Color(0xF4DCB71D);
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    ),
  );
}

