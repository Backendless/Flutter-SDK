part of backendless_sdk;

class MessageStatus implements Comparable<MessageStatus> {
  String? messageId;
  String? errorMessage;
  PublishStatusEnum? status;

  MessageStatus();

  MessageStatus.fromJson(Map json) {
    messageId = json['messageId'];
    errorMessage = json['errorMessage'];
    final jsonStatus = json['status'];

    if (jsonStatus is int) {
      status = PublishStatusEnum.values[jsonStatus];
    } else {
      status = stringToEnum(PublishStatusEnum.values, jsonStatus);
    }
  }

  Map toJson() => {
        'messageId': messageId,
        'errorMessage': errorMessage,
        'status': status?.index,
      };

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is MessageStatus &&
          runtimeType == other.runtimeType &&
          messageId == other.messageId &&
          status == other.status;

  @override
  int get hashCode => Object.hash(messageId, status);

  @override
  String toString() =>
      "MessageStatus{messageId='$messageId', status='$status'}";

  @override
  int compareTo(MessageStatus other) {
    if (this == other) {
      return 0;
    } else {
      int statusDiff = status == null
          ? (other.status == null ? 0 : -1)
          : status!.index.compareTo(other.status!.index);
      if (statusDiff != 0) {
        return statusDiff;
      } else {
        return messageId == null
            ? (other.messageId == null ? 0 : -1)
            : messageId!.compareTo(other.messageId!);
      }
    }
  }
}

// ignore: constant_identifier_names
enum PublishStatusEnum { FAILED, PUBLISHED, SCHEDULED, CANCELLED, UNKNOWN }