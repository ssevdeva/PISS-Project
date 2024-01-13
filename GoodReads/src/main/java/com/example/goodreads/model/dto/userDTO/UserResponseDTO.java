package com.example.goodreads.model.dto.userDTO;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.bind.annotation.ResponseBody;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ResponseBody
public class UserResponseDTO {

    private long id;
    private String email;

}
