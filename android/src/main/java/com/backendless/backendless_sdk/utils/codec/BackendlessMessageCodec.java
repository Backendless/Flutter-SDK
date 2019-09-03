package com.backendless.backendless_sdk.utils.codec;

import com.backendless.BackendlessUser;
import com.backendless.DeviceRegistration;
import com.backendless.backendless_sdk.utils.codec.mixins.CommandMixin;
import com.backendless.backendless_sdk.utils.codec.mixins.DataQueryBuilderMixin;
import com.backendless.backendless_sdk.utils.codec.mixins.GeoPointMixin;
import com.backendless.backendless_sdk.utils.codec.mixins.LoadRelationsQueryBuilderMixin;
import com.backendless.backendless_sdk.utils.codec.mixins.ObjectPropertyMixin;
import com.backendless.backendless_sdk.utils.codec.mixins.ReconnectAttemptMixin;
import com.backendless.commerce.GooglePlayPurchaseStatus;
import com.backendless.commerce.GooglePlaySubscriptionStatus;
import com.backendless.files.FileInfo;
import com.backendless.geo.BackendlessGeoQuery;
import com.backendless.geo.GeoCategory;
import com.backendless.geo.GeoCluster;
import com.backendless.geo.GeoPoint;
import com.backendless.geo.SearchMatchesResult;
import com.backendless.messaging.DeliveryOptions;
import com.backendless.messaging.EmailEnvelope;
import com.backendless.messaging.Message;
import com.backendless.messaging.MessageStatus;
import com.backendless.messaging.PublishMessageInfo;
import com.backendless.messaging.PublishOptions;
import com.backendless.persistence.DataQueryBuilder;
import com.backendless.persistence.LoadRelationsQueryBuilder;
import com.backendless.property.ObjectProperty;
import com.backendless.property.UserProperty;
import com.backendless.push.DeviceRegistrationResult;
import com.backendless.rt.ReconnectAttempt;
import com.backendless.rt.command.Command;
import com.backendless.rt.data.BulkEvent;
import com.backendless.rt.users.UserInfo;
import com.backendless.rt.users.UserStatusResponse;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.SerializationFeature;
import io.flutter.plugin.common.StandardMessageCodec;

public final class BackendlessMessageCodec extends StandardMessageCodec {
    public static final BackendlessMessageCodec INSTANCE = new BackendlessMessageCodec();
    private ObjectMapper objectMapper = new ObjectMapper();

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
    private static final byte EMAIL_ENVELOPE = (byte) 154;

