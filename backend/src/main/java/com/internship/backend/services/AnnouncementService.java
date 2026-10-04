package com.internship.backend.services;


import com.internship.backend.dto.AnnouncementDto;
import com.internship.backend.utils.SseEvents;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AnnouncementService {

    private final EventBroadcaster eventBroadcaster;

    public AnnouncementService(EventBroadcaster eventBroadcaster) {
        this.eventBroadcaster = eventBroadcaster;
    }

    public void announce(AnnouncementDto announcement) {
        String message = announcement.getMessage();
        if (message == null || message.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Message is required");
        }
        eventBroadcaster.publish(SseEvents.ANNOUNCEMENT, new AnnouncementDto(message.trim()));
    }
}
