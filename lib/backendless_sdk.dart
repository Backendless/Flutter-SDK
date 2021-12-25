library backendless_sdk;

import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

part 'src/data/data.dart';
part 'src/data/data_query_builder.dart';
part 'src/data/data_store.dart';
part 'src/data/map_driven_data_store.dart';
part 'src/backendless.dart';
part 'src/invoker.dart';
part 'src/common/prefs.dart';
part 'src/common/authKeys.dart';
part 'src/utils/init_app_data.dart';
