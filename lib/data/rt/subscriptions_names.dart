part of backendless_sdk;

enum SubscriptionNames {
  OBJECTS_CHANGES,
  PUB_SUB_CONNECT,
  PUB_SUB_MESSAGES,
  PUB_SUB_COMMANDS,
  PUB_SUB_USERS,
  RSO_CONNECT,
  RSO_CHANGES,
  RSO_CLEARED,
  RSO_COMMANDS,
  RSO_INVOKE,
  RSO_USERS,
}

extension RTTypes on SubscriptionNames {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
