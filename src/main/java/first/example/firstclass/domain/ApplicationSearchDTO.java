package first.example.firstclass.domain;

import lombok.Data;

@Data
public class ApplicationSearchDTO {
    private String keyword;
    private String status;
    private String date;
    private PageDTO pageDTO;
}
