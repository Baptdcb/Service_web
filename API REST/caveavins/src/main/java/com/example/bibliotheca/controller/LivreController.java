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

import com.example.bibliotheca.model.Livre;
import com.example.bibliotheca.service.LivreService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

@RestController
@RequestMapping("/api/livres")
@Tag(name = "Livres", description = "API de gestion des livres")
public class LivreController {

    @Autowired
    private LivreService livreService;

    @GetMapping
    @Operation(summary = "Récupérer tous les livres", description = "Retourne la liste complète des livres")
    @ApiResponse(responseCode = "200", description = "Liste des livres récupérée avec succès")
    public List<Livre> getAllLivres() {
        return livreService.getAllLivres();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Récupérer un livre par ID", description = "Retourne un livre spécifique en fonction de son ID")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Livre trouvé"),
        @ApiResponse(responseCode = "404", description = "Livre non trouvé")
    })
    public ResponseEntity<Livre> getLivreById(@PathVariable Integer id) {
        Optional<Livre> livre = livreService.getLivreById(id);
        return livre.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    @Operation(summary = "Créer un nouveau livre", description = "Ajoute un nouveau livre à la base de données")
    @ApiResponse(responseCode = "200", description = "Livre créé avec succès")
    public Livre createLivre(@RequestBody Livre livre) {
        return livreService.addLivre(livre);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Mettre à jour un livre", description = "Modifie les informations d'un livre existant")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Livre mis à jour avec succès"),
        @ApiResponse(responseCode = "404", description = "Livre non trouvé")
    })
    public ResponseEntity<Livre> updateLivre(@PathVariable Integer id, @RequestBody Livre livreDetails) {
        Livre updatedLivre = livreService.updateLivre(id, livreDetails);
        return updatedLivre != null ? ResponseEntity.ok(updatedLivre) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Supprimer un livre", description = "Supprime un livre de la base de données")
    @ApiResponse(responseCode = "204", description = "Livre supprimé avec succès")
    public ResponseEntity<Void> deleteLivre(@PathVariable Integer id) {
        livreService.deleteLivre(id);
        return ResponseEntity.noContent().build();
    }
}
