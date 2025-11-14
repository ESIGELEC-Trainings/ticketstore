package com.ticketstore.service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.ticketstore.entity.Event;
import com.ticketstore.repository.EventRepository;

@Service
public class EventService {

	private final EventRepository eventRepository;

	public EventService(EventRepository eventRepository) {
		this.eventRepository = eventRepository;
	}

	public List<Event> getAllEvents() {
		List<Event> events = eventRepository.findAll();
		events.forEach(e -> e.getTitle());
		return events;
	}

	public Optional<Event> getEventDetails(UUID id) {
		try {
			Thread.sleep(800 + (long) (Math.random() * 1200)); 
		} catch (InterruptedException ignored) {
		}

		return eventRepository.findById(id);
	}

	public void updateTickets(Event event, int change) {
		event.setTicketsAvailable(event.getTicketsAvailable() - change);
		eventRepository.save(event);
	}
	
	public long getEventsCount() {
		return eventRepository.count();
	}
}
