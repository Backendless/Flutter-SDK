package com.backendless.backendless_sdk.call_handlers;

import com.backendless.Backendless;
import com.backendless.async.callback.AsyncCallback;
import com.backendless.async.callback.UploadCallback;
import com.backendless.exceptions.BackendlessFault;
import com.backendless.files.BackendlessFile;
import com.backendless.files.FileInfo;
import com.backendless.backendless_sdk.utils.FlutterCallback;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FilesCallHandler implements MethodChannel.MethodCallHandler {
    private MethodChannel methodChannel;

    public FilesCallHandler(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.Files.copyFile":
                copyFile(call, result);
                break;
            case "Backendless.Files.exists":
                exists(call, result);
                break;
            case "Backendless.Files.getFileCount":
                getFileCount(call, result);
                break;
            case "Backendless.Files.listing":
                listing(call, result);
                break;
            case "Backendless.Files.moveFile":
                moveFile(call, result);
                break;
            case "Backendless.Files.remove":
                remove(call, result);
                break;
            case "Backendless.Files.removeDirectory":
                removeDirectory(call, result);
                break;
            case "Backendless.Files.renameFile":
                renameFile(call, result);
                break;
            case "Backendless.Files.saveFile":
                saveFile(call, result);
                break;
            case "Backendless.Files.upload":
                upload(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void copyFile(MethodCall call, MethodChannel.Result result) {
        String sourcePathName = call.argument("sourcePathName");
        String targetPath = call.argument("targetPath");

        Backendless.Files.copyFile(sourcePathName, targetPath, new FlutterCallback<String>(result));
    }

    private void exists(MethodCall call, MethodChannel.Result result) {
        String path = call.argument("path");

        Backendless.Files.exists(path, new FlutterCallback<Boolean>(result));
    }

    private void getFileCount(MethodCall call, MethodChannel.Result result) {
        String path = call.argument("path");
        String pattern = call.argument("pattern");
        Boolean recursive = call.argument("recursive");
        Boolean countDirectories = call.argument("countDirectories");

        FlutterCallback<Integer> callback = new FlutterCallback<>(result);

        if (pattern != null) {
            if (recursive != null) {
                if (countDirectories != null) {
                    Backendless.Files.getFileCount(path, pattern, recursive, countDirectories, callback);
                } else {
                    Backendless.Files.getFileCount(path, pattern, recursive, callback);
                }
            } else {
                Backendless.Files.getFileCount(path, pattern, callback);
            }
        } else {
            Backendless.Files.getFileCount(path, callback);
        }
    }

    private void listing(MethodCall call, MethodChannel.Result result) {
        String path = call.argument("path");
        String pattern = call.argument("pattern");
        Boolean recursive = call.argument("recursive");
        Integer pagesize = call.argument("pagesize");
        Integer offset = call.argument("offset");

        FlutterCallback<List<FileInfo>> callback = new FlutterCallback<>(result);

        if (pattern != null && recursive != null) {
            if (pagesize != null && offset != null) {
                Backendless.Files.listing(path, pattern,recursive, pagesize, offset, callback);
            } else {
                Backendless.Files.listing(path, pattern,recursive, callback);
            }
        } else {
            Backendless.Files.listing(path, callback);
        }
    }

    private void moveFile(MethodCall call, MethodChannel.Result result) {
        String sourcePathName = call.argument("sourcePathName");
        String targetPath = call.argument("targetPath");

        Backendless.Files.moveFile(sourcePathName, targetPath, new FlutterCallback<String>(result));
    }

    private void remove(MethodCall call, MethodChannel.Result result) {
        String fileUrl = call.argument("fileUrl");

        Backendless.Files.remove(fileUrl, new FlutterCallback<Integer>(result));
    }

    private void removeDirectory(MethodCall call, MethodChannel.Result result) {
        String directoryPath = call.argument("directoryPath");
        String pattern = call.argument("pattern");
        Boolean recursive = call.argument("recursive");

        FlutterCallback<Integer> callback = new FlutterCallback<>(result);

        if (pattern != null && recursive != null) {
            Backendless.Files.removeDirectory(directoryPath, pattern,recursive, callback);
        } else {
            Backendless.Files.removeDirectory(directoryPath, callback);
        }
    }

    private void renameFile(MethodCall call, MethodChannel.Result result) {
        String oldPathName = call.argument("oldPathName");
        String newName = call.argument("newName");

        Backendless.Files.renameFile(oldPathName, newName, new FlutterCallback<String>(result));
    }

    private void saveFile(MethodCall call, MethodChannel.Result result) {
        String path = call.argument("path");
        String fileName = call.argument("fileName");
        String filePathName = call.argument("filePathName");
        byte[] fileContent = call.argument("fileContent");
        Boolean overwrite = call.argument("overwrite");

        FlutterCallback<String> callback = new FlutterCallback<>(result);

        if (path != null && fileName != null) {
            if (overwrite != null) {
                Backendless.Files.saveFile(path, fileName, fileContent, overwrite, callback);
            } else {
                Backendless.Files.saveFile(path, fileName, fileContent, callback);
            }
        } else if (filePathName != null && overwrite != null) {
            Backendless.Files.saveFile(filePathName, fileContent, overwrite, callback);
        }
    }

    private void upload(MethodCall call, final MethodChannel.Result result) {
        String filePath = call.argument("filePath");
        File file = new File(filePath);
        String path = call.argument("path");
        Boolean overwrite = call.argument("overwrite");

        AsyncCallback<BackendlessFile> callback = new AsyncCallback<BackendlessFile>() {
            @Override
            public void handleResponse(BackendlessFile response) {
                result.success(response.getFileURL());
            }

            @Override
            public void handleFault(BackendlessFault fault) {
                result.error(fault.getCode(), fault.getMessage(), fault.getDetail());
            }
        };

        if (call.hasArgument("handle") && call.argument("handle") != null) {
            int uploadHandle = call.argument("handle");
            UploadCallback uploadCallback = new EventUploadCallback(uploadHandle);
            if (overwrite != null) {
                Backendless.Files.upload(file, path, overwrite, uploadCallback, callback);
            } else {
                Backendless.Files.upload(file, path, uploadCallback, callback);
            }
        } else {
            if (overwrite != null) {
                Backendless.Files.upload(file, path, overwrite, callback);
            } else {
                Backendless.Files.upload(file, path, callback);
            }
        }
    }

    class EventUploadCallback implements UploadCallback {
        private int handle;

        public EventUploadCallback(int handle) {
            this.handle = handle;
        }

        @Override
        public void onProgressUpdate(Integer progress) {
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("handle", handle);
            arguments.put("progress", progress);
            methodChannel.invokeMethod("Backendless.Data.UploadCallback", arguments);
        }
    }
}
