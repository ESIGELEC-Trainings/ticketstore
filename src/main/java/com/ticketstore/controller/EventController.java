package com.ticketstore.controller;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;


import com.ticketstore.entity.Event;
import com.ticketstore.service.EventService;

@RestController
@RequestMapping("/api/events")
@CrossOrigin
public class EventController {

	private final EventService eventService;

	public EventController(EventService eventService) {
		this.eventService = eventService;
	}

	
	@GetMapping
	public List<Event> getAllEvents(
			@RequestParam(defaultValue = "0")int page,
			@RequestParam(defaultValue ="30")int size ) {
		return eventService.getAllEvents(page,size);
	}

	@GetMapping("/{id}")
	public Optional<Event> getEvent(@PathVariable UUID id) {
		return eventService.getEventDetails(id);
	}
	
	@GetMapping("/count")
	public long getEventsCount() {
		return eventService.getEventsCount();
	}
}
