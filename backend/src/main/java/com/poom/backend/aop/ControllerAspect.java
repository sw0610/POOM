package com.poom.backend.aop;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;

@Aspect
@Component
@Slf4j
public class ControllerAspect {

    @Pointcut("execution(* com.poom.backend.api.controller.*.*(..))")
    public void restControllerCut(){}

    @Around("restControllerCut()")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        if(joinPoint == null) return null;
        long start = System.currentTimeMillis();
        Object proceed = joinPoint.proceed();
        long executionTime = System.currentTimeMillis() - start;
        log.info("execute time {} ms ", executionTime);
        return proceed;
    }

    // Pointcut에 의해 필터링된 경로로 들어오는 경우 메서드 호출 전에 적용
    @Before("restControllerCut()")
    public void beforeParameterLog(JoinPoint joinPoint) {
        Signature s = joinPoint.getSignature();
        // 파라미터 받아오기
        Object[] args = joinPoint.getArgs();
        if(args == null) return;
        int cnt = 1;
        for (Object arg : args) {
            log.info("파라미터 {} | class : {} | 값 : {}",cnt++, arg.getClass().getSimpleName(), arg);
        }
    }

    // Poincut에 의해 필터링된 경로로 들어오는 경우 메서드 리턴 후에 적용
    @AfterReturning(value = "restControllerCut()", returning = "returnObj")
    public void afterReturnLog(Object returnObj) {
        if (returnObj == null) return;
        log.info("return type = {}", returnObj.getClass().getSimpleName());
        log.info("return value = {}", returnObj);
    }
}
