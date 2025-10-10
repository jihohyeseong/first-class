package first.example.firstclass.domain;

import lombok.Data;

@Data
public class AdminListDTO {
    private Long applicationNumber;
    private Long userId;
    private String name;
    private String statusCode;
    private String submittedDate;
    private String statusName;
}
