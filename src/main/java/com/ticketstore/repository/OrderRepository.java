package com.ticketstore.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ticketstore.entity.Order;

public interface OrderRepository extends JpaRepository<Order, UUID> {
}
