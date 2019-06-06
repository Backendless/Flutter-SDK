package com.backendless.backendless_sdk.utils.codec.mixins;

import com.backendless.rt.command.Command;
import com.fasterxml.jackson.annotation.JsonCreator;

import java.util.Map;

public class CommandMixin {

    @JsonCreator
    public static Command<Map> map() {
        return Command.map();
    }
}
