package first.example.firstclass.domain;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class JoinDTO {

	private Long id;
	
	@NotEmpty(message = "이름는 한글로 최소 2자 이상이어야 합니다.")
	@Pattern(regexp = "^[가-힣]{1,}$", message = "정확한 이름을 입력하세요.")
	private String name;
	
	@NotEmpty(message = "주민등록번호를 입력해주세요.")
	@Pattern(regexp = "^[0-9]{13}$", message = "주민등록번호 13자리를 정확하게 입력해주세요.")
	private String registrationNumber;
	
	@NotEmpty(message = "우편번호를 입력해주세요.")
	@Pattern(regexp = "^[0-9]{5}$", message = "올바른 우편번호 형식이 아닙니다.")
	private String zipNumber;
	
	@NotEmpty(message = "기본주소를 입력해주세요.")
	private String addressBase;
	
	@NotEmpty(message = "상세주소를 입력해주세요.")
	private String addressDetail;
	
	@NotEmpty(message = "id는 최소 5자 이상 최대 20자 이하여야 합니다.")
	@Size(min = 5 , max = 20, message = "id는 최소 5자 이상 최대 20자 이하여야 합니다.")
	@Pattern(regexp = "^[a-zA-Z0-9]+$", message = "id는 영문자와 숫자만 사용할 수 있습니다.")
	private String username;
	
	@NotEmpty(message = "비밀번호는 최소 8자 이상이어야 하며, 특수문자 하나 이상을 포함해야 합니다.")
	@Pattern(regexp = "^(?=.*[!@#$%^&*()-+=])(?=\\S+$).{8,}$", message = "비밀번호는 최소 8자 이상이어야 하며, 특수문자 하나 이상을 포함해야 합니다.")
	private String password;
	
	private String role;
	
	private String deltAt;
	
}
