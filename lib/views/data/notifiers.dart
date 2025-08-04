import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);  
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);

ValueNotifier<String> nameNotifier= ValueNotifier('');
ValueNotifier<String> phoneNumberNotifier= ValueNotifier('');
ValueNotifier<String> passwordNotifier= ValueNotifier('');
ValueNotifier<int> codeNotifier= ValueNotifier(0);
