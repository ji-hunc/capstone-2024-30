package com.example.capstone.global.error.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ErrorCode {

    // Common Error
    INVALID_INPUT_VALUE(400, "C001", "Invalid Input Value"),
    METHOD_NOT_ALLOWED(405, "C002", "Invalid Input Value"),
    ENTITY_NOT_FOUND(400, "C003", "Entity Not Found"),
    INTERNAL_SERVER_ERROR(500, "C004", "Server Error"),
    INVALID_TYPE_VALUE(400, "C005", "Invalid Type Value"),
    HANDLE_ACCESS_DENIED(403, "C006", "Access is Denied"),

    // JWT Error
    INVALID_JWT_TOKEN(401, "J001", "Invalid JWT Token"),

    // User Error
    ALREADY_EMAIL_EXIST(400, "U001", "Already email exists"),
    USER_NOT_FOUND(400, "U002", "User Not Found")
    ;

    private int status;
    private final String code;
    private final String message;
}