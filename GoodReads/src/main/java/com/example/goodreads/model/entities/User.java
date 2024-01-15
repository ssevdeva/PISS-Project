package com.example.goodreads.model.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.*;
import javax.persistence.*;
import java.time.LocalDate;
import java.util.Set;

@Getter
@Setter
@Builder
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "users")
public class User {

    public enum Gender{
        MALE('m'), FEMALE('f'), CUSTOM('c'), NONE('n');

        public final char symbol;
        Gender(char symbol){
            this.symbol = symbol;
        }

        public static boolean isValidGender(char symbol) {
            return (symbol == NONE.symbol ||
                    symbol == MALE.symbol ||
                    symbol == FEMALE.symbol ||
                    symbol == CUSTOM.symbol);
        }
    }

    @EqualsAndHashCode.Include
    @Id
    @Column(name = "user_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long userId;

    @Column
    private Boolean isAdmin;

    @Column
    private String email;

    @Column
    private String firstName;

    @Column
    private String lastName;

    @Column
    @JsonIgnore
    private String password;

    @Column
    private String photoUrl;

    @Column
    private char gender;

    @Column
    private String username;

    @Column
    private LocalDate dateOfBirth;

    @Column
    private String booksPreferences;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<Review> reviews;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<Quote> quotes;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<Rating> ratings;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<UsersBooks> books;

    @ManyToMany
    @JoinTable(
            name = "users_like_genres",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "genre_id"))
    private Set<Genre> favoriteGenres;

    @ManyToMany
    @JoinTable(
            name = "users_like_quotes",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "quote_id"))
    private Set<Quote> favoriteQuotes;

}
