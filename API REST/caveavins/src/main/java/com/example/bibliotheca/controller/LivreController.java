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

@RestController
@RequestMapping("/api/livres")
public class LivreController {

    @Autowired
    private LivreService livreService;

    @GetMapping
    public List<Livre> getAllLivres() {
        return livreService.getAllLivres();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Livre> getLivreById(@PathVariable Integer id) {
        Optional<Livre> livre = livreService.getLivreById(id);
        return livre.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public Livre createLivre(@RequestBody Livre livre) {
        return livreService.addLivre(livre);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Livre> updateLivre(@PathVariable Integer id, @RequestBody Livre livreDetails) {
        Livre updatedLivre = livreService.updateLivre(id, livreDetails);
        return updatedLivre != null ? ResponseEntity.ok(updatedLivre) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteLivre(@PathVariable Integer id) {
        livreService.deleteLivre(id);
        return ResponseEntity.noContent().build();
    }
}
