import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:intl/intl.dart';

class TestLogging {
  static void start() {
    group("", () {
      final logging = Backendless.logging;
      final testName = "Test Logger";
      final testMessagesNum = 42;
      final testFrequency = 21;

      final debugMsg = "Debug test message";
      final errorMsg = "Error test message";
      final fatalMsg = "Fatal test message";
      final infoMsg = "Info test message";
      final warnMsg = "Warn test message";

      final logCompleter = Completer<String>();
      Future<String> logFuture = logCompleter.future;
      Logger testLogger;

      test("Set Reporting Police ", () async {
        await logging.setLogReportingPolicy(testMessagesNum, testFrequency);

        expect(1, 1);
      });

      test("Get Logger", () async {
        final logger = logging.getLogger(testName);
        testLogger = logger;

        expect(logger, isNotNull);
      });

      test("Prepare Logs", () async {
        await testLogger.debug(debugMsg);
        await testLogger.error(errorMsg);
        await testLogger.fatal(fatalMsg);
        await testLogger.info(infoMsg);
        await testLogger.warn(warnMsg);

        await logging.flush();

        expect(1, 1);
      });

      group("Check Saved Logs", () {
        test("Get Logs File", () async {
          final logName =
              DateFormat("MMM dd yyyy").format(DateTime.now()) + ".log";
          final files = await Backendless.files.listing("logging");
          final logUrl = files
              .where((file) => file.name == logName)
              .map((file) => file.publicUrl)
              .toList()
              .first;

          final uri = Uri.parse(logUrl);
          final request = await HttpClient().getUrl(uri);
          final response = await request.close();
          response.transform(utf8.decoder).listen((receivedValue) {
            logCompleter.complete(receivedValue);
          });

          expect(1, 1);
        });

        test("Debug", () async {
          final log = await logFuture;

          expect(log, contains(debugMsg));
        });

        test("Error", () async {
          final log = await logFuture;

          expect(log, contains(errorMsg));
        });

        test("Fatal", () async {
          final log = await logFuture;

          expect(log, contains(fatalMsg));
        });

        test("Info", () async {
          final log = await logFuture;

          expect(log, contains(infoMsg));
        });

        test("Warn", () async {
          final log = await logFuture;

          expect(log, contains(warnMsg));
        });
      });
    });
  }
}
