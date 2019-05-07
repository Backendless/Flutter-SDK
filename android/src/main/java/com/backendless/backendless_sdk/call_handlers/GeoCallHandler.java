package com.backendless.backendless_sdk.call_handlers;

import android.util.SparseArray;

import com.backendless.Backendless;
import com.backendless.geo.BackendlessGeoQuery;
import com.backendless.geo.GeoCategory;
import com.backendless.geo.GeoCluster;
import com.backendless.geo.GeoPoint;
import com.backendless.geo.SearchMatchesResult;
import com.backendless.geo.geofence.IGeofenceCallback;
import com.backendless.backendless_sdk.utils.FlutterCallback;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class GeoCallHandler implements MethodChannel.MethodCallHandler {
    private MethodChannel methodChannel;
    private final SparseArray<GeoFenceEventCallback> geofenceCallbacks = new SparseArray<>();

    public GeoCallHandler(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.Geo.addCategory":
                addCategory(call, result);
                break;
            case "Backendless.Geo.deleteCategory":
                deleteCategory(call, result);
                break;
            case "Backendless.Geo.getCategories":
                getCategories(result);
                break;
            case "Backendless.Geo.getGeopointCount":
                getGeopointCount(call, result);
                break;
            case "Backendless.Geo.getPoints":
                getPoints(call, result);
                break;
            case "Backendless.Geo.loadMetadata":
                loadMetadata(call, result);
                break;
            case "Backendless.Geo.relativeFind":
                relativeFind(call, result);
                break;
            case "Backendless.Geo.removePoint":
                removePoint(call);
                break;
            case "Backendless.Geo.runOnEnterAction":
                runOnEnterAction(call);
                break;
            case "Backendless.Geo.runOnExitAction":
                runOnExitAction(call);
                break;
            case "Backendless.Geo.runOnStayAction":
                runOnStayAction(call);
                break;
            case "Backendless.Geo.savePoint":
                savePoint(call, result);
                break;
            case "Backendless.Geo.setLocationTrackerParameters":
                setLocationTrackerParameters(call);
                break;
            case "Backendless.Geo.startClientGeofenceMonitoring":
                startClientGeofenceMonitoring(call, result);
                break;
            case "Backendless.Geo.startServerGeofenceMonitoring":
                startServerGeofenceMonitoring(call, result);
                break;
            case "Backendless.Geo.stopGeofenceMonitoring":
                stopGeofenceMonitoring(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void addCategory(MethodCall call, MethodChannel.Result result) {
        String categoryName = call.argument("categoryName");
        Backendless.Geo.addCategory(categoryName, new FlutterCallback<GeoCategory>(result));
    }

    private void deleteCategory(MethodCall call, MethodChannel.Result result) {
        String categoryName = call.argument("categoryName");
        Backendless.Geo.deleteCategory(categoryName, new FlutterCallback<Boolean>(result));
    }

    private void getCategories(MethodChannel.Result result) {
        Backendless.Geo.getCategories(new FlutterCallback<List<GeoCategory>>(result));
    }

    private void getGeopointCount(MethodCall call, MethodChannel.Result result) {
        BackendlessGeoQuery query = call.argument("query");
        String geoFenceName = call.argument("geoFenceName");

        FlutterCallback<Integer> callback = new FlutterCallback<>(result);

        if (geoFenceName != null) {
            Backendless.Geo.getGeopointCount(geoFenceName, query, callback);
        } else {
            Backendless.Geo.getGeopointCount(query, callback);
        }
    }

    private void getPoints(MethodCall call, MethodChannel.Result result) {
        BackendlessGeoQuery query = call.argument("query");
        String geofenceName = call.argument("geofenceName");
        GeoCluster geoCluster = call.argument("geoCluster");

        FlutterCallback<List<GeoPoint>> callback = new FlutterCallback<>(result);

        if (geoCluster != null) {
            Backendless.Geo.getPoints(geoCluster, callback);
        } else if (geofenceName != null) {
            if (query != null) {
                Backendless.Geo.getPoints(geofenceName, query, callback);
            } else {
                Backendless.Geo.getPoints(geofenceName, callback);
            }
        } else if (query != null) {
            Backendless.Geo.getPoints(query, callback);
        }
    }

    private void loadMetadata(MethodCall call, MethodChannel.Result result) {
        GeoPoint geoPoint = call.argument("geoPoint");
        Backendless.Geo.loadMetadata(geoPoint, new FlutterCallback<GeoPoint>(result));
    }

    private void relativeFind(MethodCall call, MethodChannel.Result result) {
        BackendlessGeoQuery geoQuery = call.argument("geoQuery");
        Backendless.Geo.relativeFind(geoQuery, new FlutterCallback<List<SearchMatchesResult>>(result));
    }

    private void removePoint(MethodCall call) {
        GeoPoint geoPoint = call.argument("geoPoint");
        Backendless.Geo.removePoint(geoPoint, new FlutterCallback<Void>(null));
    }

    private void runOnEnterAction(MethodCall call) {
        String geoFenceName = call.argument("geoFenceName");
        GeoPoint geoPoint = call.argument("geoPoint");

        if (geoPoint != null) {
            Backendless.Geo.runOnEnterAction(geoFenceName, geoPoint, new FlutterCallback<Void>(null));
        } else {
            Backendless.Geo.runOnEnterAction(geoFenceName, new FlutterCallback<Integer>(null));
        }
    }

    private void runOnExitAction(MethodCall call) {
        String geoFenceName = call.argument("geoFenceName");
        GeoPoint geoPoint = call.argument("geoPoint");

        if (geoPoint != null) {
            Backendless.Geo.runOnExitAction(geoFenceName, geoPoint, new FlutterCallback<Void>(null));
        } else {
            Backendless.Geo.runOnExitAction(geoFenceName, new FlutterCallback<Integer>(null));
        }
    }

    private void runOnStayAction(MethodCall call) {
        String geoFenceName = call.argument("geoFenceName");
        GeoPoint geoPoint = call.argument("geoPoint");

        if (geoPoint != null) {
            Backendless.Geo.runOnStayAction(geoFenceName, geoPoint, new FlutterCallback<Void>(null));
        } else {
            Backendless.Geo.runOnStayAction(geoFenceName, new FlutterCallback<Integer>(null));
        }
    }

    private void savePoint(MethodCall call, MethodChannel.Result result) {
        FlutterCallback<GeoPoint> callback = new FlutterCallback<>(result);

        GeoPoint geoPoint = call.argument("geoPoint");
        if (geoPoint != null) {
            Backendless.Geo.savePoint(geoPoint, callback);
        } else {
            Double latitude = call.argument("latitude");
            Double longitude = call.argument("longitude");
            List<String> categories = call.argument("categories");
            Map<String, Object> metadata = call.argument("metadata");

            if (categories != null) {
                Backendless.Geo.savePoint(latitude, longitude, categories, metadata, callback);
            } else {
                Backendless.Geo.savePoint(latitude, longitude, metadata, callback);
            }
        }
    }

    private void setLocationTrackerParameters(MethodCall call) {
        Integer minTime = call.argument("minTime");
        Integer minDistance = call.argument("minDistance");
        Integer acceptedDistanceAfterReboot = call.argument("acceptedDistanceAfterReboot");

        Backendless.Geo.setLocationTrackerParameters(minTime, minDistance, acceptedDistanceAfterReboot);
    }

    private void startClientGeofenceMonitoring(MethodCall call, MethodChannel.Result result) {
        String geofenceName = call.argument("geofenceName");
        int handle = call.argument("handle");
        GeoFenceEventCallback callback = new GeoFenceEventCallback(handle);
        geofenceCallbacks.put(handle, callback);
        if (geofenceName != null) {
            Backendless.Geo.startGeofenceMonitoring(geofenceName, callback, new FlutterCallback<Void>(result));
        } else {
            Backendless.Geo.startGeofenceMonitoring(callback, new FlutterCallback<Void>(result));
        }
    }

    private void startServerGeofenceMonitoring(MethodCall call, MethodChannel.Result result) {
        GeoPoint geoPoint = call.argument("geoPoint");
        String geofenceName = call.argument("geofenceName");

        if (geofenceName != null) {
            Backendless.Geo.startGeofenceMonitoring(geofenceName, geoPoint, new FlutterCallback<Void>(result));
        } else {
            Backendless.Geo.startGeofenceMonitoring(geoPoint, new FlutterCallback<Void>(result));
        }
    }

    private void stopGeofenceMonitoring(MethodCall call, MethodChannel.Result result) {
        String geofenceName = call.argument("geofenceName");

        if (geofenceName != null) {
            Backendless.Geo.stopGeofenceMonitoring(geofenceName);
        } else {
            Backendless.Geo.stopGeofenceMonitoring();
        }
        result.success(null);
    }

    class GeoFenceEventCallback implements IGeofenceCallback {
        private int handle;

        public GeoFenceEventCallback(int handle) {
            this.handle = handle;
        }

        @Override
        public void geoPointEntered(String geofenceName, String geofenceId, double latitude, double longitude) {
            invokeMethod(geofenceName, geofenceId, latitude, longitude, "geoPointEntered");
        }

        @Override
        public void geoPointStayed(String geofenceName, String geofenceId, double latitude, double longitude) {
            invokeMethod(geofenceName, geofenceId, latitude, longitude, "geoPointStayed");
        }

        @Override
        public void geoPointExited(String geofenceName, String geofenceId, double latitude, double longitude) {
            invokeMethod(geofenceName, geofenceId, latitude, longitude, "geoPointExited");
        }

        private void invokeMethod(String geofenceName, String geofenceId, double latitude, double longitude, String method) {
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("handle", handle);
            arguments.put("geofenceName", geofenceName);
            arguments.put("geofenceId", geofenceId);
            arguments.put("latitude", latitude);
            arguments.put("longitude", longitude);
            arguments.put("method", method);
            methodChannel.invokeMethod("Backendless.Geo.GeofenceMonitoring", arguments);
        }
    }
}
