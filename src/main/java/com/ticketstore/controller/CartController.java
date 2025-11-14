package com.ticketstore.controller;

import java.util.Map;
import java.util.UUID;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ticketstore.service.CartService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/cart")
@CrossOrigin
public class CartController {

	private final CartService cartService;

	public CartController(CartService cartService) {
		this.cartService = cartService;
	}

	@GetMapping
	public Map<UUID, Integer> getCart(HttpSession session) {
		return cartService.getCart(session);
	}

	@PostMapping("/add/{eventId}")
	public void addToCart(HttpSession session, @PathVariable UUID eventId) {
		cartService.addToCart(session, eventId);
	}
}
