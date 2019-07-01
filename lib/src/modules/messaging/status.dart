part of backendless_sdk;

class MessageStatus implements Comparable<MessageStatus> {
  String messageId;
  String errorMessage;
  PublishStatusEnum status;

  MessageStatus();

  MessageStatus.fromJson(Map json) : 
    messageId = json['messageId'],
    errorMessage = json['errorMessage'],
    status = PublishStatusEnum.values[json['status']];

  Map toJson() =>
    {
      'messageId': messageId,
      'errorMessage': errorMessage,
      'status': status?.index,
    };

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is MessageStatus &&
          runtimeType == other.runtimeType &&
          this.messageId == other.messageId &&
          this.status == other.status;

  @override
  int get hashCode => hashValues(messageId, status);

  @override
  String toString() =>
      "MessageStatus{messageId='$messageId', status='$status'}";

  @override
  int compareTo(MessageStatus other) {
    if (this == other) {
      return 0;
    } else {
      int statusDiff = this.status == null
          ? (other.status == null ? 0 : -1)
          : this.status.index.compareTo(other.status.index);
      if (statusDiff != 0) {
        return statusDiff;
      } else {
        return this.messageId == null
            ? (other.messageId == null ? 0 : -1)
            : this.messageId.compareTo(other.messageId);
      }
    }
  }
}

enum PublishStatusEnum { FAILED, PUBLISHED, SCHEDULED, CANCELLED, UNKNOWN }