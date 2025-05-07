// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventFeedbackAdapter extends TypeAdapter<EventFeedback> {
  @override
  final int typeId = 3;

  @override
  EventFeedback read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventFeedback(
      eventId: fields[0] as String,
      feedback: fields[1] as String,
      rating: fields[2] as double,
      submittedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EventFeedback obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.eventId)
      ..writeByte(1)
      ..write(obj.feedback)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.submittedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventFeedbackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
