package first.example.firstclass.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminJudgeDTO {

	private Long applicationNumber;
	private Long processorId;
	private String paymentResult;
	private String rejectionReasonCode;
	private String rejectComment;
}
