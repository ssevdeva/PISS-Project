package com.example.goodreads.controller;

import com.example.goodreads.model.dto.bookDTO.BookResponseDTO;
import com.example.goodreads.model.dto.bookDTO.SearchBookDTO;
import com.example.goodreads.services.BookService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.RequestPostProcessor;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

import java.util.Collections;
import java.util.List;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
class BookControllerTest {

    @Mock
    private BookService bookService;

    @InjectMocks
    private BookController bookController;

    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(bookController).build();
    }

    @Test
    void testSearchBooksByTitle() throws Exception {
        String title = "ExampleTitle";
        int page = 1;
        List<SearchBookDTO> searchResults = Collections.singletonList(new SearchBookDTO());

        MockHttpSession mockSession = new MockHttpSession();;

        when(bookService.searchBooksByTitle(title)).thenReturn(searchResults);

        mockMvc.perform(get("/search/by_title/{title}", title)
                        .session(mockSession).sessionAttr(BookController.LOGGED, true)
                        .param("page", String.valueOf(page))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    void testSearchBooksByAuthor() throws Exception {
        String author = "ExampleAuthor";
        int page = 1;
        List<SearchBookDTO> searchResults = Collections.singletonList(new SearchBookDTO());

        MockHttpSession mockSession = new MockHttpSession();

        when(bookService.searchBooksByAuthor(author)).thenReturn(searchResults);

        mockMvc.perform(get("/search/by_author/{author}", author)
                        .session(mockSession).sessionAttr(BookController.LOGGED, true)
                        .param("page", String.valueOf(page))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    void testSearchBooksByGenre() throws Exception {
        long genreId = 1L;
        int page = 1;
        List<SearchBookDTO> searchResults = Collections.singletonList(new SearchBookDTO());

        MockHttpSession mockSession = new MockHttpSession();

        when(bookService.searchBooksByGenre(genreId)).thenReturn(searchResults);

        mockMvc.perform(get("/search/by_genre/{id}", genreId)
                        .session(mockSession).sessionAttr(BookController.LOGGED, true)
                        .param("page", String.valueOf(page))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    /*@Test
    void testDeleteBook() throws Exception {
        // Arrange
        long bookId = 1L;

        MockHttpSession mockSession = new MockHttpSession();
        mockSession.setAttribute(BookController.USER_ID, 1L);
        MockHttpServletRequest mockRequest = new MockHttpServletRequest();
        mockRequest.setRemoteAddr("alabala");

        when(bookService.deleteBook(bookId, (long) mockSession.getAttribute(BookController.USER_ID)))
                .thenReturn(new BookResponseDTO());

        mockMvc.perform(delete("/books/delete/{id}", bookId)
                        .session(mockSession).sessionAttr(BookController.LOGGED, true)
                        .sessionAttr(BookController.LOGGED_FROM, "alabala")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }*/
}