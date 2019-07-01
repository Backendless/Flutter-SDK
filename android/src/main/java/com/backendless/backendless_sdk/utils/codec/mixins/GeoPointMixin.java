package com.backendless.backendless_sdk.utils.codec.mixins;

import com.fasterxml.jackson.annotation.JsonIgnore;

public abstract class GeoPointMixin {

    @JsonIgnore
    abstract Double getLatitudeE6();


    @JsonIgnore
    abstract Double getLongitudeE6();
}
