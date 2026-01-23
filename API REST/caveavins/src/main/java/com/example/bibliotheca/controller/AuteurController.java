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

@RestController
@RequestMapping("/api/auteurs")
public class AuteurController {

    @Autowired
    private AuteurService auteurService;

    @GetMapping
    public List<Auteur> getAllAuteurs() {
        return auteurService.getAllAuteurs();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Auteur> getAuteurById(@PathVariable Integer id) {
        Optional<Auteur> auteur = auteurService.getAuteurById(id);
        return auteur.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public Auteur createAuteur(@Valid @RequestBody Auteur auteur) {
        return auteurService.addAuteur(auteur);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Auteur> updateAuteur(@PathVariable Integer id, @Valid @RequestBody Auteur auteurDetails) {
        Auteur updatedAuteur = auteurService.updateAuteur(id, auteurDetails);
        return updatedAuteur != null ? ResponseEntity.ok(updatedAuteur) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAuteur(@PathVariable Integer id) {
        auteurService.deleteAuteur(id);
        return ResponseEntity.noContent().build();
    }
}
