package com.example.bibliotheca.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.bibliotheca.model.Categorie;

public interface CategorieRepository extends JpaRepository<Categorie, Integer> {
}
