package com.example.goodreads.model.dto.userDTO;

import com.example.goodreads.model.entities.User;
import com.example.goodreads.services.util.Helper;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
public class UserDTO {

    private long userId;
    private String email;
    private String firstName;
    private String lastName;
    private char gender;
    private String username;
    private LocalDate dateOfBirth;
    private String booksPreferences;

    public boolean isValid() {
        return (Helper.isValidEmail(email) && !firstName.isBlank() && User.Gender.isValidGender(gender));
    }

}
