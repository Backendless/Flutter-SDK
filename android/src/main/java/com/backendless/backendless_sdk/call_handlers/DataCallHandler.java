package com.backendless.backendless_sdk.call_handlers;

import android.util.Log;
import android.util.SparseArray;

import com.backendless.Backendless;
import com.backendless.async.callback.AsyncCallback;
import com.backendless.exceptions.BackendlessFault;
import com.backendless.persistence.DataQueryBuilder;
import com.backendless.persistence.LoadRelationsQueryBuilder;
import com.backendless.backendless_sdk.utils.FlutterCallback;
import com.backendless.property.ObjectProperty;
import com.backendless.rt.data.BulkEvent;
import com.backendless.rt.data.EventHandler;
import com.backendless.rt.data.RelationStatus;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class DataCallHandler implements MethodChannel.MethodCallHandler {
    private MethodChannel methodChannel;
    private final SparseArray<DataEventAsyncCallback> subscriptions = new SparseArray<>();
    private int nextHandle = 0;
    private EventHandler eventHandler;

    public DataCallHandler(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }

    @Override
    public void onMethodCall(final MethodCall call, MethodChannel.Result result) {
        final String tableName = call.argument("tableName");
        switch (call.method) {
            case "Backendless.Data.of.addRelation":
                addRelation(tableName, call, result);
                break;
            case "Backendless.Data.of.create":
                create(tableName, call, result);
                break;
            case "Backendless.Data.of.deleteRelation":
                deleteRelation(tableName, call, result);
                break;
            case "Backendless.Data.of.find":
                find(tableName, call, result);
                break;
            case "Backendless.Data.of.findById":
                findById(tableName, call, result);
                break;
            case "Backendless.Data.of.findFirst":
                findFirst(tableName, call, result);
                break;
            case "Backendless.Data.of.findLast":
                findLast(tableName, call, result);
                break;
            case "Backendless.Data.of.getObjectCount":
                getObjectCount(tableName, call, result);
                break;
            case "Backendless.Data.of.loadRelations":
                loadRelations(tableName, call, result);
                break;
            case "Backendless.Data.of.remove":
                remove(tableName, call, result);
                break;
            case "Backendless.Data.of.save":
                save(tableName, call, result);
                break;
            case "Backendless.Data.of.deepSave":
                deepSave(tableName, call, result);
                break;
            case "Backendless.Data.of.setRelation":
                setRelation(tableName, call, result);
                break;
            case "Backendless.Data.of.update":
                update(tableName, call, result);
                break;
            case "Backendless.Data.callStoredProcedure":
                callStoredProcedure(call, result);
                break;
            case "Backendless.Data.describe":
                describe(call, result);
                break;
            case "Backendless.Data.getView":
                getView(call, result);
                break;
            case "Backendless.Data.RT.addListener":
                if(eventHandler == null)
                    eventHandler = Backendless.Data.of(tableName).rt();

                addListener(call, result);
                break;
            case "Backendless.Data.RT.removeListener":
                if(eventHandler == null)
                    eventHandler = Backendless.Data.of(tableName).rt();

                removeListener(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void addRelation(String tableName, MethodCall call, MethodChannel.Result result) {
        String parentObjectId = call.argument("parentObjectId");
        String relationColumnName = call.argument("relationColumnName");
        List<String> childrenObjectIds = call.argument("childrenObjectIds");
        String whereClause = call.argument("whereClause");

        FlutterCallback<Integer> callback = new FlutterCallback<>(result);

        if (childrenObjectIds != null) {
            Backendless.Data.of(tableName).addRelation(parentObjectId, relationColumnName, childrenObjectIds, callback);
        } else if (whereClause != null) {
            Backendless.Data.of(tableName).addRelation(parentObjectId, relationColumnName, whereClause, callback);
        } else {
            callback.handleFault(new BackendlessFault(
                new IllegalArgumentException("Either childrenObjectIds or whereClause should be defined")));
        }
    }

    private void create(String tableName, MethodCall call, MethodChannel.Result result) {
        List<Map> objects = call.argument("objects");
        Backendless.Data.of(tableName).create(objects, new FlutterCallback<List<String>>(result));
    }

    private void deleteRelation(String tableName, MethodCall call, MethodChannel.Result result) {
        String parentObjectId = call.argument("parentObjectId");
        String relationColumnName = call.argument("relationColumnName");
        List<String> childrenObjectIds = call.argument("childrenObjectIds");
        String whereClause = call.argument("whereClause");

        FlutterCallback<Integer> callback = new FlutterCallback<>(result);

        if (childrenObjectIds != null) {
            Backendless.Data.of(tableName).deleteRelation(parentObjectId, relationColumnName, childrenObjectIds, callback);
        } else if (whereClause != null) {
            Backendless.Data.of(tableName).deleteRelation(parentObjectId, relationColumnName, whereClause, callback);
        } else {
            callback.handleFault(new BackendlessFault(
                new IllegalArgumentException("Either childrenObjectIds or whereClause should be defined")));
        }
    }

    private void find(String tableName, MethodCall call, MethodChannel.Result result) {
        DataQueryBuilder queryBuilder = call.argument("queryBuilder");

        FlutterCallback<List<Map>> callback = new FlutterCallback<>(result);

        if (queryBuilder == null) {
            Backendless.Data.of(tableName).find(callback);
        } else {
            Backendless.Data.of(tableName).find(queryBuilder, callback);
        }
    }

    private void findById(String tableName, MethodCall call, MethodChannel.Result result) {
        String id = call.argument("id");
        ArrayList<String> relations = call.argument("relations");
        Integer relationsDepth = call.argument("relationsDepth");
        DataQueryBuilder queryBuilder = call.argument("queryBuilder");

        FlutterCallback<Map> callback = new FlutterCallback<>(result);

        if (relations != null) {
            if (relationsDepth != null) {
                Backendless.Data.of(tableName).findById(id, relations, relationsDepth, callback);
            } else {
                Backendless.Data.of(tableName).findById(id, relations, callback);
            }
        } else if (relationsDepth != null) {
            Backendless.Data.of(tableName).findById(id, relationsDepth, callback);
        } else if (queryBuilder != null) {
            Backendless.Data.of(tableName).findById(id, queryBuilder, callback);
        } else {
            Backendless.Data.of(tableName).findById(id, callback);
        }
    }

    private void findFirst(String tableName, MethodCall call, MethodChannel.Result result) {
        ArrayList<String> relations = call.argument("relations");
        Integer relationsDepth = call.argument("relationsDepth");

        FlutterCallback<Map> callback = new FlutterCallback<>(result);

        if (relations != null) {
            Backendless.Data.of(tableName).findFirst(relations, callback);
        } else if (relationsDepth != null) {
            Backendless.Data.of(tableName).findFirst(relationsDepth, callback);
        } else {
            Backendless.Data.of(tableName).findFirst(callback);
        }
    }

    private void findLast(String tableName, MethodCall call, MethodChannel.Result result) {
        ArrayList<String> relations = call.argument("relations");
        Integer relationsDepth = call.argument("relationsDepth");

        FlutterCallback<Map> callback = new FlutterCallback<>(result);

        if (relations != null) {
            Backendless.Data.of(tableName).findLast(relations, callback);
        } else if (relationsDepth != null) {
            Backendless.Data.of(tableName).findLast(relationsDepth, callback);
        } else {
            Backendless.Data.of(tableName).findLast(callback);
        }
    }

    private void getObjectCount(String tableName, MethodCall call, MethodChannel.Result result) {
        DataQueryBuilder queryBuilder = call.argument("queryBuilder");

        FlutterCallback<Integer> callback = new FlutterCallback<>(result);

        if (queryBuilder == null) {
            Backendless.Data.of(tableName).getObjectCount(callback);
        } else {
            Backendless.Data.of(tableName).getObjectCount(queryBuilder, callback);
        }
    }

    private <R> void loadRelations(String tableName, MethodCall call, MethodChannel.Result result) {
        String objectId = call.argument("objectId");
        LoadRelationsQueryBuilder<R> queryBuilder = call.argument("queryBuilder");
        Backendless.Data.of(tableName).loadRelations(objectId, queryBuilder, new FlutterCallback<List<R>>(result));
    }

    private void remove(String tableName, MethodCall call, MethodChannel.Result result) {
        Map entity = call.argument("entity");
        String whereClause = call.argument("whereClause");

        if (entity != null) {
            Backendless.Data.of(tableName).remove(entity, new FlutterCallback<Long>(result));
        } else if (whereClause != null) {
            Backendless.Data.of(tableName).remove(whereClause, new FlutterCallback<Integer>(result));
        }
    }

    private void save(String tableName, MethodCall call, MethodChannel.Result result) {
        Map entity = call.argument("entity");
        Boolean isUpsert = call.argument("isUpsert");
        Backendless.Data.of(tableName).save(entity, isUpsert, new FlutterCallback<Map>(result));
    }

    private void deepSave(String tableName, MethodCall call, MethodChannel.Result result) {
        Map entity = call.argument("entity");
        Backendless.Data.of(tableName).deepSave(entity, new FlutterCallback<Map>(result));
    }

    private void setRelation(String tableName, MethodCall call, MethodChannel.Result result) {
        String parentObjectId = call.argument("parentObjectId");
        String relationColumnName = call.argument("relationColumnName");
        List<String> childrenObjectIds = call.argument("childrenObjectIds");
        String whereClause = call.argument("whereClause");

        FlutterCallback<Integer> callback = new FlutterCallback<>(result);

        if (childrenObjectIds != null) {
            Backendless.Data.of(tableName).setRelation(parentObjectId, relationColumnName, childrenObjectIds, callback);
        } else if (whereClause != null) {
            Backendless.Data.of(tableName).setRelation(parentObjectId, relationColumnName, whereClause, callback);
        } else {
            callback.handleFault(new BackendlessFault(
                new IllegalArgumentException("Either childrenObjectIds or whereClause should be defined")));
        }
    }

    private void update(String tableName, MethodCall call, MethodChannel.Result result) {
        String whereClause = call.argument("whereClause");
        Map<String, Object> changes = call.argument("changes");
        Backendless.Data.of(tableName).update(whereClause, changes, new FlutterCallback<Integer>(result));
    }

    private void callStoredProcedure(MethodCall call, MethodChannel.Result result) {
        String procedureName = call.argument("procedureName");
        Map<String, Object> arguments = call.argument("arguments");
        Backendless.Data.callStoredProcedure(procedureName, arguments, new FlutterCallback<Map>(result));
    }

    private void describe(MethodCall call, MethodChannel.Result result) {
        String tableName = call.argument("tableName");
        Backendless.Data.describe(tableName, new FlutterCallback<List<ObjectProperty>>(result));
    }

    private void getView(MethodCall call, MethodChannel.Result result) {
        String viewName = call.argument("viewName");
        DataQueryBuilder queryBuilder = call.argument("queryBuilder");
        Backendless.Data.getView(viewName, queryBuilder, new FlutterCallback<Map<String, Object>>(result));
    }

    private void addListener(MethodCall call, MethodChannel.Result result) {
        String event = call.argument("event");
        String tableName = call.argument("tableName");
        String whereClause = call.argument("whereClause");

        int handle = nextHandle++;

        if (event.contains("BULK")) {
            DataEventAsyncCallback<BulkEvent> bulkCallback = new DataEventAsyncCallback<>(handle);
            switch (event) {
                case "RTDataEvent.BULK_CREATED":
                    DataEventAsyncCallback<List> bulkCreateCallback = new DataEventAsyncCallback<>(handle);
                    eventHandler.addBulkCreateListener(bulkCreateCallback);
                    break;
                case "RTDataEvent.BULK_UPDATED":
                    if (whereClause != null)
                        eventHandler.addBulkUpdateListener(whereClause, bulkCallback);
                    else
                        eventHandler.addBulkUpdateListener(bulkCallback);
                    break;
                case "RTDataEvent.BULK_DELETED":
                    if (whereClause != null)
                        eventHandler.addBulkDeleteListener(whereClause, bulkCallback);
                    else
                        eventHandler.addBulkDeleteListener(bulkCallback);
                    break;
                default:
                    result.notImplemented();
                    return;
            }
            subscriptions.put(handle, bulkCallback);
        } else if (event.contains("RELATIONS")) {
            DataEventAsyncCallback<RelationStatus> relationsCallback = new DataEventAsyncCallback<>(handle);
            String relationColumnName = call.argument("relationColumnName");
            List<String> parentObjects = call.argument("parentObjects");
            switch (event) {
                case "RTDataEvent.RELATIONS_SET":
                    if (parentObjects != null)
                        eventHandler.addSetRelationListener(relationColumnName, parentObjects, relationsCallback);
                    else
                        eventHandler.addSetRelationListener(relationColumnName, relationsCallback);
                    break;
                case "RTDataEvent.RELATIONS_ADDED":
                    if (parentObjects != null)
                        eventHandler.addAddRelationListener(relationColumnName, parentObjects, relationsCallback);
                    else
                        eventHandler.addAddRelationListener(relationColumnName, relationsCallback);
                    break;
                case "RTDataEvent.RELATIONS_REMOVED":
                    if (parentObjects != null)
                        eventHandler.addDeleteRelationListener(relationColumnName, parentObjects, relationsCallback);
                    else
                        eventHandler.addDeleteRelationListener(relationColumnName, relationsCallback);
                    break;
                default:
                    result.notImplemented();
                    return;
            }
            subscriptions.put(handle, relationsCallback);
        } else {
            DataEventAsyncCallback<Map> mapCallback = new DataEventAsyncCallback<>(handle);
            switch (event) {
                case "RTDataEvent.CREATED":
                    if (whereClause != null)
                        eventHandler.addCreateListener(whereClause, mapCallback);
                    else
                        eventHandler.addCreateListener(mapCallback);
                    break;
                case "RTDataEvent.UPDATED":
                    if (whereClause != null)
                        eventHandler.addUpdateListener(whereClause, mapCallback);
                    else
                        eventHandler.addUpdateListener(mapCallback);
                    break;
                case "RTDataEvent.DELETED":
                    if (whereClause != null)
                        eventHandler.addDeleteListener(whereClause, mapCallback);
                    else
                        eventHandler.addDeleteListener(mapCallback);
                    break;
                default:
                    result.notImplemented();
                    return;
            }
            subscriptions.put(handle, mapCallback);
        }
        result.success(handle);
    }

    private void removeListener(MethodCall call, MethodChannel.Result result) {
        int handle = call.argument("handle");
        String event = call.argument("event");
        String tableName = call.argument("tableName");
        String whereClause = call.argument("whereClause");

        DataEventAsyncCallback callback = subscriptions.get(handle);
        switch (event) {
            case "RTDataEvent.CREATED":
                if (whereClause != null)
                    eventHandler.removeCreateListener(whereClause, callback);
                else
                    eventHandler.removeCreateListener(callback);
                break;
            case "RTDataEvent.UPDATED":
                if (whereClause != null)
                    eventHandler.removeUpdateListener(whereClause, callback);
                else
                    eventHandler.removeUpdateListener(callback);
                break;
            case "RTDataEvent.DELETED":
                if (whereClause != null)
                    eventHandler.removeDeleteListener(whereClause, callback);
                else
                    eventHandler.removeDeleteListener(callback);
                break;
            case "RTDataEvent.BULK_CREATED":
                eventHandler.removeBulkCreateListener(callback);
                break;
            case "RTDataEvent.BULK_UPDATED":
                if (whereClause != null)
                    eventHandler.removeBulkUpdateListener(whereClause, callback);
                else
                    eventHandler.removeBulkUpdateListener(callback);
                break;
            case "RTDataEvent.BULK_DELETED":
                if (whereClause != null)
                    eventHandler.removeBulkDeleteListener(whereClause, callback);
                else
                    eventHandler.removeBulkDeleteListener(callback);
                break;
            case "RTDataEvent.RELATIONS_SET":
                eventHandler.removeSetRelationListeners();
                break;
            case "RTDataEvent.RELATIONS_ADDED":
                eventHandler.removeAddRelationListeners();
                break;
            case "RTDataEvent.RELATIONS_REMOVED":
                eventHandler.removeDeleteRelationListeners();
                break;
            default:
                result.notImplemented();
                return;
        }
    }

    class DataEventAsyncCallback<T> implements AsyncCallback<T> {
        private int handle;

        public DataEventAsyncCallback(int handle) {
            this.handle = handle;
        }

        @Override
        public void handleResponse(T response) {
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("handle", handle);
            arguments.put("response", response);
            methodChannel.invokeMethod("Backendless.Data.RT.EventResponse", arguments);
        }

        @Override
        public void handleFault(BackendlessFault fault) {
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("handle", handle);
            arguments.put("fault", fault.getMessage());
            methodChannel.invokeMethod("Backendless.Data.RT.EventFault", arguments);
        }
    }

}