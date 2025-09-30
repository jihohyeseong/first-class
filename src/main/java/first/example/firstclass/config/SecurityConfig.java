package first.example.firstclass.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

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
        		.requestMatchers("/login","/application").permitAll()
				.requestMatchers("/admin").hasRole("ADMIN")
			    .anyRequest().authenticated();
        
        http
        	.formLogin()
        		.loginPage("/login")
                .loginProcessingUrl("/loginProc")
                .permitAll();
        
        http.csrf().disable();

        return http.build();
    }
}
