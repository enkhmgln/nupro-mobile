import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  final indexNotFound = -1;
  final _placeholder = '----/--/--';
  TextEditingValue? _lastNewValue;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// provides placeholder text when user start editing
    if (oldValue.text.isEmpty) {
      oldValue = oldValue.copyWith(
        text: _placeholder,
      );
      newValue = newValue.copyWith(
        text: _fillInputToPlaceholder(newValue.text),
      );
      return newValue;
    }

    /// nothing changes, nothing to do
    if (newValue == _lastNewValue) {
      return oldValue;
    }
    _lastNewValue = newValue;

    int offset = newValue.selection.baseOffset;

    /// restrict user's input within the length of date form
    if (offset > 10) {
      return oldValue;
    }

    if (oldValue.text == newValue.text && oldValue.text.isNotEmpty) {
      return newValue;
    }

    final String oldText = oldValue.text;
    final String newText = newValue.text;
    String? resultText;

    /// handle user editing, there're two cases:
    /// 1. user add new digit: replace '-' at cursor's position by user's input.
    /// 2. user delete digit: replace digit at cursor's position by '-'
    int index = _indexOfDifference(newText, oldText);
    if (oldText.length < newText.length) {
      /// add new digit
      String newChar = newText[index];
      if (index == 4 || index == 7) {
        index++;
        offset++;
      }
      resultText = oldText.replaceRange(index, index + 1, newChar);
      if (offset == 4 || offset == 7) {
        offset++;
      }
    } else if (oldText.length > newText.length) {
      /// delete digit
      if (oldText[index] != '/') {
        resultText = oldText.replaceRange(index, index + 1, '-');
        if (offset == 5 || offset == 8) {
          offset--;
        }
      } else {
        resultText = oldText;
      }
    }

    /// verify the number and position of splash character
    final splashes = resultText!.replaceAll(RegExp(r'[^/]'), '');
    int count = splashes.length;
    if (resultText.length > 10 ||
        count != 2 ||
        resultText[4].toString() != '/' ||
        resultText[7].toString() != '/') {
      return oldValue;
    }

    return oldValue.copyWith(
      text: resultText,
      selection: TextSelection.collapsed(offset: offset),
      composing:
          Platform.isIOS ? const TextRange(start: 0, end: 0) : TextRange.empty,
    );
  }

  int _indexOfDifference(String? cs1, String? cs2) {
    if (cs1 == cs2) {
      return indexNotFound;
    }
    if (cs1 == null || cs2 == null) {
      return 0;
    }
    int i;
    for (i = 0; i < cs1.length && i < cs2.length; ++i) {
      if (cs1[i] != cs2[i]) {
        break;
      }
    }
    if (i < cs2.length || i < cs1.length) {
      return i;
    }
    return indexNotFound;
  }

  String _fillInputToPlaceholder(String? input) {
    if (input == null || input.isEmpty) {
      return _placeholder;
    }
    String result = _placeholder;
    final index = [0, 1, 3, 4, 6, 7, 8, 9];
    final length = min(index.length, input.length);
    for (int i = 0; i < length; i++) {
      result = result.replaceRange(index[i], index[i] + 1, input[i]);
    }
    return result;
  }
}
