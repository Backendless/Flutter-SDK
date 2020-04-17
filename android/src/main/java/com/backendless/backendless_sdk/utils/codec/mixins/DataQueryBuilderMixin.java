package com.backendless.backendless_sdk.utils.codec.mixins;

import com.backendless.persistence.DataQueryBuilder;
import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;
import java.util.List;


@JsonIgnoreProperties({"relationsPageSize"})
public abstract class DataQueryBuilderMixin {

    @JsonProperty("properties")
    public abstract DataQueryBuilder setProperties(List<String> properties);

    @JsonProperty("sortBy")
    public abstract DataQueryBuilder setSortBy(List<String> sortBy);

    @JsonProperty("related")
    public abstract DataQueryBuilder setRelated(List<String> related);

    @JsonProperty("excludeProperties")
    public abstract DataQueryBuilder excludeProperties( ArrayList<String> excludeProperties );
}
