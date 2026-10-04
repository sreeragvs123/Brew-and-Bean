package com.internship.backend.controllers;

import com.internship.backend.dto.MenuItemDto;
import com.internship.backend.services.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/menu")
public class MenuController {

    private final MenuService menuService;


    @GetMapping
    public List<MenuItemDto> getMenu() {
        return menuService.getMenu();
    }

    @PatchMapping("/{id}/availability")
    public MenuItemDto setAvailability(@PathVariable Long id, @RequestParam boolean available) {
        return menuService.setAvailability(id, available);
    }
}
