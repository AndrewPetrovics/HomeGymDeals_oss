import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:home_gym_deals/misc.dart';
import './AddFeedbackViewModel.dart';

class AddFeedbackView extends StatefulWidget {
  const AddFeedbackView({Key? key}) : super(key: key);

  @override
  State<AddFeedbackView> createState() => _AddFeedbackViewState();
}

class _AddFeedbackViewState extends State<AddFeedbackView> {
  late AddFeedbackViewModel vm;

  @override
  void initState() {
    vm = AddFeedbackViewModel(() {
      if (mounted) setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: CloseButton(
            //     onPressed: () => vm.onCancel(context),
            //   ),
            // ),
            ListTile(
              title: Text("Suggest a seller"),
              subtitle: Text("What site do you want us to start tracking deals for?"),
            ),
            Spacing(),
            TextField(
              onChanged: (_) => vm.updateWidget(),
              controller: vm.feedbackTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: 'Add feedback',
                label: Text("Feedback"),
                fillColor: Colors.white70,
              ),
              maxLines: 7,
              onSubmitted: vm.onSubmitted,
            ),
            Spacing(),
            TextField(
              onChanged: (_) => vm.updateWidget(),
              controller: vm.emailTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                label: Text("Reply-to email (optional)"),
                hintText: 'Email',
                fillColor: Colors.white70,
              ),
              onSubmitted: vm.onSubmitted,
            ),
            Spacing(),

            ButtonBar(
              //alignment: MainAxisAlignment.end,
              children: [
                FilledButton.tonal(onPressed: () => vm.onCancel(context), child: Text("Cancel")),
                FilledButton(onPressed: () => vm.onSendFeedback(context), child: Text("Send feedback"))
              ],
            )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [

            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
