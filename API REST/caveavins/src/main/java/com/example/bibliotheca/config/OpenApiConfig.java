package com.example.bibliotheca.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("API Bibliotheca")
                .version("1.0.0")
                .description("Documentation complète de l'API Bibliotheca pour la gestion de livres, auteurs et catégories")
                .contact(new Contact()
                    .name("Équipe Bibliotheca")
                    .email("support@bibliotheca.local")
                )
                .license(new License()
                    .name("MIT License")
                    .url("https://opensource.org/licenses/MIT")
                )
            );
    }
}
