import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:home_gym_deals/database/Feedbacks/FeedbackModel.dart';
import 'package:home_gym_deals/database/Feedbacks/FeedbacksSvc.dart';

class AddFeedbackViewModel {
  //
  // Private members
  //
  List<StreamSubscription>? _listeners;

  //
  // Public Properties
  //
  Function updateWidget;
  bool isLoading = true;
  var feedbackTextController = TextEditingController();
  var emailTextController = TextEditingController();

  //
  // Getters
  //

  //
  // Constructor
  //
  AddFeedbackViewModel(this.updateWidget) {
    init();
  }

  //
  // Public functions
  //
  void init() async {
    if (_listeners == null) _attachListeners();

    //
    // Write any initializing code here
    //

    isLoading = false;
    updateWidget();
  }

  void onSubmitted(String text) {}

  void onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onSendFeedback(BuildContext context) async {
    if (feedbackTextController.text.isEmpty) return;
    await FeedbacksSvc.upsertFeedback(FeedbackModel(
      date: DateTime.now(),
      feedback: feedbackTextController.text,
      email: emailTextController.text,
      type: FeedbackTypes.sellerSuggestion,
    ));

    Navigator.of(context).pop();

    
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(

        content: Text("Feedback Sent!")
));
  }

  //
  // Private functions
  //
  void _attachListeners() {
    _listeners ??= [
      //
      // Put listeners here
      //
    ];
  }

  //
  // Dispose
  //
  void dispose() {
    _listeners?.forEach((_) => _.cancel());
  }
}
