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
        // Mocking the registration response
        UserResponseDTO mockedResponse = new UserResponseDTO();
        mockedResponse.setId(1L);
        mockedResponse.setEmail("test@example.com");

        // Mocking the service call
        when(userService.register(any(), any(), any(), any())).thenReturn(mockedResponse);

        // Creating a RegisterUserDTO instance for the request body
        RegisterUserDTO registerUserDTO = new RegisterUserDTO();
        registerUserDTO.setEmail("test@example.com");
        registerUserDTO.setPassword("password");
        registerUserDTO.setFirstName("John");
        registerUserDTO.setConfirmPassword("password");

        // Performing the request and validating the response
        mockMvc.perform(post("/users/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(new ObjectMapper().writeValueAsString(registerUserDTO)))
                .andExpect(status().isOk());

    }

    @Test
    void testLogin() throws Exception {
        // Mocking the login response
        UserResponseDTO mockedResponse = new UserResponseDTO();
        mockedResponse.setId(1L);
        mockedResponse.setEmail("test@example.com");

        // Mocking the service call
        when(userService.login(any(), any())).thenReturn(mockedResponse);

        // Creating a LoginUserDTO instance for the request body
        LoginUserDTO loginUserDTO = new LoginUserDTO();
        loginUserDTO.setEmail("test@example.com");
        loginUserDTO.setPassword("password");

        // Performing the request and validating the response
        mockMvc.perform(post("/users/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(new ObjectMapper().writeValueAsString(loginUserDTO)))
                .andExpect(status().isOk());

    }

    /*@Test
    void testChangePassword() {
        // Mock data
        ChangePasswordDTO newPasswordUser = new ChangePasswordDTO();
        newPasswordUser.setUserId(1L);  // Set appropriate user ID
        newPasswordUser.setCurrentPassword("oldPassword");
        newPasswordUser.setNewPassword("newPassword");
        newPasswordUser.setConfirmPassword("newPassword");

        long userId = 1L;  // Set the same user ID as in newPasswordUser

        // Mock HttpSession and HttpServletRequest
        HttpSession mockSession = mock(HttpSession.class);
        HttpServletRequest mockRequest = mock(HttpServletRequest.class);

        // Mock session.getAttribute("user_id") to return the userId
       // when(mockSession.getAttribute(UserController.USER_ID)).thenReturn(userId);

        // Mock session.getAttribute("logged") to return true (assuming the user is logged in)
        when(mockSession.getAttribute(UserController.LOGGED)).thenReturn(true);
        when(mockSession.isNew()).thenReturn(false);
        when(mockSession.getAttribute(UserController.LOGGED_FROM)).thenReturn("smth");
        when(mockRequest.getRemoteAddr()).thenReturn("smth");

        // Mock userService.changePassword response
        UserResponseDTO mockedUserResponseDTO = new UserResponseDTO();  // You can customize this based on your needs
        when(userService.changePassword(eq(newPasswordUser), eq(userId))).thenReturn(mockedUserResponseDTO);

        // Execute the method
        ResponseEntity<UserResponseDTO> responseEntity = userController.changePassword(newPasswordUser, mockSession, mockRequest);

        // Verify the results
        assertNotNull(responseEntity);
        assertEquals(HttpStatus.OK, responseEntity.getStatusCode());

        UserResponseDTO returnedDTO = responseEntity.getBody();
        assertNotNull(returnedDTO);
        // You can add more assertions based on your expected response

        // Verify that userService.changePassword was called with the correct arguments
        verify(userService, times(1)).changePassword(eq(newPasswordUser), eq(userId));
    }*/

    @Test
    void testGetUser() {
        // Mock data
        long userId = 1L;  // Set the user ID for testing
        GetUserDTO mockedUserDTO = new GetUserDTO();

        // Mock HttpSession
        HttpSession mockSession = mock(HttpSession.class);

        // Mock validateSession to avoid UnauthorizedException
        when(mockSession.getAttribute(UserController.LOGGED)).thenReturn(true);
        when(mockSession.isNew()).thenReturn(false);

        // Mock userService.getUser response
        when(userService.getUser(userId)).thenReturn(mockedUserDTO);

        // Execute the method
        ResponseEntity<GetUserDTO> responseEntity = userController.getUser(userId, mockSession);

        // Verify the results
        assertNotNull(responseEntity);
        assertEquals(HttpStatus.OK, responseEntity.getStatusCode());

        GetUserDTO returnedDTO = responseEntity.getBody();
        assertNotNull(returnedDTO);


        // Verify that userService.getUser was called with the correct argument
        verify(userService, times(1)).getUser(eq(userId));
    }

}