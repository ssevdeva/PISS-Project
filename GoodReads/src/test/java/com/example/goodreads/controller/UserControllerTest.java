package com.example.goodreads.controller;

import com.example.goodreads.model.dto.userDTO.*;
import com.example.goodreads.services.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
class UserControllerTest {

    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;

    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(userController).build();
    }

    @Test
    void testRegister() throws Exception {
        UserResponseDTO mockedResponse = new UserResponseDTO();
        mockedResponse.setId(1L);
        mockedResponse.setEmail("test@example.com");

        when(userService.register(any(), any(), any(), any())).thenReturn(mockedResponse);

        RegisterUserDTO registerUserDTO = new RegisterUserDTO();
        registerUserDTO.setEmail("test@example.com");
        registerUserDTO.setPassword("password");
        registerUserDTO.setFirstName("John");
        registerUserDTO.setConfirmPassword("password");

        mockMvc.perform(post("/users/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(new ObjectMapper().writeValueAsString(registerUserDTO)))
                .andExpect(status().isOk());

    }

    @Test
    void testLogin() throws Exception {
        UserResponseDTO mockedResponse = new UserResponseDTO();
        mockedResponse.setId(1L);
        mockedResponse.setEmail("test@example.com");

        when(userService.login(any(), any())).thenReturn(mockedResponse);

        LoginUserDTO loginUserDTO = new LoginUserDTO();
        loginUserDTO.setEmail("test@example.com");
        loginUserDTO.setPassword("password");

        mockMvc.perform(post("/users/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(new ObjectMapper().writeValueAsString(loginUserDTO)))
                .andExpect(status().isOk());

    }

    @Test
    void testGetUser() {
        long userId = 1L;  // Set the user ID for testing
        GetUserDTO mockedUserDTO = new GetUserDTO();

        HttpSession mockSession = mock(HttpSession.class);

        when(mockSession.getAttribute(UserController.LOGGED)).thenReturn(true);
        when(mockSession.isNew()).thenReturn(false);

        when(userService.getUser(userId)).thenReturn(mockedUserDTO);

        ResponseEntity<GetUserDTO> responseEntity = userController.getUser(userId, mockSession);

        assertNotNull(responseEntity);
        assertEquals(HttpStatus.OK, responseEntity.getStatusCode());

        GetUserDTO returnedDTO = responseEntity.getBody();
        assertNotNull(returnedDTO);
    }

}
