package com.backendless.backendless_sdk.utils.codec.mixins;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

public abstract class ReconnectAttemptMixin {

    @JsonCreator
    ReconnectAttemptMixin(@JsonProperty("timeout") int timeout,
                          @JsonProperty("attempt") int attempt) {

    }
}
