package com.example.goodreads.controller;

import com.example.goodreads.model.dto.reviewDTO.ReviewWithUserDTO;
import com.example.goodreads.model.dto.reviewDTO.UserReviewsResponseDTO;
import com.example.goodreads.services.RatingService;
import com.example.goodreads.services.ReviewService;
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

import java.util.Collections;
import java.util.List;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


@ExtendWith(MockitoExtension.class)
public class ReviewControllerTest {
    @Mock
    private ReviewService reviewService;

    @InjectMocks
    private ReviewController reviewController;

    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(reviewController).build();
    }

    @Test
    void testGetBookReviews() throws Exception {
        // Arrange
        long bookId = 1L;
        int page = 1;
        List<ReviewWithUserDTO> reviewResults = Collections.singletonList(new ReviewWithUserDTO());

        MockHttpSession mockSession = new MockHttpSession();

        when(reviewService.getBookReviews(bookId)).thenReturn(reviewResults);

        // Act & Assert
        mockMvc.perform(get("/books/reviews/{id}", bookId)
                        .session(mockSession).sessionAttr(ReviewController.LOGGED, true)
                        .param("page", String.valueOf(page))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    void testGetUserReviews() throws Exception {
        long userId = 1L;
        int page = 1;
        List<UserReviewsResponseDTO> reviewResults = Collections.singletonList(new UserReviewsResponseDTO(/* initialize DTO here */));

        MockHttpSession mockSession = new MockHttpSession();

        when(reviewService.getUserReviews(userId)).thenReturn(reviewResults);

        mockMvc.perform(get("/users/reviews/{id}", userId)
                        .session(mockSession).sessionAttr(ReviewController.LOGGED, true)
                        .param("page", String.valueOf(page))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }
}
