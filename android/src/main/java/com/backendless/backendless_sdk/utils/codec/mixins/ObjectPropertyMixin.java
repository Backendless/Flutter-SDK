package com.backendless.backendless_sdk.utils.codec.mixins;

import com.backendless.property.ObjectProperty;

public class ObjectPropertyMixin extends ObjectProperty {
    private String relatedTable;
    private String name;


    public ObjectPropertyMixin(Object object) {
        ObjectProperty objectProperty = (ObjectProperty) object;
        setRequired(objectProperty.isRequired());
        setType(objectProperty.getType());
        setDefaultValue(objectProperty.getDefaultValue());

        try {
            name = objectProperty.getName();
        } catch (NullPointerException e) {
            name = null;
        }
        try {
            relatedTable = objectProperty.getRelatedTable();
        } catch (NullPointerException e) {
            relatedTable = null;
        }
    }

    @Override
    public String getRelatedTable() {
        return relatedTable;
    }

    @Override
    public String getName() {
        return name;
    }

}
