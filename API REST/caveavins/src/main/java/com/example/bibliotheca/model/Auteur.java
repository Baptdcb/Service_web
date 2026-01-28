package com.example.bibliotheca.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Column;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import io.swagger.v3.oas.annotations.media.Schema;

@Entity
@Schema(description = "Modèle représentant un Auteur")
public class Auteur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Schema(description = "ID unique de l'auteur", example = "1")
    private Integer id;
    
    @NotBlank
    @Column(nullable = false)
    @Schema(description = "Nom de l'auteur", example = "Hugo")
    private String nom;

    @NotBlank
    @Column(nullable = false)
    @Schema(description = "Prénom de l'auteur", example = "Victor")
    private String prenom;

    @Email(message = "mail doit être une adresse valide")
    @Schema(description = "Email de l'auteur", example = "victor.hugo@example.com")
    private String mail;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getMail() {
        return mail;
    }

    public void setMail(String mail) {
        this.mail = mail;
    }
}
