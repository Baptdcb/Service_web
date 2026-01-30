package com.example.bibliotheca.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.bibliotheca.model.Categorie;
import com.example.bibliotheca.repository.CategorieRepository;

@Service
public class CategorieService {

    @Autowired
    private CategorieRepository categorieRepository;

    public List<Categorie> getAllCategories() {
        return categorieRepository.findAll();
    }

    public Optional<Categorie> getCategorieById(Integer id) {
        return categorieRepository.findById(id);
    }

    public Categorie addCategorie(Categorie categorie) {
        return categorieRepository.save(categorie);
    }

    public Categorie updateCategorie(Integer id, Categorie categorieDetails) {
        Optional<Categorie> categorie = categorieRepository.findById(id);
        if (categorie.isPresent()) {
            categorieDetails.setId(id);
            return categorieRepository.save(categorieDetails);
        }
        return null;
    }

    public void deleteCategorie(Integer id) {
        categorieRepository.deleteById(id);
    }
}
