package com.example.bibliotheca.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import jakarta.validation.Valid;

import com.example.bibliotheca.model.Auteur;
import com.example.bibliotheca.service.AuteurService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

@RestController
@RequestMapping("/api/auteurs")
@Tag(name = "Auteurs", description = "API de gestion des auteurs")
public class AuteurController {

    @Autowired
    private AuteurService auteurService;

    @GetMapping
    @Operation(summary = "Récupérer tous les auteurs", description = "Retourne la liste complète des auteurs")
    @ApiResponse(responseCode = "200", description = "Liste des auteurs récupérée avec succès")
    public List<Auteur> getAllAuteurs() {
        return auteurService.getAllAuteurs();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Récupérer un auteur par ID", description = "Retourne un auteur spécifique en fonction de son ID")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Auteur trouvé"),
        @ApiResponse(responseCode = "404", description = "Auteur non trouvé")
    })
    public ResponseEntity<Auteur> getAuteurById(@PathVariable Integer id) {
        Optional<Auteur> auteur = auteurService.getAuteurById(id);
        return auteur.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    @Operation(summary = "Créer un nouvel auteur", description = "Ajoute un nouveau auteur à la base de données")
    @ApiResponse(responseCode = "200", description = "Auteur créé avec succès")
    public Auteur createAuteur(@Valid @RequestBody Auteur auteur) {
        return auteurService.addAuteur(auteur);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Mettre à jour un auteur", description = "Modifie les informations d'un auteur existant")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Auteur mis à jour avec succès"),
        @ApiResponse(responseCode = "404", description = "Auteur non trouvé")
    })
    public ResponseEntity<Auteur> updateAuteur(@PathVariable Integer id, @Valid @RequestBody Auteur auteurDetails) {
        Auteur updatedAuteur = auteurService.updateAuteur(id, auteurDetails);
        return updatedAuteur != null ? ResponseEntity.ok(updatedAuteur) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Supprimer un auteur", description = "Supprime un auteur de la base de données")
    @ApiResponse(responseCode = "204", description = "Auteur supprimé avec succès")
    public ResponseEntity<Void> deleteAuteur(@PathVariable Integer id) {
        auteurService.deleteAuteur(id);
        return ResponseEntity.noContent().build();
    }
}
