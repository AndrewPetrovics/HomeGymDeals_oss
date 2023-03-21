import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_gym_deals/misc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'FeedbackModel.g.dart';



@JsonSerializable()
class FeedbackModel {
  String? id, feedback, email;

  @JsonKey(fromJson: fromTimeStampOpt, toJson: toTimeStampOpt)
  DateTime? date;



  @JsonKey(fromJson: FeedbackTypes.fromString, toJson: enumToString)
  FeedbackTypes? type;

  FeedbackModel({
    this.id,
    this.date,
    this.feedback,
    this.email,
    this.type
  });
  
  
  factory FeedbackModel.fromJson(Map<String, dynamic> json) => _$FeedbackModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackModelToJson(this);
}


enum FeedbackTypes{
  sellerSuggestion('Seller Suggestions');

  final String name;
  const FeedbackTypes(this.name);
 
  factory FeedbackTypes.fromString(String? type) => FeedbackTypes.values.firstWhere((v) => v.name == type);



}



