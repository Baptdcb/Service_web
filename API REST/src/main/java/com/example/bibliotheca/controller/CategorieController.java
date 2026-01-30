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

import com.example.bibliotheca.model.Categorie;
import com.example.bibliotheca.service.CategorieService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

@RestController
@RequestMapping("/api/categories")
@Tag(name = "Catégories", description = "API de gestion des catégories")
public class CategorieController {

    @Autowired
    private CategorieService categorieService;

    @GetMapping
    @Operation(summary = "Récupérer toutes les catégories", description = "Retourne la liste complète des catégories")
    @ApiResponse(responseCode = "200", description = "Liste des catégories récupérée avec succès")
    public List<Categorie> getAllCategories() {
        return categorieService.getAllCategories();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Récupérer une catégorie par ID", description = "Retourne une catégorie spécifique en fonction de son ID")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Catégorie trouvée"),
        @ApiResponse(responseCode = "404", description = "Catégorie non trouvée")
    })
    public ResponseEntity<Categorie> getCategorieById(@PathVariable Integer id) {
        Optional<Categorie> categorie = categorieService.getCategorieById(id);
        return categorie.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    @Operation(summary = "Créer une nouvelle catégorie", description = "Ajoute une nouvelle catégorie à la base de données")
    @ApiResponse(responseCode = "200", description = "Catégorie créée avec succès")
    public Categorie createCategorie(@RequestBody Categorie categorie) {
        return categorieService.addCategorie(categorie);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Mettre à jour une catégorie", description = "Modifie les informations d'une catégorie existante")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Catégorie mise à jour avec succès"),
        @ApiResponse(responseCode = "404", description = "Catégorie non trouvée")
    })
    public ResponseEntity<Categorie> updateCategorie(@PathVariable Integer id, @RequestBody Categorie categorieDetails) {
        Categorie updatedCategorie = categorieService.updateCategorie(id, categorieDetails);
        return updatedCategorie != null ? ResponseEntity.ok(updatedCategorie) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Supprimer une catégorie", description = "Supprime une catégorie de la base de données")
    @ApiResponse(responseCode = "204", description = "Catégorie supprimée avec succès")
    public ResponseEntity<Void> deleteCategorie(@PathVariable Integer id) {
        categorieService.deleteCategorie(id);
        return ResponseEntity.noContent().build();
    }
}
