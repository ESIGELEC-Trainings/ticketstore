import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// Métriques personnalisées
const errorRate = new Rate('errors');

// Configuration des scénarios de test
export const options = {
  stages: [
    { duration: '30s', target: 10 },   // Montée progressive
    { duration: '1m', target: 50 },    // Charge normale
    { duration: '30s', target: 100 },  // Pic de charge
    { duration: '1m', target: 100 },   // Maintien du pic
    { duration: '30s', target: 0 },    // Descente
  ],
  thresholds: {
    http_req_duration: ['p(95)<2000'], // 95% des requêtes < 2s
    errors: ['rate<0.1'],              // Moins de 10% d'erreurs
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:8080';

export default function () {
  // Test 1: Liste des événements (N+1 query problem)
  let listResponse = http.get(`${BASE_URL}/api/events`);
  check(listResponse, {
    'list status is 200': (r) => r.status === 200,
    'list response time < 1s': (r) => r.timings.duration < 1000,
  }) || errorRate.add(1);

  sleep(1);

  // Test 2: Détail d'un événement (latence artificielle)
  if (listResponse.status === 200) {
    const events = JSON.parse(listResponse.body);
    if (events.length > 0) {
      const eventId = events[0].id;
      let detailResponse = http.get(`${BASE_URL}/api/events/${eventId}`);
      check(detailResponse, {
        'detail status is 200': (r) => r.status === 200,
        'detail response time < 2s': (r) => r.timings.duration < 2000,
      }) || errorRate.add(1);
    }
  }

  sleep(2);

  // Test 3: Checkout (Thread.sleep problem)
  if (listResponse.status === 200) {
    const events = JSON.parse(listResponse.body);
    if (events.length > 0) {
      const eventId = events[0].id;
      const payload = JSON.stringify({
        eventId: eventId,
        quantity: 1,
      });

      let checkoutResponse = http.post(
        `${BASE_URL}/api/checkout`,
        payload,
        {
          headers: { 'Content-Type': 'application/json' },
        }
      );

      check(checkoutResponse, {
        'checkout status is 200': (r) => r.status === 200,
        'checkout response time < 3s': (r) => r.timings.duration < 3000,
      }) || errorRate.add(1);
    }
  }

  sleep(3);
}

// Scénario de vente flash (stress test)
export function flashSale() {
  const eventId = 'YOUR_EVENT_ID'; // À remplacer
  const payload = JSON.stringify({
    eventId: eventId,
    quantity: 1,
  });

  let response = http.post(
    `${BASE_URL}/api/checkout`,
    payload,
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );

  check(response, {
    'flash sale success': (r) => r.status === 200,
  });
}
