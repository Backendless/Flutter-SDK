package com.backendless.backendless_sdk.utils.codec;

import com.backendless.Backendless;
import com.backendless.BackendlessUser;
import com.backendless.DeviceRegistration;
import com.backendless.backendless_sdk.utils.codec.mixins.CommandMixin;
import com.backendless.backendless_sdk.utils.codec.mixins.DataQueryBuilderMixin;
import com.backendless.backendless_sdk.utils.codec.mixins.LoadRelationsQueryBuilderMixin;
import com.backendless.backendless_sdk.utils.codec.mixins.ObjectPropertyMixin;
import com.backendless.backendless_sdk.utils.codec.mixins.ReconnectAttemptMixin;
import com.backendless.commerce.GooglePlayPurchaseStatus;
import com.backendless.commerce.GooglePlaySubscriptionStatus;
import com.backendless.files.FileInfo;
import com.backendless.messaging.DeliveryOptions;
import com.backendless.messaging.EmailEnvelope;
import com.backendless.messaging.Message;
import com.backendless.messaging.MessageStatus;
import com.backendless.messaging.PublishMessageInfo;
import com.backendless.messaging.PublishOptions;
import com.backendless.persistence.BackendlessDataQuery;
import com.backendless.persistence.DataQueryBuilder;
import com.backendless.persistence.LineString;
import com.backendless.persistence.LoadRelationsQueryBuilder;
import com.backendless.persistence.Point;
import com.backendless.persistence.Polygon;
import com.backendless.property.ObjectProperty;
import com.backendless.property.UserProperty;
import com.backendless.push.DeviceRegistrationResult;
import com.backendless.rt.ReconnectAttempt;
import com.backendless.rt.command.Command;
import com.backendless.rt.data.BulkEvent;
import com.backendless.rt.data.RelationStatus;
import com.backendless.rt.users.UserInfo;
import com.backendless.rt.users.UserStatusResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    private static final byte POINT = (byte) 155;
    private static final byte LINE_STRING = (byte) 156;
    private static final byte POLYGON = (byte) 157;
    private static final byte RELATION_STATUS = (byte) 158;

    private BackendlessMessageCodec() {
        objectMapper.enable(SerializationFeature.WRITE_ENUMS_USING_INDEX);
        objectMapper.addMixIn(DataQueryBuilder.class, DataQueryBuilderMixin.class);
        objectMapper.addMixIn(LoadRelationsQueryBuilder.class, LoadRelationsQueryBuilderMixin.class);
        objectMapper.addMixIn(Command.class, CommandMixin.class);
        objectMapper.addMixIn(ReconnectAttempt.class, ReconnectAttemptMixin.class);
    }

    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value) {
        if (value instanceof Date) {
            stream.write(DATE_TIME);
            writeValue(stream, ((Date) value).getTime());
        } else if (value instanceof DataQueryBuilder) {
            stream.write(DATA_QUERY_BUILDER);
            Map<String, Object> result = new HashMap<>();
            BackendlessDataQuery dataQuery = ((DataQueryBuilder) value).build();
            result.put("pageSize", dataQuery.getPageSize());
            result.put("offset", dataQuery.getOffset());
            result.put("properties", dataQuery.getProperties());
            result.put("whereClause", dataQuery.getWhereClause());
            result.put("groupBy", dataQuery.getGroupBy());
            result.put("havingClause", dataQuery.getHavingClause());
            result.put("sortBy", dataQuery.getQueryOptions().getSortBy());
            result.put("related", dataQuery.getQueryOptions().getRelated());
            result.put("relationsDepth", dataQuery.getQueryOptions().getRelationsDepth());
            result.put("relationsPageSize", dataQuery.getQueryOptions().getRelationsPageSize());
            result.put("distinct", dataQuery.getDistinct());
            writeValue(stream, result);
        } else if (value instanceof LoadRelationsQueryBuilder) {
            stream.write(LOAD_RELATIONS_QUERY_BUILDER);
            Map<String, Object> result = new HashMap<>();
            BackendlessDataQuery dataQuery = ((LoadRelationsQueryBuilder) value).build();
            result.put("relationName", dataQuery.getQueryOptions().getRelated().get(0));
            result.put("pageSize", dataQuery.getPageSize());
            result.put("offset", dataQuery.getOffset());
            result.put("properties", dataQuery.getProperties());
            result.put("sortBy", dataQuery.getQueryOptions().getSortBy());
            writeValue(stream, result);
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
        } else if (value instanceof Point) {
            stream.write(POINT);
            writeValue(stream,  ((Point) value).asWKT());
        } else if (value instanceof LineString) {
            stream.write(LINE_STRING);
            writeValue(stream,  ((LineString) value).asWKT());
        } else if (value instanceof Polygon) {
            stream.write(POLYGON);
            writeValue(stream,  ((Polygon) value).asWKT());
        } else if (value instanceof RelationStatus) {
            stream.write(RELATION_STATUS);
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
                Map<String, Object> user = new HashMap<>();
                user.put("properties", readValue(buffer));
                return objectMapper.convertValue(user, BackendlessUser.class);
            case USER_PROPERTY:
                return objectMapper.convertValue(readValue(buffer), UserProperty.class);
            case BULK_EVENT:
                return objectMapper.convertValue(readValue(buffer), BulkEvent.class);
            case EMAIL_ENVELOPE:
                return objectMapper.convertValue(readValue(buffer), EmailEnvelope.class);
            case POINT:
                return Point.<Point>fromWKT((String) readValue(buffer));
            case LINE_STRING:
                return LineString.<LineString>fromWKT((String) readValue(buffer));
            case POLYGON:
                return Polygon.<Polygon>fromWKT((String) readValue(buffer));
            case RELATION_STATUS:
                return objectMapper.convertValue(readValue(buffer), RelationStatus.class);
            default:
                return super.readValueOfType(type, buffer);
        }
    }

}
