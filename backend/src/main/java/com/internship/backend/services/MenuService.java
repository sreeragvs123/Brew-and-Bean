package com.internship.backend.services;


import com.internship.backend.dto.MenuItemDto;
import com.internship.backend.entities.MenuItem;
import com.internship.backend.repositories.MenuItemRepository;
import com.internship.backend.utils.CafeMapper;
import com.internship.backend.utils.SseEvents;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class MenuService {

    private final MenuItemRepository menuItemRepository;
    private final EventBroadcaster eventBroadcaster;

    public MenuService(MenuItemRepository menuItemRepository, EventBroadcaster eventBroadcaster) {
        this.menuItemRepository = menuItemRepository;
        this.eventBroadcaster = eventBroadcaster;
    }

    @Transactional(readOnly = true)
    public List<MenuItemDto> getMenu() {
        return menuItemRepository.findAllByOrderByIdAsc().stream()
                .map(CafeMapper::toMenuItemDto)
                .toList();
    }

    @Transactional
    public MenuItemDto setAvailability(Long id, boolean available) {
        MenuItem item = menuItemRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Menu item not found"));

        item.setAvailable(available);
        MenuItemDto dto = CafeMapper.toMenuItemDto(menuItemRepository.save(item));

        eventBroadcaster.publish(SseEvents.MENU, dto);
        return dto;
    }
}
