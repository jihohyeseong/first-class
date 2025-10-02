package first.example.firstclass.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserDTO {

	private String name;
	private String registrationNumber;
	private String zipNumber;
	private String addressBase;
	private String addressDetail;

}
