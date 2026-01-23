package com.example.bibliotheca.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.bibliotheca.model.Livre;
import com.example.bibliotheca.repository.LivreRepository;

@Service
public class LivreService {

    @Autowired
    private LivreRepository livreRepository;

    public List<Livre> getAllLivres() {
        return livreRepository.findAll();
    }

    public Optional<Livre> getLivreById(Integer id) {
        return livreRepository.findById(id);
    }

    public Livre addLivre(Livre livre) {
        return livreRepository.save(livre);
    }

    public Livre updateLivre(Integer id, Livre livreDetails) {
        Optional<Livre> livre = livreRepository.findById(id);
        if (livre.isPresent()) {
            livreDetails.setId(id);
            return livreRepository.save(livreDetails);
        }
        return null;
    }

    public void deleteLivre(Integer id) {
        livreRepository.deleteById(id);
    }
}
