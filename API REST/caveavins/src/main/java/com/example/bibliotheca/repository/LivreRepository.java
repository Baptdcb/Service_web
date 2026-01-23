package com.example.bibliotheca.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.bibliotheca.model.Livre;

public interface LivreRepository extends JpaRepository<Livre, Integer> {
}
