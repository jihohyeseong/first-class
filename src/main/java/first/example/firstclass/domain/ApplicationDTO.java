package first.example.firstclass.domain;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class ApplicationDTO {
    private Long applicationNumber;

    private Long userId;
    
    private String bankCode;
    private String bankName;
    private String accountNumber;

    private Long regularWage;
    private Integer weeklyHours;

    private String statusCode;
    private String statusName;
    private String childName;
    private String childResiRegiNumber;
    private String businessRegiNumber;
    private String businessName;
    private String businessZipNumber;
    private String businessAddrBase;
    private String businessAddrDetail;

    private Long payment;
    private String businessAgree;
    private String govInfoAgree;
    
    private Date startDate;
    private Date endDate;
    private Date childBirthDate;
    
    private Timestamp submittedDt;
}
