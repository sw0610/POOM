package com.poom.backend.api.service.fundraiser;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class FundraiserScheduler {

    private final FundraiserService fundraiserService;

    // 매일 0시 0분 0초에 실행
    @Scheduled(cron = "0 0 0 * * *")
    public void endFundraiser() {
        fundraiserService.endFundraiser();
    }
}
