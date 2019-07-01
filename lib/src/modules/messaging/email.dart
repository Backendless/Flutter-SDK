part of backendless_sdk;

class EmailEnvelope {
  String query;
  Set<String> to;
  Set<String> cc;
  Set<String> bcc;

  EmailEnvelope();

  EmailEnvelope.fromJson(Map json)
      : query = json['query'],
        to = json['to'],
        cc = json['cc'],
        bcc = json['bcc'];

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
