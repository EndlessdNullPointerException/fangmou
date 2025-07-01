package com.example.fangmou_service.model;

public enum ResultCode {
    SUCCESS(200),ERROR(500);

    private final Integer code;

    ResultCode(Integer code) {
        this.code = code;
    }

    Integer getCode() {
        return code;
    }
}
