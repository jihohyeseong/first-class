package first.example.firstclass.util;

import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class AES256Util {

	 public static String alg = "AES/CBC/PKCS5Padding";
	 
	 // XML 설정 파일에서 주입될 암호화 키
	 @Value("${aes.key}")
	 private String key;
	
	 private String getIv() {
	     // IV는 키의 앞 16바이트를 사용합니다.
	     return this.key.substring(0, 16);
	 }
	
	 // 암호화
	 public String encrypt(String text) throws Exception {
	     Cipher cipher = Cipher.getInstance(alg);
	     SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(), "AES");
	     IvParameterSpec ivParamSpec = new IvParameterSpec(getIv().getBytes());
	     cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivParamSpec);
	
	     byte[] encrypted = cipher.doFinal(text.getBytes("UTF-8"));
	     return Base64.getEncoder().encodeToString(encrypted);
	 }
	
	 // 복호화
	 public String decrypt(String cipherText) throws Exception {
	     Cipher cipher = Cipher.getInstance(alg);
	     SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(), "AES");
	     IvParameterSpec ivParamSpec = new IvParameterSpec(getIv().getBytes());
	     cipher.init(Cipher.DECRYPT_MODE, keySpec, ivParamSpec);
	
	     byte[] decodedBytes = Base64.getDecoder().decode(cipherText);
	     byte[] decrypted = cipher.doFinal(decodedBytes);
	     return new String(decrypted, "UTF-8");
	 }
}