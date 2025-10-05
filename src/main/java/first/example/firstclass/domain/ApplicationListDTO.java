package first.example.firstclass.domain;

import lombok.Data;

@Data
public class ApplicationListDTO {
    private Long applicationNumber;
    private String submittedDate;
    private String statusName;
}
