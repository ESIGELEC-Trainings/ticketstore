package com.ticketstore.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ticketstore.entity.Event;

@Repository
public interface EventRepository extends JpaRepository<Event, UUID> {
}
