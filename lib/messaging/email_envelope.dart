part of backendless_sdk;

class EmailEnvelope {
  String? query;
  Set<String>? to;
  Set<String>? cc;
  Set<String>? bcc;

  EmailEnvelope();

  EmailEnvelope.fromJson(Map json) {
    query = json['query'];
    to = Set<String>.from(json['to']);

    final jsonCc = json['cc'];
    if (jsonCc == null)
      cc = null;
    else
      cc = Set<String>.from(jsonCc);

    final jsonBcc = json['bcc'];
    if (jsonBcc == null)
      bcc = null;
    else
      bcc = Set<String>.from(jsonBcc);
  }

  Map toJson() => {
        'query': query,
        'to': to,
        'cc': cc,
        'bcc': bcc,
      };
}
