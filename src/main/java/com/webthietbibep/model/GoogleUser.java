package com.webthietbibep.model;

import java.io.Serializable;

public class GoogleUser  implements Serializable {
    private String id;
    private String email;
    private String name;

    public String getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getName() {
        return name;
    }
}