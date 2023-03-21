// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FeedbackModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackModel _$FeedbackModelFromJson(Map<String, dynamic> json) =>
    FeedbackModel(
      id: json['id'] as String?,
      date: fromTimeStampOpt(json['date'] as String?),
      feedback: json['feedback'] as String?,
      email: json['email'] as String?,
      type: FeedbackTypes.fromString(json['type'] as String?),
    );

Map<String, dynamic> _$FeedbackModelToJson(FeedbackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'feedback': instance.feedback,
      'email': instance.email,
      'date': toTimeStampOpt(instance.date),
      'type': enumToString(instance.type),
    };
