package first.example.firstclass.domain;

import java.util.ArrayList;
import java.util.Collection;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public class CustomUserDetails implements UserDetails {

    private static final long serialVersionUID = 1L;

    // UserVO를 직접 참조하는 대신, 필요한 데이터만 필드로 선언
    private String username;
    private String password;
    private Collection<? extends GrantedAuthority> authorities;
    // UserVO 객체는 더 이상 필요 없으므로 제거하거나, 필요 시 transient로 선언

    // 1. 세션 역직렬화를 위한 기본 생성자
    public CustomUserDetails() {
    }

    // 2. 로그인 시 사용할 생성자
    public CustomUserDetails(UserVO userVO) {
        // UserVO 객체에서 필요한 데이터만 복사하여 필드에 저장
        this.username = userVO.getUsername();
        this.password = userVO.getPassword();
        
        Collection<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority(userVO.getRole()));
        this.authorities = authorities;
    }

    // 3. 필드를 직접 반환하도록 메소드 수정
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return this.authorities;
    }

    @Override
    public String getPassword() {
        return this.password;
    }

    @Override
    public String getUsername() {
        // 이제 이 메소드는 절대 NullPointerException을 발생시키지 않습니다.
        return this.username;
    }
    
    // 나머지 is... 메소드들은 그대로 true를 반환
	@Override
	public boolean isAccountNonExpired() { return true; }
	@Override
	public boolean isAccountNonLocked() { return true; }
	@Override
	public boolean isCredentialsNonExpired() { return true; }
	@Override
	public boolean isEnabled() { return true; }
}