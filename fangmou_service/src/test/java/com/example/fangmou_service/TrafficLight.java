package com.example.fangmou_service;

public enum TrafficLight {
    RED("Stop"),
    YELLOW("Caution"),
    GREEN("Go");

    private final String action;

    TrafficLight(String action) {
        this.action = action;
    }

    @Override
    public String toString() {
        return this.name() + " (" + action + ")";
    }
}
