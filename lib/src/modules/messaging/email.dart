part of backendless_sdk;

class EmailEnvelope {
  String query;
  Set<String> to;
  Set<String> cc;
  Set<String> bcc;

  EmailEnvelope();

  EmailEnvelope.fromJson(Map json)
      : query = json['query'],
        to = Set<String>.from(json['to']),
        cc = Set<String>.from(json['cc']),
        bcc = Set<String>.from(json['bcc']);

  Map toJson() => {
        'query': query,
        'to': to,
        'cc': cc,
        'bcc': bcc,
      };
}

class BodyParts {
  String textMessage;
  String htmlMessage;

  BodyParts(this.textMessage, this.htmlMessage);
}
