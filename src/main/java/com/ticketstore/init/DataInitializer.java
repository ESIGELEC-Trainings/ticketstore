package com.ticketstore.init;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

import org.springframework.boot.CommandLineRunner;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import com.ticketstore.entity.Event;
import com.ticketstore.repository.EventRepository;

@Component
public class DataInitializer implements CommandLineRunner {

	private final EventRepository eventRepository;
	private final RedisTemplate<String, String> redisTemplate;

	public DataInitializer(EventRepository eventRepository, RedisTemplate<String, String> redisTemplate) {
		this.eventRepository = eventRepository;
		this.redisTemplate = redisTemplate;
	}

	@Override
	public void run(String... args) throws Exception {
		// Utiliser Redis comme lock distribué pour éviter que les 2 backends initialisent en même temps
		String lockKey = "db:init:lock";
		String lockValue = "locked";
		
		// Essayer d'acquérir le lock (expire après 60 secondes)
		Boolean lockAcquired = redisTemplate.opsForValue().setIfAbsent(lockKey, lockValue, 60, TimeUnit.SECONDS);
		
		if (Boolean.TRUE.equals(lockAcquired)) {
			try {
				if (eventRepository.count() == 0) {
					System.out.println("🔄 Initialisation de la base de données avec 25000 événements...");
					
					String[] eventNames = {
						"Neon Paradise Festival", "Midnight Groove", "Electric Dreams", "Violet Nights", "Bass Revolution",
						"Cyber Rave", "Techno Pulse", "Underground Sessions", "Synth Wave Night", "Digital Beats",
						"Retro Future", "Neon Lights", "Dark Matter", "Crystal Sound", "Laser Show",
						"Electro Shock", "Bass Drop", "Rave Nation", "Club Infinity", "Sound System"
					};
					
					String[] images = {
						"https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800&q=75&fm=webp",
						"https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&q=75&fm=webp",
						"https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&q=75&fm=webp",
						"https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=800&q=75&fm=webp",
						"https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=800&q=75&fm=webp"
					};
					
					// Créer 25000 événements
					for (int i = 1; i <= 10000; i++) {
						String name = eventNames[i % eventNames.length] + " #" + i;
						String description = "Événement électro exceptionnel avec des DJs internationaux. Ambiance garantie !";
						String imageUrl = images[i % images.length];
						LocalDateTime date = LocalDateTime.now().plusDays(i);
						BigDecimal price = new BigDecimal(50 + (i % 100));
						int tickets = 100 + (i * 10);
						
						eventRepository.save(new Event(name, description, imageUrl, date, price, tickets));
					}

					System.out.println("✅ Base de données initialisée avec 25000 événements");
				} else {
					System.out.println("ℹ️  Base de données déjà initialisée, skip");
				}
			} finally {
				// Libérer le lock
				redisTemplate.delete(lockKey);
			}
		} else {
			System.out.println("⏳ Un autre backend est en train d'initialiser la base, attente...");
			// Attendre que l'autre backend finisse
			Thread.sleep(5000);
		}
	}
}
