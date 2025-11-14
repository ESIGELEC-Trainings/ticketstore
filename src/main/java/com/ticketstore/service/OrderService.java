package com.ticketstore.service;

import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ticketstore.entity.Event;
import com.ticketstore.entity.Order;
import com.ticketstore.repository.EventRepository;
import com.ticketstore.repository.OrderRepository;

@Service
public class OrderService {

	private final EventRepository eventRepository;
	private final OrderRepository orderRepository;

	public OrderService(EventRepository eventRepository, OrderRepository orderRepository) {
		this.eventRepository = eventRepository;
		this.orderRepository = orderRepository;
	}

	@Transactional
	public boolean placeOrder(UUID eventId, int quantity) {
		Optional<Event> opt = eventRepository.findById(eventId);
		if (opt.isEmpty()) {
			return false;
		}

		Event event = opt.get();

		if (event.getTicketsAvailable() < quantity) {
			return false;
		}

		event.setTicketsAvailable(event.getTicketsAvailable() - quantity);
		eventRepository.save(event);

		Order order = new Order(event, quantity);
		orderRepository.save(order);

		return true;
	}
}
