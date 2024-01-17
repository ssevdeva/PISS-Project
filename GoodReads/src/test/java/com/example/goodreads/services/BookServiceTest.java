package com.example.goodreads.services;

import com.example.goodreads.model.dto.bookDTO.SearchBookDTO;
import com.example.goodreads.model.entities.Book;
import com.example.goodreads.model.entities.Genre;
import com.example.goodreads.model.repository.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class BookServiceTest {

    @Mock
    private BookRepository bookRepository;

    @Mock
    private GenreRepository genreRepository;

    @Mock
    private LanguageRepository languageRepository;

    @Mock
    private AuthorRepository authorRepository;

    @Mock
    private BookshelfRepository bookshelfRepository;

    @Mock
    private UsersBooksRepository usersBooksRepository;

    @Mock
    private ObjectMapper objMapper;

    @InjectMocks
    private BookService bookService;

    @Test
    void testSearchBooksByTitle() {
        // Mocking the bookRepository behavior
        String searchWord = "Test";
        List<Book> mockedBooks = new ArrayList<>();
        // Add some mocked books for testing, including one with null ratings
        mockedBooks.add(Book.builder().bookId(1L).title("Test Book 1").ratings(new HashSet<>()).publishDate(LocalDate.of(2000,10,10)).authors(new HashSet<>()).build());
        mockedBooks.add(Book.builder().bookId(1L).title("Test Book 2").ratings(new HashSet<>()).publishDate(LocalDate.of(2000,10,10)).authors(new HashSet<>()).build());
        when(bookRepository.findBooksByTitleLike("%" + searchWord + "%")).thenReturn(mockedBooks);

        // Invoking the method to test
        List<SearchBookDTO> result = bookService.searchBooksByTitle(searchWord);

        // Verifying the behavior
        assertNotNull(result);
        assertEquals(mockedBooks.size(), result.size());
    }

    @Test
    void testSearchBooksByGenre() {
        // Mocking the genreId
        long genreId = 1L;

        // Mocking the genreRepository behavior
        Genre mockedGenre = Genre.builder().genreId(genreId).genreName("Fiction").build();
        when(genreRepository.findById(genreId)).thenReturn(Optional.of(mockedGenre));

        // Mocking the bookRepository behavior
        List<Book> mockedBooks = new ArrayList<>();
        // Add some mocked books for testing
        mockedBooks.add(Book.builder().bookId(1L).title("Fiction Book 1").ratings(new HashSet<>()).publishDate(LocalDate.of(2000, 10, 10)).authors(new HashSet<>()).genre(mockedGenre).build());
        mockedBooks.add(Book.builder().bookId(2L).title("Fiction Book 2").ratings(new HashSet<>()).publishDate(LocalDate.of(2000, 10, 10)).authors(new HashSet<>()).genre(mockedGenre).build());
        when(bookRepository.findBooksByGenre(mockedGenre)).thenReturn(mockedBooks);

        // Invoking the method to test
        List<SearchBookDTO> result = bookService.searchBooksByGenre(genreId);

        // Verifying the behavior
        assertNotNull(result);
        assertEquals(mockedBooks.size(), result.size());
    }

    @Test
    void testSearchBooksByAuthor() {
        // Mocking the authorName
        String authorName = "John Doe";

        // Mocking the bookRepository behavior
        List<Book> mockedBooks = new ArrayList<>();
        // Add some mocked books for testing
        mockedBooks.add(Book.builder().bookId(1L).title("Book by John Doe 1").ratings(new HashSet<>()).publishDate(LocalDate.of(2000, 10, 10)).authors(new HashSet<>()).build());
        mockedBooks.add(Book.builder().bookId(2L).title("Book by John Doe 2").ratings(new HashSet<>()).publishDate(LocalDate.of(2000, 10, 10)).authors(new HashSet<>()).build());
        when(bookRepository.findBooksByAuthorNameLike("%" + authorName + "%")).thenReturn(mockedBooks);

        // Invoking the method to test
        List<SearchBookDTO> result = bookService.searchBooksByAuthor(authorName);

        // Verifying the behavior
        assertNotNull(result);
        assertEquals(mockedBooks.size(), result.size());
    }
}