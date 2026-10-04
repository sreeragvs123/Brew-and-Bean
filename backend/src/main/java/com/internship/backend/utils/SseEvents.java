package com.internship.backend.utils;

/** Names of the events sent over the SSE stream. The Flutter app listens for the same names. */
public final class SseEvents {

    public static final String CONNECTED = "connected";
    public static final String MENU = "menu";
    public static final String ORDER = "order";
    public static final String ANNOUNCEMENT = "announcement";

    private SseEvents() {
    }
}