    private BackendlessMessageCodec() {
        objectMapper.enable(SerializationFeature.WRITE_ENUMS_USING_INDEX);
        objectMapper.addMixIn(DataQueryBuilder.class, DataQueryBuilderMixin.class);
        objectMapper.addMixIn(LoadRelationsQueryBuilder.class, LoadRelationsQueryBuilderMixin.class);
        objectMapper.addMixIn(Command.class, CommandMixin.class);
        objectMapper.addMixIn(ReconnectAttempt.class, ReconnectAttemptMixin.class);
        objectMapper.addMixIn(GeoPoint.class, GeoPointMixin.class);
    }

    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value) {
        if (value instanceof Date) {
            stream.write(DATE_TIME);
            writeValue(stream, ((Date) value).getTime());
        } else if (value instanceof GeoPoint && !(value instanceof GeoCluster)) {
            stream.write(GEO_POINT);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof DataQueryBuilder) {
            stream.write(DATA_QUERY_BUILDER);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof LoadRelationsQueryBuilder) {
            stream.write(LOAD_RELATIONS_QUERY_BUILDER);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof ObjectProperty) {
            stream.write(OBJECT_PROPERTY);
            writeValue(stream, objectMapper.convertValue(new ObjectPropertyMixin(value), Map.class));
        } else if (value instanceof GooglePlaySubscriptionStatus) {
            stream.write(GOOGLE_PLAY_SUBSCRIPTION_STATUS);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof GooglePlayPurchaseStatus) {
            stream.write(GOOGLE_PLAY_PURCHASE_STATUS);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof FileInfo) {
            stream.write(FILE_INFO);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof GeoCategory) {
            stream.write(GEO_CATEGORY);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof BackendlessGeoQuery) {
            stream.write(GEO_QUERY);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof GeoCluster) {
            stream.write(GEO_CLUSTER);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof SearchMatchesResult) {
            stream.write(SEARCH_MATCHES_RESULT);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof MessageStatus) {
            stream.write(MESSAGE_STATUS);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof DeviceRegistration) {
            stream.write(DEVICE_REGISTRATION);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof Message) {
            stream.write(MESSAGE);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof PublishOptions) {
            stream.write(PUBLISH_OPTIONS);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof DeliveryOptions) {
            stream.write(DELIVERY_OPTIONS);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof PublishMessageInfo) {
            stream.write(PUBLISH_MESSAGE_INFO);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof DeviceRegistrationResult) {
            stream.write(DEVICE_REGISTRATION_RESULT);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof Command) {
            stream.write(COMMAND);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof UserInfo) {
            stream.write(USER_INFO);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof UserStatusResponse) {
            stream.write(USER_STATUS_RESPONSE);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof ReconnectAttempt) {
            stream.write(RECONNECT_ATTEMPT);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof BackendlessUser) {
            stream.write(BACKENDLESS_USER);
            writeValue(stream, ((BackendlessUser) value).getProperties());
        } else if (value instanceof UserProperty) {
            stream.write(USER_PROPERTY);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof BulkEvent) {
            stream.write(BULK_EVENT);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
        } else if (value instanceof EmailEnvelope) {
            stream.write(EMAIL_ENVELOPE);
            writeValue(stream, objectMapper.convertValue(value, Map.class));
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
                return new Date((Long) readValue(buffer));
            case GEO_POINT:
                return objectMapper.convertValue(readValue(buffer), GeoPoint.class);
            case DATA_QUERY_BUILDER:
                return objectMapper.convertValue(readValue(buffer), DataQueryBuilder.class);
            case LOAD_RELATIONS_QUERY_BUILDER:
                return objectMapper.convertValue(readValue(buffer), LoadRelationsQueryBuilder.class);
            case OBJECT_PROPERTY:
                return objectMapper.convertValue(readValue(buffer), ObjectProperty.class);
            case GOOGLE_PLAY_SUBSCRIPTION_STATUS:
                return objectMapper.convertValue(readValue(buffer), GooglePlaySubscriptionStatus.class);
            case GOOGLE_PLAY_PURCHASE_STATUS:
                return objectMapper.convertValue(readValue(buffer), GooglePlayPurchaseStatus.class);
            case FILE_INFO:
                return objectMapper.convertValue(readValue(buffer), FileInfo.class);
            case GEO_CATEGORY:
                return objectMapper.convertValue(readValue(buffer), GeoCategory.class);
            case GEO_QUERY:
                return objectMapper.convertValue(readValue(buffer), BackendlessGeoQuery.class);
            case GEO_CLUSTER:
                return objectMapper.convertValue(readValue(buffer), GeoCluster.class);
            case SEARCH_MATCHES_RESULT:
                return objectMapper.convertValue(readValue(buffer), SearchMatchesResult.class);
            case MESSAGE_STATUS:
                return objectMapper.convertValue(readValue(buffer), MessageStatus.class);
            case DEVICE_REGISTRATION:
                return objectMapper.convertValue(readValue(buffer), DeviceRegistration.class);
            case MESSAGE:
                return objectMapper.convertValue(readValue(buffer), Message.class);
            case PUBLISH_OPTIONS:
                return objectMapper.convertValue(readValue(buffer), PublishOptions.class);
            case DELIVERY_OPTIONS:
                return objectMapper.convertValue(readValue(buffer), DeliveryOptions.class);
            case PUBLISH_MESSAGE_INFO:
                return objectMapper.convertValue(readValue(buffer), PublishMessageInfo.class);
            case DEVICE_REGISTRATION_RESULT:
                return objectMapper.convertValue(readValue(buffer), DeviceRegistrationResult.class);
            case COMMAND:
                return objectMapper.convertValue(readValue(buffer), Command.class);
            case USER_INFO:
                return objectMapper.convertValue(readValue(buffer), UserInfo.class);
            case USER_STATUS_RESPONSE:
                return objectMapper.convertValue(readValue(buffer), UserStatusResponse.class);
            case RECONNECT_ATTEMPT:
                return objectMapper.convertValue(readValue(buffer), ReconnectAttempt.class);
            case BACKENDLESS_USER:
                return objectMapper.convertValue(readValue(buffer), BackendlessUser.class);
            case USER_PROPERTY:
                return objectMapper.convertValue(readValue(buffer), UserProperty.class);
            case BULK_EVENT:
                return objectMapper.convertValue(readValue(buffer), BulkEvent.class);
            case EMAIL_ENVELOPE:
                return objectMapper.convertValue(readValue(buffer), EmailEnvelope.class);
            default:
                return super.readValueOfType(type, buffer);
        }
    }

}
