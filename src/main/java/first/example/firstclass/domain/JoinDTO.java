package first.example.firstclass.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class JoinDTO {

	private Long id;
	private String name;
	private String registrationNumber;
	private String address;
	private String username;
	private String password;
	private String role;
	private String deltAt;
	
}
