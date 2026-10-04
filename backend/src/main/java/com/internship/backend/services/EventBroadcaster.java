package com.internship.backend.services;

import com.internship.backend.utils.SseEvents;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

/** Keeps every open app connection and pushes events to all of them. */
@Service
public class EventBroadcaster {

    private final List<SseEmitter> emitters = new CopyOnWriteArrayList<>();

    /** Called when an app opens the stream. */
    public SseEmitter subscribe() {
        SseEmitter emitter = new SseEmitter(0L); // 0 = never time out
        emitters.add(emitter);
        emitter.onCompletion(() -> emitters.remove(emitter));
        emitter.onTimeout(() -> emitters.remove(emitter));
        emitter.onError(error -> emitters.remove(emitter));

        // Tells the app the connection is live so it can sync its data.
        send(emitter, SseEvents.CONNECTED, Map.of("status", "connected"));
        return emitter;
    }

    /** Pushes one event to every connected app. */
    public void publish(String eventName, Object payload) {
        for (SseEmitter emitter : emitters) {
            send(emitter, eventName, payload);
        }
    }

    /** Keeps idle connections open; the app treats long silence as a dead connection. */
    @Scheduled(fixedRate = 25_000)
    public void sendHeartbeat() {
        for (SseEmitter emitter : emitters) {
            try {
                emitter.send(SseEmitter.event().comment("ping"));
            } catch (Exception e) {
                emitters.remove(emitter);
            }
        }
    }

    private void send(SseEmitter emitter, String eventName, Object payload) {
        try {
            emitter.send(SseEmitter.event()
                    .name(eventName)
                    .data(payload, MediaType.APPLICATION_JSON));
        } catch (Exception e) {
            emitters.remove(emitter);
        }
    }
}
