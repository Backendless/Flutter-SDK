package com.backendless.backendless_sdk.utils.codec.mixins;

import com.backendless.persistence.LoadRelationsQueryBuilder;
import com.fasterxml.jackson.annotation.JsonCreator;

import java.util.Map;

public abstract class LoadRelationsQueryBuilderMixin {

    @JsonCreator
    public static LoadRelationsQueryBuilder<Map<String, Object>> ofMap() {
        return LoadRelationsQueryBuilder.ofMap();
    }
}
