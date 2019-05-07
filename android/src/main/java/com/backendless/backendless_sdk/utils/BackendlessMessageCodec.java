package com.backendless.backendless_sdk.utils;

import com.backendless.BackendlessUser;
import com.backendless.DeviceRegistration;
import com.backendless.commerce.GooglePlayPurchaseStatus;
import com.backendless.commerce.GooglePlaySubscriptionStatus;
import com.backendless.files.FileInfo;
import com.backendless.geo.BackendlessGeoQuery;
import com.backendless.geo.GeoCategory;
import com.backendless.geo.GeoCluster;
import com.backendless.geo.GeoPoint;
import com.backendless.geo.SearchMatchesResult;
import com.backendless.geo.Units;
import com.backendless.messaging.DeliveryOptions;
import com.backendless.messaging.Message;
import com.backendless.messaging.MessageStatus;
import com.backendless.messaging.PublishMessageInfo;
import com.backendless.messaging.PublishOptions;
import com.backendless.messaging.PublishPolicyEnum;
import com.backendless.messaging.PublishStatusEnum;
import com.backendless.persistence.DataQueryBuilder;
import com.backendless.persistence.LoadRelationsQueryBuilder;
import com.backendless.property.DateTypeEnum;
import com.backendless.property.ObjectProperty;
import com.backendless.property.UserProperty;
import com.backendless.push.DeviceRegistrationResult;
import com.backendless.rt.ReconnectAttempt;
import com.backendless.rt.command.Command;
import com.backendless.rt.data.BulkEvent;
import com.backendless.rt.users.UserInfo;
import com.backendless.rt.users.UserStatusResponse;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.StandardMessageCodec;

public final class BackendlessMessageCodec extends StandardMessageCodec {
    public static final BackendlessMessageCodec INSTANCE = new BackendlessMessageCodec();

