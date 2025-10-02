package first.example.firstclass.domain;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class UserVO implements Serializable {

	private static final long serialVersionUID = 1L;
	private String username;
	private String password;
	private String role;
}
