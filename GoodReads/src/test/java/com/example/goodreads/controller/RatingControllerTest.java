package com.example.goodreads.controller;

import com.example.goodreads.model.dto.ratingDTO.RatingWithUserDTO;
import com.example.goodreads.model.dto.ratingDTO.UserRatingsResponseDTO;
import com.example.goodreads.services.BookService;
import com.example.goodreads.services.RatingService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;


import java.util.Collections;
import java.util.List;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
public class RatingControllerTest {
    @Mock
    private RatingService ratingService;

    @InjectMocks
    private RatingController ratingController;

    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(ratingController).build();
    }

    @Test
    void testGetBookRatings() throws Exception {
        long bookId = 1L;
        int page = 1;
        List<RatingWithUserDTO> ratingResults = Collections.singletonList(new RatingWithUserDTO());

        MockHttpSession mockSession = new MockHttpSession();

        when(ratingService.getBookRatings(bookId)).thenReturn(ratingResults);

        mockMvc.perform(get("/books/ratings/{id}", bookId)
                        .session(mockSession).sessionAttr(BookController.LOGGED, true)
                        .param("page", String.valueOf(page))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    void testGetUserRatings() throws Exception {
        long userId = 1L;
        int page = 1;
        List<UserRatingsResponseDTO> ratingResults = Collections.singletonList(new UserRatingsResponseDTO());

        MockHttpSession mockSession = new MockHttpSession();

        when(ratingService.getUserRatings(userId)).thenReturn(ratingResults);

        mockMvc.perform(get("/users/ratings/{id}", userId)
                        .session(mockSession).sessionAttr(UserController.LOGGED, true)
                        .param("page", String.valueOf(page))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }
}