    private static final byte DATE_TIME = (byte) 128;
    private static final byte GEO_POINT = (byte) 129;
    private static final byte DATA_QUERY_BUILDER = (byte) 130;
    private static final byte LOAD_RELATIONS_QUERY_BUILDER = (byte) 131;
    private static final byte OBJECT_PROPERTY = (byte) 132;
    private static final byte GOOGLE_PLAY_SUBSCRIPTION_STATUS = (byte) 133;
    private static final byte GOOGLE_PLAY_PURCHASE_STATUS = (byte) 134;
    private static final byte FILE_INFO = (byte) 135;
    private static final byte GEO_CATEGORY = (byte) 136;
    private static final byte GEO_QUERY = (byte) 137;
    private static final byte GEO_CLUSTER = (byte) 138;
    private static final byte SEARCH_MATCHES_RESULT = (byte) 139;
    private static final byte MESSAGE_STATUS = (byte) 140;
    private static final byte DEVICE_REGISTRATION = (byte) 141;
    private static final byte MESSAGE = (byte) 142;
    private static final byte PUBLISH_OPTIONS = (byte) 143;
    private static final byte DELIVERY_OPTIONS = (byte) 144;
    private static final byte PUBLISH_MESSAGE_INFO = (byte) 145;
    private static final byte DEVICE_REGISTRATION_RESULT = (byte) 146;
    private static final byte COMMAND = (byte) 147;
    private static final byte USER_INFO = (byte) 148;
    private static final byte USER_STATUS_RESPONSE = (byte) 149;
    private static final byte RECONNECT_ATTEMPT = (byte) 150;
    private static final byte BACKENDLESS_USER = (byte) 151;
    private static final byte USER_PROPERTY = (byte) 152;
    private static final byte BULK_EVENT = (byte) 153;

    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value) {
        if (value instanceof Date) {
            stream.write(DATE_TIME);
            writeLong(stream, ((Date) value).getTime());
        } else if (value instanceof GeoPoint && !(value instanceof GeoCluster)) {
            writeGeoPoint(stream, value);
        } else if (value instanceof ObjectProperty) {
            writeObjectProperty(stream, value);
        } else if (value instanceof GooglePlaySubscriptionStatus) {
            writeGooglePlaySubscriptionStatus(stream, value);
        } else if (value instanceof GooglePlayPurchaseStatus) {
            writeGooglePlayPurchaseStatus(stream, value);
        } else if (value instanceof FileInfo) {
            writeFileInfo(stream, value);
        } else if (value instanceof GeoCategory) {
            writeGeoCategory(stream, value);
        } else if (value instanceof BackendlessGeoQuery) {
            writeBackendlessGeoQuery(stream, value);
        } else if (value instanceof GeoCluster) {
            writeGeoCluster(stream, value);
        } else if (value instanceof SearchMatchesResult) {
            writeSearchMatchesResult(stream, value);
        } else if (value instanceof MessageStatus) {
            writeMessageStatus(stream, value);
        } else if (value instanceof DeviceRegistration) {
            writeDeviceRegistration(stream, value);
        } else if (value instanceof Message) {
            writeMessage(stream, value);
        } else if (value instanceof PublishOptions) {
            writePublishOptions(stream, value);
        } else if (value instanceof DeliveryOptions) {
            writeDeliveryOptions(stream, value);
        } else if (value instanceof PublishMessageInfo) {
            writePublishMessageInfo(stream, value);
        } else if (value instanceof DeviceRegistrationResult) {
            writeDeviceRegistrationResult(stream, value);
        } else if (value instanceof Command) {
            writeCommand(stream, value);
        } else if (value instanceof UserInfo) {
            writeUserInfo(stream, value);
        } else if (value instanceof UserStatusResponse) {
            writeUserStatusResponse(stream, value);
        } else if (value instanceof ReconnectAttempt) {
            writeReconnectAttempt(stream, value);
        } else if (value instanceof BackendlessUser) {
            writeBackendlessUser(stream, value);
        } else if (value instanceof UserProperty) {
            writeUserProperty(stream, value);
        } else if (value instanceof BulkEvent) {
            writeBulkEvent(stream, value);
        } else if (value != null && value.getClass().isArray()) {
            Object[] array = (Object[]) value;
            List list = Arrays.asList(array);
            writeValue(stream, list);
        } else {
            super.writeValue(stream, value);
        }
    }

    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
        switch (type) {
            case DATE_TIME:
                return new Date(buffer.getLong());
            case GEO_POINT:
                return readGeoPoint(buffer);
            case DATA_QUERY_BUILDER:
                return readDataQueryBuilder(buffer);
            case LOAD_RELATIONS_QUERY_BUILDER:
                return readLoadRelationsQueryBuilder(buffer);
            case OBJECT_PROPERTY:
                return readObjectProperty(buffer);
            case GOOGLE_PLAY_SUBSCRIPTION_STATUS:
                return readGooglePlaySubscriptionStatus(buffer);
            case GOOGLE_PLAY_PURCHASE_STATUS:
                return readGooglePlayPurchaseStatus(buffer);
            case FILE_INFO:
                return readFileInfo(buffer);
            case GEO_CATEGORY:
                return readGeoCategory(buffer);
            case GEO_QUERY:
                return readBackendlessGeoQuery(buffer);
            case GEO_CLUSTER:
                return readGeoCluster(buffer);
            case SEARCH_MATCHES_RESULT:
                return readSearchMatchesResult(buffer);
            case MESSAGE_STATUS:
                return readMessageStatus(buffer);
            case DEVICE_REGISTRATION:
                return readDeviceRegistration(buffer);
            case MESSAGE:
                return readMessage(buffer);
            case PUBLISH_OPTIONS:
                return readPublishOptions(buffer);
            case DELIVERY_OPTIONS:
                return readDeliveryOptions(buffer);
            case COMMAND:
                return readCommand(buffer);
            case USER_INFO:
                return readUserInfo(buffer);
            case BACKENDLESS_USER:
                return readBackendlessUser(buffer);
            case USER_PROPERTY:
                return readUserProperty(buffer);
            case BULK_EVENT:
                return readBulkEvent(buffer);
            default:
                return super.readValueOfType(type, buffer);
        }
    }

    private void writeGeoPoint(ByteArrayOutputStream stream, Object value) {
        GeoPoint geoPoint = (GeoPoint) value;
        stream.write(GEO_POINT);
        writeValue(stream, geoPoint.getObjectId());
        writeValue(stream, geoPoint.getLatitude());
        writeValue(stream, geoPoint.getLongitude());
        writeValue(stream, geoPoint.getCategories());
        writeValue(stream, geoPoint.getMetadata());
        writeValue(stream, geoPoint.getDistance());
    }

    private void writeObjectProperty(ByteArrayOutputStream stream, Object value) {
        ObjectProperty objectProperty = (ObjectProperty) value;
        stream.write(OBJECT_PROPERTY);
        writeValue(stream, objectProperty.getRelatedTable());
        writeValue(stream, objectProperty.getDefaultValue());
        writeValue(stream, objectProperty.getName());
        writeValue(stream, objectProperty.isRequired());
        writeValue(stream, objectProperty.getType().ordinal());
    }

    private void writeGooglePlaySubscriptionStatus(ByteArrayOutputStream stream, Object value) {
        GooglePlaySubscriptionStatus subscriptionStatus = (GooglePlaySubscriptionStatus) value;
        stream.write(GOOGLE_PLAY_SUBSCRIPTION_STATUS);
        writeValue(stream, subscriptionStatus.isAutoRenewing());
        writeValue(stream, subscriptionStatus.getStartTimeMillis());
        writeValue(stream, subscriptionStatus.getKind());
        writeValue(stream, subscriptionStatus.getExpiryTimeMillis());
    }

    private void writeGooglePlayPurchaseStatus(ByteArrayOutputStream stream, Object value) {
        GooglePlayPurchaseStatus purchaseStatus = (GooglePlayPurchaseStatus) value;
        stream.write(GOOGLE_PLAY_PURCHASE_STATUS);
        writeValue(stream, purchaseStatus.getKind());
        writeValue(stream, purchaseStatus.getPurchaseTimeMillis());
        writeValue(stream, purchaseStatus.getPurchaseState());
        writeValue(stream, purchaseStatus.getConsumptionState());
        writeValue(stream, purchaseStatus.getDeveloperPayload());
    }

    private void writeFileInfo(ByteArrayOutputStream stream, Object value) {
        FileInfo fileInfo = (FileInfo) value;
        stream.write(FILE_INFO);
        writeValue(stream, fileInfo.getName());
        writeValue(stream, fileInfo.getCreatedOn());
        writeValue(stream, fileInfo.getPublicUrl());
        writeValue(stream, fileInfo.getURL());
        writeValue(stream, fileInfo.getSize());
    }

    private void writeGeoCategory(ByteArrayOutputStream stream, Object value) {
        GeoCategory geoCategory = (GeoCategory) value;
        stream.write(GEO_CATEGORY);
        writeValue(stream, geoCategory.getId());
        writeValue(stream, geoCategory.getName());
        writeValue(stream, geoCategory.getSize());
    }

    private void writeBackendlessGeoQuery(ByteArrayOutputStream stream, Object value) {
        BackendlessGeoQuery geoQuery = (BackendlessGeoQuery) value;
        stream.write(GEO_QUERY);
        writeValue(stream, geoQuery.getLatitude());
        writeValue(stream, geoQuery.getLongitude());
        writeValue(stream, geoQuery.getRadius());
        writeValue(stream, geoQuery.getCategories());
        writeValue(stream, geoQuery.getMetadata());
        writeValue(stream, geoQuery.getRelativeFindMetadata());
        writeValue(stream, geoQuery.getRelativeFindPercentThreshold());
        writeValue(stream, geoQuery.getWhereClause());
        writeValue(stream, geoQuery.getSortBy());
        writeValue(stream, geoQuery.getDpp());
        writeValue(stream, geoQuery.getClusterGridSize());
        writeValue(stream, geoQuery.getPageSize());
        writeValue(stream, geoQuery.getOffset());
        writeValue(stream, geoQuery.getUnits().ordinal());
        writeValue(stream, geoQuery.isIncludeMeta());
        writeValue(stream, geoQuery.getSearchRectangle());
    }

    private void writeGeoCluster(ByteArrayOutputStream stream, Object value) {
        GeoCluster geoCluster = (GeoCluster) value;
        stream.write(GEO_CLUSTER);
        writeValue(stream, geoCluster.getObjectId());
        writeValue(stream, geoCluster.getLatitude());
        writeValue(stream, geoCluster.getLongitude());
        writeValue(stream, geoCluster.getCategories());
        writeValue(stream, geoCluster.getMetadata());
        writeValue(stream, geoCluster.getDistance());
        writeValue(stream, geoCluster.getTotalPoints());
        writeValue(stream, geoCluster.getGeoQuery());
    }

    private void writeSearchMatchesResult(ByteArrayOutputStream stream, Object value) {
        SearchMatchesResult searchMatchesResult = (SearchMatchesResult) value;
        stream.write(SEARCH_MATCHES_RESULT);
        writeValue(stream, searchMatchesResult.getMatches());
        writeValue(stream, searchMatchesResult.getGeoPoint());
    }

    private void writeMessageStatus(ByteArrayOutputStream stream, Object value) {
        MessageStatus messageStatus = (MessageStatus) value;
        stream.write(MESSAGE_STATUS);
        writeValue(stream, messageStatus.getMessageId());
        writeValue(stream, messageStatus.getErrorMessage());
        writeValue(stream, messageStatus.getStatus().ordinal());
    }

    private void writeDeviceRegistration(ByteArrayOutputStream stream, Object value) {
        DeviceRegistration deviceRegistration = (DeviceRegistration) value;
        stream.write(DEVICE_REGISTRATION);
        writeValue(stream, deviceRegistration.getId());
        writeValue(stream, deviceRegistration.getDeviceToken());
        writeValue(stream, deviceRegistration.getDeviceId());
        writeValue(stream, deviceRegistration.getOs());
        writeValue(stream, deviceRegistration.getOsVersion());
        writeValue(stream, deviceRegistration.getExpiration());
        writeValue(stream, deviceRegistration.getChannels());
    }

    private void writeMessage(ByteArrayOutputStream stream, Object value) {
        Message message = (Message) value;
        stream.write(MESSAGE);
        writeValue(stream, message.getMessageId());
        writeValue(stream, message.getHeaders());
        writeValue(stream, message.getData());
        writeValue(stream, message.getPublisherId());
        writeValue(stream, message.getTimestamp());
    }

    private void writePublishOptions(ByteArrayOutputStream stream, Object value) {
        PublishOptions publishOptions = (PublishOptions) value;
        stream.write(PUBLISH_OPTIONS);
        writeValue(stream, publishOptions.getPublisherId());
        writeValue(stream, publishOptions.getHeaders());
        writeValue(stream, publishOptions.getSubtopic());
    }

    private void writeDeliveryOptions(ByteArrayOutputStream stream, Object value) {
        DeliveryOptions deliveryOptions = (DeliveryOptions) value;
        stream.write(DELIVERY_OPTIONS);
        writeValue(stream, deliveryOptions.getPushBroadcast());
        writeValue(stream, deliveryOptions.getPushSinglecast());
        writeValue(stream, deliveryOptions.getSegmentQuery());
        writeValue(stream, deliveryOptions.getPublishPolicy().ordinal());
        writeValue(stream, deliveryOptions.getPublishAt());
        writeValue(stream, deliveryOptions.getRepeatEvery());
        writeValue(stream, deliveryOptions.getRepeatExpiresAt());
    }

    private void writePublishMessageInfo(ByteArrayOutputStream stream, Object value) {
        PublishMessageInfo publishMessageInfo = (PublishMessageInfo) value;
        stream.write(PUBLISH_MESSAGE_INFO);
        writeValue(stream, publishMessageInfo.getMessageId());
        writeValue(stream, publishMessageInfo.getTimestamp());
        writeValue(stream, publishMessageInfo.getMessage());
        writeValue(stream, publishMessageInfo.getPublisherId());
        writeValue(stream, publishMessageInfo.getSubtopic());
        writeValue(stream, publishMessageInfo.getPushSinglecast());
        writeValue(stream, publishMessageInfo.getPushBroadcast());
        writeValue(stream, publishMessageInfo.getPublishPolicy());
        writeValue(stream, publishMessageInfo.getQuery());
        writeValue(stream, publishMessageInfo.getPublishAt());
        writeValue(stream, publishMessageInfo.getRepeatEvery());
        writeValue(stream, publishMessageInfo.getRepeatExpiresAt());
        writeValue(stream, publishMessageInfo.getHeaders());
    }

    private void writeDeviceRegistrationResult(ByteArrayOutputStream stream, Object value) {
        DeviceRegistrationResult deviceRegistrationResult = (DeviceRegistrationResult) value;
        stream.write(DEVICE_REGISTRATION_RESULT);
        writeValue(stream, deviceRegistrationResult.getDeviceToken());
        writeValue(stream, deviceRegistrationResult.getChannelRegistrations());
    }

    private void writeCommand(ByteArrayOutputStream stream, Object value) {
        Command command = (Command) value;
        stream.write(COMMAND);
        String dataType;
        if (command.getData() instanceof  String)
            dataType = "String";
        else if (command.getData() instanceof Map)
            dataType = "Map";
        else
            throw new IllegalArgumentException();
        writeValue(stream, dataType);
        writeValue(stream, command.getType());
        writeValue(stream, command.getData());
        writeValue(stream, command.getUserInfo());
    }

    private void writeUserInfo(ByteArrayOutputStream stream, Object value) {
        UserInfo userInfo = (UserInfo) value;
        stream.write(USER_INFO);
        writeValue(stream, userInfo.getConnectionId());
        writeValue(stream, userInfo.getUserId());
    }

    private void writeUserStatusResponse(ByteArrayOutputStream stream, Object value) {
        UserStatusResponse userStatusResponse = (UserStatusResponse) value;
        stream.write(USER_STATUS_RESPONSE);
        writeValue(stream, userStatusResponse.getStatus().ordinal());
        writeValue(stream, userStatusResponse.getData());
    }

    private void writeReconnectAttempt(ByteArrayOutputStream stream, Object value) {
        ReconnectAttempt reconnectAttempt = (ReconnectAttempt) value;
        stream.write(RECONNECT_ATTEMPT);
        writeValue(stream, reconnectAttempt.getTimeout());
        writeValue(stream, reconnectAttempt.getAttempt());
    }

    private void writeBackendlessUser(ByteArrayOutputStream stream, Object value) {
        BackendlessUser backendlessUser = (BackendlessUser) value;
        stream.write(BACKENDLESS_USER);
        writeValue(stream, backendlessUser.getProperties());
    }

    private void writeUserProperty(ByteArrayOutputStream stream, Object value) {
        UserProperty userProperty = (UserProperty) value;
        stream.write(USER_PROPERTY);
        writeValue(stream, userProperty.getName());
        writeValue(stream, userProperty.isRequired());
        writeValue(stream, userProperty.getType().ordinal());
        writeValue(stream, userProperty.isIdentity());
    }

    private void writeBulkEvent(ByteArrayOutputStream stream, Object value) {
        BulkEvent bulkEvent = (BulkEvent) value;
        stream.write(BULK_EVENT);
        writeValue(stream, bulkEvent.getWhereClause());
        writeValue(stream, bulkEvent.getCount());
    }



    private GeoPoint readGeoPoint(ByteBuffer buffer) {
        GeoPoint geoPoint = new GeoPoint();
        geoPoint.setObjectId((String) readValue(buffer));
        geoPoint.setLatitude((Double) readValue(buffer));
        geoPoint.setLongitude((Double) readValue(buffer));
        geoPoint.setCategories((Collection<String>) readValue(buffer));
        geoPoint.setMetadata((Map<String, Object>) readValue(buffer));
        geoPoint.setDistance((Double) readValue(buffer));
        return geoPoint;
    }

    private DataQueryBuilder readDataQueryBuilder(ByteBuffer buffer) {
        return DataQueryBuilder.create()
            .setProperties((List<String>) readValue(buffer))
            .setWhereClause((String) readValue(buffer))
            .setGroupBy(((List<String>) readValue(buffer)).toArray(new String[0]))
            .setHavingClause((String) readValue(buffer))
            .setPageSize(buffer.getInt())
            .setOffset(buffer.getInt())
            .setSortBy((List<String>) readValue(buffer))
            .setRelated((List<String>) readValue(buffer))
            .setRelationsDepth(buffer.getInt());
    }

    private LoadRelationsQueryBuilder readLoadRelationsQueryBuilder(ByteBuffer buffer) {
        return LoadRelationsQueryBuilder.ofMap()
            .setRelationName((String) readValue(buffer))
            .setPageSize(buffer.getInt())
            .setOffset(buffer.getInt());
    }

    private ObjectProperty readObjectProperty(ByteBuffer buffer) {
        ObjectProperty objectProperty = new ObjectProperty();
        objectProperty.setRelatedTable((String) readValue(buffer));
        objectProperty.setDefaultValue(readValue(buffer));
        objectProperty.setName((String) readValue(buffer));
        objectProperty.setRequired((boolean) readValue(buffer));
        objectProperty.setType(DateTypeEnum.values()[(int) readValue(buffer)]);
        return objectProperty;
    }

    private GooglePlaySubscriptionStatus readGooglePlaySubscriptionStatus(ByteBuffer buffer) {
        GooglePlaySubscriptionStatus subscriptionStatus = new GooglePlaySubscriptionStatus();
        subscriptionStatus.setAutoRenewing((boolean) readValue(buffer));
        subscriptionStatus.setStartTimeMillis((long) readValue(buffer));
        subscriptionStatus.setKind((String) readValue(buffer));
        subscriptionStatus.setExpiryTimeMillis((long) readValue(buffer));
        return subscriptionStatus;
    }

    private GooglePlayPurchaseStatus readGooglePlayPurchaseStatus(ByteBuffer buffer) {
        GooglePlayPurchaseStatus purchaseStatus = new GooglePlayPurchaseStatus();
        ;
        purchaseStatus.setKind((String) readValue(buffer));
        purchaseStatus.setPurchaseTimeMillis((long) readValue(buffer));
        purchaseStatus.setPurchaseState((int) readValue(buffer));
        purchaseStatus.setConsumptionState((int) readValue(buffer));
        purchaseStatus.setDeveloperPayload((String) readValue(buffer));
        return purchaseStatus;
    }

    private FileInfo readFileInfo(ByteBuffer buffer) {
        FileInfo fileInfo = new FileInfo();
        fileInfo.setName((String) readValue(buffer));
        fileInfo.setCreatedOn((long) readValue(buffer));
        fileInfo.setPublicUrl((String) readValue(buffer));
        fileInfo.setURL((String) readValue(buffer));
        fileInfo.setSize((Integer) readValue(buffer));
        return fileInfo;
    }

    private GeoCategory readGeoCategory(ByteBuffer buffer) {
        GeoCategory geoCategory = new GeoCategory();
        geoCategory.setObjectId((String) readValue(buffer));
        geoCategory.setName((String) readValue(buffer));
        geoCategory.setSize((int) readValue(buffer));
        return geoCategory;
    }

    private BackendlessGeoQuery readBackendlessGeoQuery(ByteBuffer buffer) {
        BackendlessGeoQuery geoQuery = new BackendlessGeoQuery();
        geoQuery.setLatitude((Double) readValue(buffer));
        geoQuery.setLongitude((Double) readValue(buffer));
        geoQuery.setRadius((Double) readValue(buffer));
        geoQuery.setCategories((Collection<String>) readValue(buffer));
        geoQuery.setMetadata((Map<String, Object>) readValue(buffer));
        geoQuery.setRelativeFindMetadata((Map<String, String>) readValue(buffer));
        geoQuery.setRelativeFindPercentThreshold((Double) readValue(buffer));
        geoQuery.setWhereClause((String) readValue(buffer));
        geoQuery.setSortBy((Collection<String>) readValue(buffer));
        geoQuery.setDpp((Double) readValue(buffer));
        geoQuery.setClusterGridSize((Integer) readValue(buffer));
        geoQuery.setPageSize((Integer) readValue(buffer));
        geoQuery.setOffset((Integer) readValue(buffer));
        geoQuery.setUnits(Units.values()[(int) readValue(buffer)]);
        geoQuery.setIncludeMeta((Boolean) readValue(buffer));
        geoQuery.setSearchRectangle((double[]) readValue(buffer));
        return geoQuery;
    }

    private GeoPoint readGeoCluster(ByteBuffer buffer) {
        GeoCluster geoCluster = new GeoCluster();
        geoCluster.setObjectId((String) readValue(buffer));
        geoCluster.setLatitude((Double) readValue(buffer));
        geoCluster.setLongitude((Double) readValue(buffer));
        geoCluster.setCategories((Collection<String>) readValue(buffer));
        geoCluster.setMetadata((Map<String, Object>) readValue(buffer));
        geoCluster.setDistance((Double) readValue(buffer));
        geoCluster.setTotalPoints((Integer) readValue(buffer));
        geoCluster.setGeoQuery((BackendlessGeoQuery) readValue(buffer));
        return geoCluster;
    }

    private SearchMatchesResult readSearchMatchesResult(ByteBuffer buffer) {
        SearchMatchesResult searchMatchesResult = new SearchMatchesResult();
        searchMatchesResult.setMatches((Double) readValue(buffer));
        searchMatchesResult.setGeoPoint((GeoPoint) readValue(buffer));
        return searchMatchesResult;
    }

    private MessageStatus readMessageStatus(ByteBuffer buffer) {
        MessageStatus messageStatus = new MessageStatus();
        messageStatus.setMessageId((String) readValue(buffer));
        messageStatus.setErrorMessage((String) readValue(buffer));
        messageStatus.setStatus(PublishStatusEnum.values()[(int) readValue(buffer)]);
        return messageStatus;
    }

    private DeviceRegistration readDeviceRegistration(ByteBuffer buffer) {
        DeviceRegistration deviceRegistration = new DeviceRegistration();
        deviceRegistration.setId((String) readValue(buffer));
        deviceRegistration.setDeviceToken((String) readValue(buffer));
        deviceRegistration.setDeviceId((String) readValue(buffer));
        deviceRegistration.setOs((String) readValue(buffer));
        deviceRegistration.setOsVersion((String) readValue(buffer));
        deviceRegistration.setExpiration((Date) readValue(buffer));
        deviceRegistration.setChannels((List<String>) readValue(buffer));
        return deviceRegistration;
    }

    private Message readMessage(ByteBuffer buffer) {
        Message message = new Message();
        message.setMessageId((String) readValue(buffer));
        message.setHeaders((Map<String, String>) readValue(buffer));
        message.setData(readValue(buffer));
        message.setPublisherId((String) readValue(buffer));
        message.setTimestamp((Long) readValue(buffer));
        return message;
    }

    private PublishOptions readPublishOptions(ByteBuffer buffer) {
        PublishOptions publishOptions = new PublishOptions();
        publishOptions.setPublisherId((String) readValue(buffer));
        publishOptions.setHeaders((Map<String, String>) readValue(buffer));
        publishOptions.setSubtopic((String) readValue(buffer));
        return publishOptions;
    }

    private DeliveryOptions readDeliveryOptions(ByteBuffer buffer) {
        DeliveryOptions deliveryOptions = new DeliveryOptions();
        deliveryOptions.setPushBroadcast((Integer) readValue(buffer));
        deliveryOptions.setPushSinglecast((List<String>) readValue(buffer));
        deliveryOptions.setSegmentQuery((String) readValue(buffer));
        deliveryOptions.setPublishPolicy(PublishPolicyEnum.values()[(int) readValue(buffer)]);
        deliveryOptions.setPublishAt((Date) readValue(buffer));
        deliveryOptions.setRepeatEvery((Long) readValue(buffer));
        deliveryOptions.setRepeatExpiresAt((Date) readValue(buffer));
        return deliveryOptions;
    }

    private Command readCommand(ByteBuffer buffer) {
        String dataType = (String) readValue(buffer);
        Command command;
        if (dataType.equals("String"))
            command = Command.string();
        else if (dataType.equals("map"))
            command = Command.map();
        else throw new IllegalArgumentException();
        command.setType((String) readValue(buffer));
        command.setData(readValue(buffer));
        command.setUserInfo((UserInfo) readValue(buffer));
        return command;
    }

    private UserInfo readUserInfo(ByteBuffer buffer) {
        UserInfo userInfo = new UserInfo();
        userInfo.setConnectionId((String) readValue(buffer));
        userInfo.setUserId((String) readValue(buffer));
        return userInfo;
    }

    private BackendlessUser readBackendlessUser(ByteBuffer buffer) {
        BackendlessUser backendlessUser = new BackendlessUser();
        backendlessUser.setProperties((Map<String, Object>) readValue(buffer));
        return backendlessUser;
    }

    private UserProperty readUserProperty(ByteBuffer buffer) {
        UserProperty userProperty = new UserProperty();
        userProperty.setName((String) readValue(buffer));
        userProperty.setRequired((boolean) readValue(buffer));
        userProperty.setType(DateTypeEnum.values()[(int) readValue(buffer)]);
        userProperty.setIdentity((Boolean) readValue(buffer));
        return userProperty;
    }

    private BulkEvent readBulkEvent(ByteBuffer buffer) {
        BulkEvent bulkEvent = new BulkEvent();
        bulkEvent.setWhereClause((String) readValue(buffer));
        bulkEvent.setCount((Integer) readValue(buffer));
        return bulkEvent;
    }
}
