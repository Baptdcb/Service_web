package com.example.bibliotheca.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.bibliotheca.model.Auteur;

public interface AuteurRepository extends JpaRepository<Auteur, Integer> {
}
