package first.example.firstclass.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
	@Bean
	public BCryptPasswordEncoder bCryptPasswordEncoder() {

	    return new BCryptPasswordEncoder();
	}

	@Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

		http
	        .authorizeHttpRequests()
	            .requestMatchers(
	                new AntPathRequestMatcher("/login"),
	                new AntPathRequestMatcher("/loginProc"),
	                new AntPathRequestMatcher("/join/**"),
	                new AntPathRequestMatcher("/joinProc")
	            ).permitAll()
	            .requestMatchers(
	            		new AntPathRequestMatcher("/admin"), 
	            		new AntPathRequestMatcher("/adminlist")
	            ).hasRole("ADMIN")
	            .anyRequest().authenticated();
        
        http
        	.formLogin()
        		.loginPage("/login")
                .loginProcessingUrl("/loginProc")
                .successHandler((request, response, authentication) -> {
                    // 사용자의 권한(role)을 확인
                    boolean isAdmin = authentication.getAuthorities().stream()
                            .map(GrantedAuthority::getAuthority)
                            .anyMatch(auth -> auth.equals("ROLE_ADMIN"));

                    if (isAdmin) {
                        // ADMIN이면 /adminlist로 리디렉션
                        response.sendRedirect("/firstclass/adminlist");
                    } else {
                        // 일반 사용자이면 /main으로 리디렉션
                        response.sendRedirect("/firstclass/main");
                    }
                })
                .permitAll();
        
        http.csrf().disable();

        return http.build();
    }
}
