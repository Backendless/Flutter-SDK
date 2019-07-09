package com.backendless.backendless_sdk.utils.codec.mixins;

import com.backendless.persistence.LoadRelationsQueryBuilder;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;
import java.util.Map;

public abstract class LoadRelationsQueryBuilderMixin {

    @JsonCreator
    public static LoadRelationsQueryBuilder<Map<String, Object>> ofMap() {
        return LoadRelationsQueryBuilder.ofMap();
    }

    @JsonProperty("properties")
    public abstract LoadRelationsQueryBuilder setProperties(List<String> properties);

    @JsonProperty("sortBy")
    public abstract LoadRelationsQueryBuilder setSortBy(List<String> sortBy);
}
