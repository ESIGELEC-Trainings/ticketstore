package com.ticketstore.service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.ticketstore.entity.Event;
import com.ticketstore.repository.EventRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.cache.annotation.Cacheable; 

@Service
public class EventService {

	private final EventRepository eventRepository;

	public EventService(EventRepository eventRepository) {
		this.eventRepository = eventRepository;
	}

	@Cacheable(value = "events", key = "#page + '-' + #size")
	public List<Event> getAllEvents(int page, int size) {
    Pageable pageable = PageRequest.of(page, size);
    return eventRepository.findAll(pageable).getContent();
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
