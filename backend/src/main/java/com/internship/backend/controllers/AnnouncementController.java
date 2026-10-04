package com.internship.backend.controllers;

import com.internship.backend.dto.AnnouncementDto;
import com.internship.backend.services.AnnouncementService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/announcements")
public class AnnouncementController {

    private final AnnouncementService announcementService;


    @PostMapping
    public void announce(@RequestBody AnnouncementDto announcement) {
        announcementService.announce(announcement);
    }
}
