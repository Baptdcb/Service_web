package com.example.bibliotheca.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import io.swagger.v3.oas.annotations.media.Schema;

@Entity
@Schema(description = "Modèle représentant un Livre")
public class Livre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Schema(description = "ID unique du livre", example = "1")
    private Integer id;
    
    @Schema(description = "Titre du livre", example = "Les Misérables")
    private String libelle;
    
    @Schema(description = "Description du livre", example = "Un chef-d'œuvre de Victor Hugo")
    private String description;

    @ManyToOne
    @JoinColumn(name = "auteur_id", nullable = false)
    @Schema(description = "Auteur du livre")
    private Auteur auteur;

    @ManyToOne
    @JoinColumn(name = "categorie_id", nullable = false)
    @Schema(description = "Catégorie du livre")
    private Categorie categorie;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Auteur getAuteur() {
        return auteur;
    }

    public void setAuteur(Auteur auteur) {
        this.auteur = auteur;
    }

    public Categorie getCategorie() {
        return categorie;
    }

    public void setCategorie(Categorie categorie) {
        this.categorie = categorie;
    }
}
