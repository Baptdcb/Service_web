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

@RestController
@RequestMapping("/api/categories")
public class CategorieController {

    @Autowired
    private CategorieService categorieService;

    @GetMapping
    public List<Categorie> getAllCategories() {
        return categorieService.getAllCategories();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Categorie> getCategorieById(@PathVariable Integer id) {
        Optional<Categorie> categorie = categorieService.getCategorieById(id);
        return categorie.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public Categorie createCategorie(@RequestBody Categorie categorie) {
        return categorieService.addCategorie(categorie);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Categorie> updateCategorie(@PathVariable Integer id, @RequestBody Categorie categorieDetails) {
        Categorie updatedCategorie = categorieService.updateCategorie(id, categorieDetails);
        return updatedCategorie != null ? ResponseEntity.ok(updatedCategorie) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCategorie(@PathVariable Integer id) {
        categorieService.deleteCategorie(id);
        return ResponseEntity.noContent().build();
    }
}
