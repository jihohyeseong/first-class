package first.example.firstclass.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
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
        		.requestMatchers(new AntPathRequestMatcher("/login"),
                        new AntPathRequestMatcher("/application")).permitAll()
				.requestMatchers(new AntPathRequestMatcher("/admin")).hasRole("ADMIN")
			    .anyRequest().permitAll();
        
        http
        	.formLogin()
        		.loginPage("/login")
                .loginProcessingUrl("/loginProc")
                .permitAll();
        
        http.csrf().disable();

        return http.build();
    }
}
