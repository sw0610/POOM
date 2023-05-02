package com.poom.backend.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

//  UnAuthorizationException이라는 사용자 정의 예외 클래스를 정의 401 Unauthorized 코드를 반환하도록 설정
@ResponseStatus(value = HttpStatus.UNAUTHORIZED)
public class UnAuthorizationException extends RuntimeException {
    public UnAuthorizationException() {
        super();
    }
    public UnAuthorizationException(String message, Throwable cause) {
        super(message, cause);
    }
    public UnAuthorizationException(String message) {
        super(message);
    }
    public UnAuthorizationException(Throwable cause) {
        super(cause);
    }
}
