package first.example.firstclass.domain;

import java.sql.Date;
import java.sql.Timestamp;

import javax.validation.constraints.Digits;
import javax.validation.constraints.Size;

import lombok.Data;

@Data
public class ApplicationDTO {
    private Long applicationNumber;

    private Long userId;
    
    private String bankCode;
    private String bankName;
    private String accountNumber;

    @Digits(integer = 19, fraction = 0, message = "통상임금은 숫자 19자리 이하의 정수여야 합니다.")
    private Long regularWage;
    
    @Digits(integer = 5, fraction = 0, message = "주당 소정근로시간은 숫자 5자리 이하의 정수여야 합니다.")
    private Integer weeklyHours;

    private String statusCode;
    private String statusName;
    
    @Size(max = 50, message = "자녀 이름은 최대 50자입니다.")
    private String childName;
    private String childResiRegiNumber;
    private String businessRegiNumber;
    
    @Size(max = 100, message = "사업장 이름은 최대 100자입니다.")
    private String businessName;
    private String businessZipNumber;
    private String businessAddrBase;
    
    @Size(max = 200, message = "사업장 상세주소는 최대 200자입니다.")
    private String businessAddrDetail;

    private Long payment;
    private String businessAgree;
    private String govInfoAgree;
    
    private Date startDate;
    private Date endDate;
    private Date childBirthDate;
    
    private Timestamp submittedDt;
    private String paymentResult;
    private String rejectionReasonCode;
    private String rejectComment;
    private Date examineDt;
    private String rejectionReasonName;
}
