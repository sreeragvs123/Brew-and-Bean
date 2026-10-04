package com.internship.backend.configs;


import com.internship.backend.entities.MenuItem;
import com.internship.backend.repositories.MenuItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

/** Fills the menu the first time the server starts. */
@Component
@RequiredArgsConstructor
public class DataSeeder implements CommandLineRunner {

    private final MenuItemRepository menuItemRepository;



    @Override
    public void run(String... args) {
        if (menuItemRepository.count() > 0) {
            return;
        }
        menuItemRepository.saveAll(List.of(
                new MenuItem("Espresso", "Coffee", 120, true),
                new MenuItem("Cappuccino", "Coffee", 160, true),
                new MenuItem("Cold Brew", "Coffee", 190, true),
                new MenuItem("Masala Chai", "Tea", 80, true),
                new MenuItem("Blueberry Muffin", "Bakery", 110, true),
                new MenuItem("Croissant", "Bakery", 130, true),
                new MenuItem("Veg Sandwich", "Snacks", 150, true)
        ));
    }
}
