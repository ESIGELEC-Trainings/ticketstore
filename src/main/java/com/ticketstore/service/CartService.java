package com.ticketstore.service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.ticketstore.repository.EventRepository;

import jakarta.servlet.http.HttpSession;

@Service
public class CartService {

	private final EventRepository eventRepository;

	public CartService(EventRepository eventRepository) {
		this.eventRepository = eventRepository;
	}

	@SuppressWarnings("unchecked")
	public Map<UUID, Integer> getCart(HttpSession session) {
		Map<UUID, Integer> cart = (Map<UUID, Integer>) session.getAttribute("CART");
		if (cart == null) {
			cart = new HashMap<>();
			session.setAttribute("CART", cart);
		}
		return cart;
	}

	public void addToCart(HttpSession session, UUID eventId) {
		Map<UUID, Integer> cart = getCart(session);
		cart.put(eventId, cart.getOrDefault(eventId, 0) + 1);
	}
}
