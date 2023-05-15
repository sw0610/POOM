package com.poom.backend.api.dto.donation;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Builder
public class DonationDto {

  private Long donationId;
  private Long fundraiserId;
  private String nftImgUrl;
  private String dogName;
  private Double donateAmount;
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yy.MM.dd", timezone = "Asia/Seoul")
  private LocalDate donateDate;
  private int isIssued;

}
