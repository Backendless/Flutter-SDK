package com.backendless.backendless_sdk.call_handlers;

import android.util.SparseArray;

import com.backendless.Backendless;
import com.backendless.DeviceRegistration;
import com.backendless.async.callback.AsyncCallback;
import com.backendless.exceptions.BackendlessFault;
import com.backendless.messaging.BodyParts;
import com.backendless.messaging.DeliveryOptions;
import com.backendless.messaging.EmailEnvelope;
import com.backendless.messaging.MessageStatus;
import com.backendless.messaging.PublishMessageInfo;
import com.backendless.messaging.PublishOptions;
import com.backendless.backendless_sdk.utils.FlutterCallback;
import com.backendless.push.DeviceRegistrationResult;
import com.backendless.rt.command.Command;
import com.backendless.rt.messaging.Channel;
import com.backendless.rt.messaging.MessageInfoCallback;
import com.backendless.rt.users.UserStatusResponse;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MessagingCallHandler implements MethodChannel.MethodCallHandler {
    private MethodChannel methodChannel;
    private final SparseArray<Channel> channels = new SparseArray<>();
    private final SparseArray<EventAsyncCallback> joinCallbacks = new SparseArray<>();
    private int nextJoinHandle = 0;
    private final SparseArray<EventAsyncCallback> messageCallbacks = new SparseArray<>();
    private int nextMessageHandle = 0;
    private final SparseArray<EventAsyncCallback> commandCallbacks = new SparseArray<>();
    private int nextCommandHandle = 0;
    private final SparseArray<EventAsyncCallback> userStatusCallbacks = new SparseArray<>();
    private int nextUserStatusHandle = 0;


    public MessagingCallHandler(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.Messaging.cancel":
                cancel(call, result);
                break;
            case "Backendless.Messaging.getDeviceRegistration":
                getDeviceRegistration(result);
                break;
            case "Backendless.Messaging.getMessageStatus":
                getMessageStatus(call, result);
                break;
            case "Backendless.Messaging.publish":
                publish(call, result);
                break;
            case "Backendless.Messaging.pushWithTemplate":
                pushWithTemplate(call, result);
                break;
            case "Backendless.Messaging.registerDevice":
                registerDevice(call, result);
                break;
            case "Backendless.Messaging.sendEmail":
                sendEmail(call, result);
                break;
            case "Backendless.Messaging.sendHTMLEmail":
                sendHTMLEmail(call, result);
                break;
            case "Backendless.Messaging.sendTextEmail":
                sendTextEmail(call, result);
                break;
            case "Backendless.Messaging.unregisterDevice":
                unregisterDevice(call, result);
                break;
            case "Backendless.Messaging.sendEmailFromTemplate":
                sendEmailFromTemplate(call, result);
                break;
            case "Backendless.Messaging.subscribe":
                subscribe(call, result);
                break;
            case "Backendless.Messaging.Channel.join":
                join(call, result);
                break;
            case "Backendless.Messaging.Channel.leave":
                leave(call, result);
                break;
            case "Backendless.Messaging.Channel.isJoined":
                isJoined(call, result);
                break;
            case "Backendless.Messaging.Channel.addJoinListener":
                addJoinListener(call, result);
                break;
            case "Backendless.Messaging.Channel.removeJoinListener":
                removeJoinListener(call);
                break;
            case "Backendless.Messaging.Channel.addMessageListener":
                addMessageListener(call, result);
                break;
            case "Backendless.Messaging.Channel.removeMessageListener":
                removeMessageListener(call);
                break;
            case "Backendless.Messaging.Channel.removeAllMessageListeners":
                removeAllMessageListeners(call);
                break;
            case "Backendless.Messaging.Channel.addCommandListener":
                addCommandListener(call, result);
                break;
            case "Backendless.Messaging.Channel.removeCommandListener":
                removeCommandListener(call);
                break;
            case "Backendless.Messaging.Channel.sendCommand":
                sendCommand(call, result);
                break;
            case "Backendless.Messaging.Channel.addUserStatusListener":
                addUserStatusListener(call, result);
                break;
            case "Backendless.Messaging.Channel.removeUserStatusListener":
                removeUserStatusListener(call);
                break;
            case "Backendless.Messaging.Channel.removeUserStatusListeners":
                removeUserStatusListeners(call);
                break;
            default:
                result.notImplemented();
        }
    }

    private void cancel(MethodCall call, MethodChannel.Result result) {
        String messageId = call.argument("messageId");
        Backendless.Messaging.cancel(messageId, new FlutterCallback<MessageStatus>(result));
    }

    private void getDeviceRegistration(MethodChannel.Result result) {
        Backendless.Messaging.getDeviceRegistration(new FlutterCallback<DeviceRegistration>(result));
    }

    private void getMessageStatus(MethodCall call, MethodChannel.Result result) {
        String messageId = call.argument("messageId");
        Backendless.Messaging.getMessageStatus(messageId, new FlutterCallback<MessageStatus>(result));
    }

    private void publish(MethodCall call, MethodChannel.Result result) {
        Object message = call.argument("message");
        String channelName = call.argument("channelName");
        PublishOptions publishOptions = call.argument("publishOptions");
        DeliveryOptions deliveryOptions = call.argument("deliveryOptions");

        FlutterCallback<MessageStatus> callback = new FlutterCallback<>(result);

        if (channelName != null) {
            if (publishOptions != null) {
                if (deliveryOptions != null) {
                    Backendless.Messaging.publish(channelName, message, publishOptions, deliveryOptions, callback);
                } else {
                    Backendless.Messaging.publish(channelName, message, publishOptions, callback);
                }
            } else if (deliveryOptions != null) {
                Backendless.Messaging.publish(channelName, message, null, deliveryOptions, callback);
            } else {
                Backendless.Messaging.publish(channelName, message, callback);
            }
        } else {
            if (publishOptions != null) {
                if (deliveryOptions != null) {
                    Backendless.Messaging.publish(message, publishOptions, deliveryOptions, callback);
                } else {
                    Backendless.Messaging.publish(message, publishOptions, callback);
                }
            } else if (deliveryOptions != null) {
                Backendless.Messaging.publish(message, null, deliveryOptions, callback);
            } else {
                Backendless.Messaging.publish(message, callback);
            }
        }
    }

    private void pushWithTemplate(MethodCall call, MethodChannel.Result result) {
        String templateName = call.argument("templateName");
        Backendless.Messaging.pushWithTemplate(templateName, new FlutterCallback<MessageStatus>(result));
    }

    private void registerDevice(MethodCall call, MethodChannel.Result result) {
        List<String> channels = call.argument("channels");
        Date expiration = call.argument("expiration");

        FlutterCallback<DeviceRegistrationResult> callback = new FlutterCallback<>(result);

        if (channels != null) {
            if (expiration != null) {
                Backendless.Messaging.registerDevice(channels, expiration, callback);
            } else {
                Backendless.Messaging.registerDevice(channels, callback);
            }
        } else {
            Backendless.Messaging.registerDevice(callback);
        }
    }

    private void sendEmail(MethodCall call, MethodChannel.Result result) {
        String textMessage = call.argument("textMessage");
        String htmlMessage = call.argument("htmlMessage");
        String subject = call.argument("subject");
        List<String> recipients = call.argument("recipients");
        List<String> attachments = call.argument("attachments");

        BodyParts bodyParts = new BodyParts(textMessage, htmlMessage);
        if (attachments == null) {
            attachments = new ArrayList<>();
        }

        Backendless.Messaging.sendEmail(subject, bodyParts, recipients, attachments, new FlutterCallback<MessageStatus>(result));
    }

    private void sendHTMLEmail(MethodCall call, MethodChannel.Result result) {
        String subject = call.argument("subject");
        String messageBody = call.argument("messageBody");
        List<String> recipients = call.argument("recipients");

        Backendless.Messaging.sendHTMLEmail(subject, messageBody, recipients, new FlutterCallback<MessageStatus>(result));
    }

    private void sendTextEmail(MethodCall call, MethodChannel.Result result) {
        String subject = call.argument("subject");
        String messageBody = call.argument("messageBody");
        List<String> recipients = call.argument("recipients");

        Backendless.Messaging.sendTextEmail(subject, messageBody, recipients, new FlutterCallback<MessageStatus>(result));
    }

    private void unregisterDevice(MethodCall call, MethodChannel.Result result) {
        List<String> channels = call.argument("channels");

        FlutterCallback<Integer> callback = new FlutterCallback<>(result);

        if (channels != null) {
            Backendless.Messaging.unregisterDevice(channels, callback);
        } else {
            Backendless.Messaging.unregisterDevice(callback);
        }
    }

    private void sendEmailFromTemplate(MethodCall call, MethodChannel.Result result) {
        String templateName = call.argument("templateName");
        EmailEnvelope envelope = call.argument("envelope");
        Map<String, String> templateValues = call.argument("templateValues");

        FlutterCallback<MessageStatus> callback = new FlutterCallback<>(result);

        if (templateValues != null) {
            Backendless.Messaging.sendEmailFromTemplate(templateName, envelope, templateValues, callback);
        } else {
            Backendless.Messaging.sendEmailFromTemplate(templateName, envelope, callback);
        }
    }

    private void subscribe(MethodCall call, MethodChannel.Result result) {
        String channelName = call.argument("channelName");
        int channelHandle = call.argument("channelHandle");
        Channel channel = Backendless.Messaging.subscribe(channelName);
        channels.put(channelHandle, channel);
        result.success(null);
    }

    private void join(MethodCall call, MethodChannel.Result result) {
        int channelHandle = call.argument("channelHandle");
        getChannel(channelHandle).join();
        result.success(null);
    }

    private void leave(MethodCall call, MethodChannel.Result result) {
        int channelHandle = call.argument("channelHandle");
        getChannel(channelHandle).leave();
        result.success(null);
    }

    private void isJoined(MethodCall call, MethodChannel.Result result) {
        int channelHandle = call.argument("channelHandle");
        result.success(getChannel(channelHandle).isJoined());
    }

    private void addJoinListener(MethodCall call, MethodChannel.Result result) {
        int channelHandle = call.argument("channelHandle");
        int joinHandle = nextJoinHandle++;
        EventAsyncCallback<Void> callback = new EventAsyncCallback<>("Join", joinHandle, false);
        Channel channel = getChannel(channelHandle);
        channel.addJoinListener(callback);
        joinCallbacks.put(joinHandle, callback);
        result.success(joinHandle);
    }

    private void removeJoinListener(MethodCall call) {
        int channelHandle = call.argument("channelHandle");
        int handle = call.argument("handle");
        EventAsyncCallback callback = joinCallbacks.get(handle);
        Channel channel = getChannel(channelHandle);
        channel.removeJoinListener(callback);
        joinCallbacks.remove(handle);
    }

    private void addMessageListener(MethodCall call, MethodChannel.Result result) {
        int channelHandle = call.argument("channelHandle");
        String selector = call.argument("selector");
        String messageType = call.argument("messageType");

        int messageHandle = nextMessageHandle++;

        Channel channel = getChannel(channelHandle);

        switch (messageType) {
            case "String":
                EventAsyncCallback<String> stringCallback = new EventAsyncCallback<>("Message", messageHandle);
                if (selector != null) {
                    channel.addMessageListener(selector, stringCallback);
                } else {
                    channel.addMessageListener(stringCallback);
                }
                messageCallbacks.put(messageHandle, stringCallback);
                break;
            case "PublishMessageInfo":
                EventMessageInfoCallback messageInfoCallback = new EventMessageInfoCallback(messageHandle);
                if (selector != null) {
                    channel.addMessageListener(selector, messageInfoCallback);
                } else {
                    channel.addMessageListener(messageInfoCallback);
                }
                messageCallbacks.put(messageHandle, messageInfoCallback);
                break;
            default:
                throw new IllegalArgumentException("Custom type messages are unsupported for now");
        }
        result.success(messageHandle);
    }

    private void removeMessageListener(MethodCall call) {
        int channelHandle = call.argument("channelHandle");
        int handle = call.argument("handle");
        EventAsyncCallback callback = messageCallbacks.get(handle);
        Channel channel = getChannel(channelHandle);
        channel.removeMessageListener(callback);
        messageCallbacks.remove(handle);
    }

    private void removeAllMessageListeners(MethodCall call) {
        int channelHandle = call.argument("channelHandle");
        Channel channel = getChannel(channelHandle);
        channel.removeAllMessageListeners();
        messageCallbacks.clear();
    }

    private void addCommandListener(MethodCall call, MethodChannel.Result result) {
        int channelHandle = call.argument("channelHandle");
        int commandHandle = nextCommandHandle++;
        EventAsyncCallback<Command<String>> callback = new EventAsyncCallback<>("Command", commandHandle);
        Channel channel = getChannel(channelHandle);
        channel.addCommandListener(callback);
        commandCallbacks.put(commandHandle, callback);
        result.success(commandHandle);
    }

    private void removeCommandListener(MethodCall call) {
        int channelHandle = call.argument("channelHandle");
        int handle = call.argument("handle");
        EventAsyncCallback callback = commandCallbacks.get(handle);
        Channel channel = getChannel(channelHandle);
        channel.removeCommandListener(callback);
        commandCallbacks.remove(handle);
    }

    private void sendCommand(MethodCall call, MethodChannel.Result result) {
        int channelHandle = call.argument("channelHandle");
        String type = call.argument("type");
        Object data = call.argument("data");

        Channel channel = getChannel(channelHandle);
        channel.sendCommand(type, data, new FlutterCallback<Void>(result));
    }

    private void addUserStatusListener(MethodCall call, MethodChannel.Result result) {
        int channelHandle = call.argument("channelHandle");
        int userStatusHandle = nextUserStatusHandle++;
        EventAsyncCallback<UserStatusResponse> callback = new EventAsyncCallback<>("UserStatus", userStatusHandle);
        Channel channel = getChannel(channelHandle);
        channel.addUserStatusListener(callback);
        userStatusCallbacks.put(userStatusHandle, callback);
        result.success(userStatusHandle);
    }

    private void removeUserStatusListener(MethodCall call) {
        int channelHandle = call.argument("channelHandle");
        int handle = call.argument("handle");
        EventAsyncCallback callback = userStatusCallbacks.get(handle);
        Channel channel = getChannel(channelHandle);
        channel.removeUserStatusListener(callback);
        userStatusCallbacks.delete(handle);
    }

    private void removeUserStatusListeners(MethodCall call) {
        int channelHandle = call.argument("channelHandle");
        Channel channel = getChannel(channelHandle);
        channel.removeUserStatusListeners();
        userStatusCallbacks.clear();
    }

    private Channel getChannel(int channelHandle) {
        return channels.get(channelHandle);
    }

    class EventAsyncCallback<T> implements AsyncCallback<T> {
        private final String method;
        private int handle;
        private boolean hasResponse;

        public EventAsyncCallback(String method, int handle) {
            this(method, handle, true);
        }

        public EventAsyncCallback(String method, int handle, boolean hasResponse) {
            this.method = method;
            this.handle = handle;
            this.hasResponse = hasResponse;
        }

        @Override
        public void handleResponse(T response) {
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("handle", handle);
            if (hasResponse) {
                arguments.put("response", response);
            }
            methodChannel.invokeMethod("Backendless.Messaging.Channel." + method + ".EventResponse", arguments);
        }

        @Override
        public void handleFault(BackendlessFault fault) {
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("handle", handle);
            arguments.put("fault", fault.getMessage());
            methodChannel.invokeMethod("Backendless.Messaging.Channel." + method + ".EventFault", arguments);
        }
    }

    class EventMessageInfoCallback extends EventAsyncCallback<PublishMessageInfo> implements MessageInfoCallback {

        public EventMessageInfoCallback(int handle) {
            super("Message", handle, true);
        }
    }
}
