package com.example.bibliotheca.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.bibliotheca.model.Auteur;
import com.example.bibliotheca.repository.AuteurRepository;

@Service
public class AuteurService {

    @Autowired
    private AuteurRepository auteurRepository;

    public List<Auteur> getAllAuteurs() {
        return auteurRepository.findAll();
    }

    public Optional<Auteur> getAuteurById(Integer id) {
        return auteurRepository.findById(id);
    }

    public Auteur addAuteur(Auteur auteur) {
        return auteurRepository.save(auteur);
    }

    public Auteur updateAuteur(Integer id, Auteur auteurDetails) {
        Optional<Auteur> auteur = auteurRepository.findById(id);
        if (auteur.isPresent()) {
            auteurDetails.setId(id);
            return auteurRepository.save(auteurDetails);
        }
        return null;
    }

    public void deleteAuteur(Integer id) {
        auteurRepository.deleteById(id);
    }
}
