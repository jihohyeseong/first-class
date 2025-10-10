package first.example.firstclass.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import first.example.firstclass.domain.CodeDTO;
import first.example.firstclass.service.CodeService;
import lombok.RequiredArgsConstructor;


@Controller
@RequiredArgsConstructor
public class CodeController {

	private final CodeService codeService;
	
	@GetMapping("/code/reject")
	@ResponseBody
	public ResponseEntity<List<CodeDTO>> getRejectCode() {
		
		List<CodeDTO> list = codeService.getRejectCodeList();
		
		return ResponseEntity.status(HttpStatus.OK).body(list);
	}
}
