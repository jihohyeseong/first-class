package first.example.firstclass.service;

import java.util.List;

import org.springframework.stereotype.Service;

import first.example.firstclass.dao.CodeDAO;
import first.example.firstclass.domain.CodeDTO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CodeService {

	private final CodeDAO codeDAO;

	public List<CodeDTO> getRejectCodeList() {
		
		return codeDAO.findAllRejectCode();
	}
}
