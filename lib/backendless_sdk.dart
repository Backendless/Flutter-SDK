library backendless_sdk;

import 'dart:collection';
import 'dart:convert';
import 'dart:io' as io;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'package:backendless_sdk/utils/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'
    show
        ReadBuffer,
        WriteBuffer,
        describeEnum,
        kIsWeb,
        listEquals,
        visibleForTesting;
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:reflectable/reflectable.dart';
import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:backendless_sdk/data/rt/rt_lookup_service.dart';
import 'package:uuid/uuid.dart';
import 'package:synchronized/synchronized.dart';

part 'data/data.dart';
part 'data/reflector.dart';
part 'data/types.dart';
part 'data/data_store.dart';
part 'data/map_driven_data_store.dart';
part 'data/class_driven_data_store.dart';
part 'data/query_builder/data_query_builder.dart';
part 'data/query_builder/paged_query_builder.dart';
part 'data/query_builder/load_relations_query_builder.dart';
part 'data/geometry/point.dart';
part 'data/geometry/line_string.dart';
part 'data/geometry/polygon.dart';
part 'data/geometry/geometry.dart';
part 'data/geometry/spatial_reference_system_enum.dart';
part 'data/geometry/wkt_parser.dart';
part 'data/geometry/geo_json_parser.dart';
part 'data/rt/rt_client.dart';
part 'data/rt/map_event_handler.dart';
part 'data/rt/class_event_handler.dart';
part 'data/rt/i_event_handler.dart';
part 'data/rt/rt_subscription.dart';
part 'data/rt/rt_listener.dart';
part 'data/rt/subscriptions_names.dart';
part 'data/rt/rt_event_handlers.dart';

part 'core/invoker.dart';
part 'core/prefs.dart';
part 'core/authKeys.dart';
part 'core/decoder.dart';
part 'exception/exception_message.dart';
part 'exception/backendless_exception.dart';
part 'backendless.dart';
part 'cache/cache.dart';
part 'user/user.dart';
part 'user/user_service.dart';
part 'utils/login_storage.dart';
part 'utils/message_codec.dart';
part 'data/property.dart';
part 'user/user_property.dart';
part 'commerce/status.dart';
part 'custom_service/custom_service.dart';
part 'custom_service/invoke_options.dart';
part 'custom_service/execution_type.dart';
part 'files/file_service.dart';
part 'files/file_info.dart';
part 'messaging/messaging.dart';
part 'messaging/message_status.dart';
part 'messaging/delivery_options.dart';
part 'messaging/publish_message_info.dart';
part 'messaging/publish_options.dart';
part 'messaging/push_broadcast_mask.dart';
part 'messaging/device_registration.dart';
part 'messaging/device_registration_result.dart';
part 'messaging/body_parts.dart';
part 'messaging/email_envelope.dart';
part 'messaging/user_info.dart';
part 'messaging/user_status.dart';
part 'messaging/user_status_response.dart';
part 'messaging/rt/channel.dart';
part 'messaging/rt/rt_messaging.dart';
part 'messaging/rt/rt_method.dart';
part 'messaging/rt/rt_method_request.dart';

part 'transactions/unit_of_work.dart';
part 'transactions/unit_of_work_create.dart';
part 'transactions/unit_of_work_delete.dart';
part 'transactions/unit_of_work_find.dart';
part 'transactions/unit_of_work_update.dart';
part 'transactions/unit_of_work_upsert.dart';
part 'transactions/unit_of_work_executor.dart';
part 'transactions/op_result.dart';
part 'transactions/transaction_helper.dart';
part 'transactions/relation_operation.dart';

part 'transactions/common/operation_type.dart';
part 'transactions/common/operation_result.dart';
part 'transactions/common/unit_of_work_result.dart';
part 'transactions/common/isolation_level_enum.dart';
part 'transactions/common/transaction_operation_error.dart';

part 'transactions/common/payload/delete_bulk_payload.dart';
part 'transactions/common/payload/update_bulk_payload.dart';
part 'transactions/common/payload/selector.dart';
part 'transactions/common/payload/relation.dart';

part 'transactions/common/operations/operation.dart';
part 'transactions/common/operations/crud/operation_create.dart';
part 'transactions/common/operations/crud/operation_create_bulk.dart';
part 'transactions/common/operations/crud/operation_delete.dart';
part 'transactions/common/operations/crud/operation_delete_bulk.dart';
part 'transactions/common/operations/crud/operation_update.dart';
part 'transactions/common/operations/crud/operation_update_bulk.dart';
part 'transactions/common/operations/crud/operation_upsert.dart';
part 'transactions/common/operations/crud/operation_upsert_bulk.dart';
part 'transactions/common/operations/crud/operation_find.dart';

part 'transactions/common/operations/relations/operation_add_relation.dart';
part 'transactions/common/operations/relations/operation_set_relation.dart';
part 'transactions/common/operations/relations/operation_delete_relation.dart';

part 'utils/native_functions_container.dart';
