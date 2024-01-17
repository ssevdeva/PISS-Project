package com.example.goodreads.services;

import com.example.goodreads.exceptions.BadRequestException;
import com.example.goodreads.exceptions.DeniedPermissionException;
import com.example.goodreads.exceptions.UnauthorizedException;
import com.example.goodreads.model.entities.User;
import com.example.goodreads.model.repository.UserRepository;
import com.example.goodreads.services.util.Helper;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

@SpringBootTest
public class UserServiceTest {
    @Autowired
    UserService userService;

    @Mock
    private UserRepository userRepositoryMock;

    @Mock
    User userMock;

    @Mock
    Helper helperMock;

    @Test
    void registerNoEmail() {
        assertThrows(BadRequestException.class, () -> userService.register(null, "pass", "name", "pass"),
                "Expected BadRequestException, but it was not thrown.");
    }

    @Test
    void registerNoPassword() {
        assertThrows(BadRequestException.class, () -> userService.register("mail", null, "name", "pass"),
                "Expected BadRequestException, but it was not thrown.");
    }

    @Test
    void registerInvalidEmail() {
        assertThrows(BadRequestException.class, () -> userService.register("invalid.email@.com", "pass", "name", "pass"),
                "Expected BadRequestException, but it was not thrown.");
    }

    @Test
    void registerConfirmPasswordNotMatching() {
        assertThrows(DeniedPermissionException.class, () -> userService.register("user@example.com", "pass", "name", "no_pass"),
                "Expected DeniedPermissionException, but it was not thrown.");
    }

    @Test
    void registerInvalidPassword() {
        assertThrows(DeniedPermissionException.class, () -> userService.register("user@example.com", "pass", "name", "no_pass"),
                "Expected DeniedPermissionException, but it was not thrown.");
    }

    @Test
    void registerNoFirstName() {
        assertThrows(BadRequestException.class, () -> userService.register("user@example.com", "VeLi88Veli&&", null, "VeLi88Veli&&"),
                "Expected BadRequestException, but it was not thrown.");
    }

    @Test
    void registerShortFirstName() {
        assertThrows(BadRequestException.class, () -> userService.register("user@example.com", "VeLi88Veli&&", "n", "VeLi88Veli&&"),
                "Expected BadRequestException, but it was not thrown.");
    }

    @Test
    void loginNoEmail() {
        assertThrows(BadRequestException.class, () -> userService.login("", "pswd"),
                "Expected BadRequestException, but it was not thrown.");
    }

    @Test
    void loginNoPassword() {
        assertThrows(BadRequestException.class, () -> userService.login("invalid.email@.com", ""),
                "Expected BadRequestException, but it was not thrown.");
    }

    @Test
    void loginEmailNotExist() {
        when(userRepositoryMock.findByEmail("user@example.com")).thenReturn(null);

        assertThrows(UnauthorizedException.class, () -> userService.login("user@example.com", "pswd"),
                "Expected UnauthorizedException, but it was not thrown.");
    }

}
