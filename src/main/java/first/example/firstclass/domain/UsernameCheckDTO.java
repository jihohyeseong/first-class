package first.example.firstclass.domain;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UsernameCheckDTO {

	@NotEmpty(message = "id는 최소 5자 이상 최대 20자 이하여야 합니다.")
	@Size(min = 5 , max = 20, message = "id는 최소 5자 이상 최대 20자 이하여야 합니다.")
	@Pattern(regexp = "^[a-zA-Z0-9]+$", message = "id는 영문자와 숫자만 사용할 수 있습니다.")
	private String username;
}
