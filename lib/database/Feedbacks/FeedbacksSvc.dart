import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import './FeedbackModel.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class FeedbacksSvc {
  static Future<List<FeedbackModel>> getFeedbacks() async {
    var snapshots = await db.collection("feedbacks").get();
    return snapshots.docs.map((doc) => FeedbackModel.fromJson(doc.data())).toList();
  }

  static Future<FeedbackModel?> getFeedbackById(String id) async {
    var snapshot = await db.collection("feedbacks").doc(id).get();
    return snapshot.exists ? FeedbackModel.fromJson(snapshot.data()!) : null;
  }

  static Future<void> saveFeedback(FeedbackModel feedback) async {
    await db.collection("feedbacks").doc(feedback.id).set(feedback.toJson(), SetOptions(merge: true));
  }

  static Future<void> upsertFeedback(FeedbackModel feedback) async {
    feedback.id ??= db.collection("feedbacks").doc().id;
    await db.collection("feedbacks").doc(feedback.id).set(feedback.toJson());
  }

  static StreamSubscription listen(Function(List<FeedbackModel>) onData) {
    return db.collection('feedbacks').snapshots().listen((snapshots) => onData(snapshots.docs.map((doc) => FeedbackModel.fromJson(doc.data())).toList()));
  }

  static StreamSubscription listenById(String id, Function(FeedbackModel?) onData) {
    return db.collection('feedbacks').doc(id).snapshots().listen((snapshot) => onData(snapshot.exists ? FeedbackModel.fromJson(snapshot.data()!) : null));
  }

  static StreamSubscription listenToFeedbacksByUserId(String userId, Function(List<FeedbackModel>) onData) {
    return db.collection('equipment').where('userId', isEqualTo: userId).snapshots().listen((snapshots) => onData(snapshots.docs.map((doc) => FeedbackModel.fromJson(doc.data())).toList()));
  }
}
