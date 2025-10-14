package first.example.firstclass.domain;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TermAmountDTO {
	
	private Long termId;
	private Long applicationNumber;
	private Long companyPayment;
	private Long govPayment;
	private Date paymentDate;
	private Date startMonthDate;
	private Date endMonthDate;
}
