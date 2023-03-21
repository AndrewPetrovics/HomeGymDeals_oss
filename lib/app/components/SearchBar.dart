
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBar extends StatelessWidget {
  TextEditingController textController;
  Function(String)? onSubmitted;
  Function(String)? onChanged;
  SearchBar({required this.textController, this.onSubmitted, this.onChanged});


  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: SizedBox(
            height: 54,
            child: TextField(
              onChanged: onChanged,
              controller: textController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: 'What are you looking for?',
                fillColor: Colors.white70,
              ),
              onSubmitted: onSubmitted,
            ),
          ),
        );
  }
}

