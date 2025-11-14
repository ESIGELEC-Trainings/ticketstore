<template>
  <div>
    <!-- Hero Section avec image de concert -->
    <section class="relative h-[70vh] overflow-hidden purple-overlay">
      <img 
        src="https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=2400&q=100"
        alt="Concert"
        class="absolute inset-0 w-full h-full object-cover"
      />
      <div class="absolute inset-0 bg-gradient-to-b from-transparent via-dark-bg/50 to-dark-bg"></div>
      
      <div class="relative container mx-auto px-4 h-full flex flex-col justify-center items-center text-center">
        <h1 class="text-6xl md:text-8xl font-black mb-6 animate-glow">
          <span class="bg-gradient-to-r from-neon-purple via-neon-pink to-neon-violet bg-clip-text text-transparent">
            LIVE THE MOMENT
          </span>
        </h1>
        <p class="text-xl md:text-2xl text-gray-300 mb-8 max-w-2xl">
          Découvrez les événements les plus attendus de l'année
        </p>
        <button class="bg-gradient-to-r from-orange-500 to-orange-600 text-white px-8 py-4 rounded-full text-lg font-bold hover:shadow-neon-strong transition transform hover:scale-105">
          Explorez maintenant
        </button>
      </div>
    </section>

    <!-- Events Grid -->
    <section class="container mx-auto px-4 py-16">
      <div class="text-center mb-8">
        <div class="inline-block bg-gradient-to-r from-neon-purple to-neon-pink p-4 rounded-2xl shadow-neon">
          <p class="text-white text-lg font-bold">
            📊 Total événements en base : <span class="text-3xl">{{ totalEvents }}</span>
          </p>
        </div>
      </div>
      
      <h2 class="text-4xl font-bold mb-12 text-center">
        <span class="bg-gradient-to-r from-neon-purple to-neon-pink bg-clip-text text-transparent">
          Événements à venir
        </span>
      </h2>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-20">
        <div class="inline-block animate-spin rounded-full h-16 w-16 border-t-4 border-b-4 border-neon-purple"></div>
        <p class="mt-4 text-gray-400">Chargement des événements...</p>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="text-center py-20">
        <p class="text-red-400 text-xl">❌ {{ error }}</p>
      </div>

      <!-- Events Grid -->
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div 
          v-for="event in events" 
          :key="event.id"
          class="bg-dark-card rounded-2xl overflow-hidden hover-neon cursor-pointer fade-in"
          @click="goToEvent(event.id)"
        >
          <!-- Images optimisées -->
          <div class="relative h-64 overflow-hidden">
            <img 
              :src="event.imageUrl + '&w=600&q=75&fm=webp'"
              :alt="event.title"
              class="w-full h-full object-cover"
              loading="lazy"
            />
            <div class="absolute inset-0 bg-gradient-to-t from-dark-card to-transparent"></div>
          </div>

          <div class="p-6">
            <h3 class="text-2xl font-bold mb-2 text-neon-purple">{{ event.title }}</h3>
            <p class="text-gray-400 mb-4 line-clamp-2">{{ event.description }}</p>
            
            <div class="flex justify-between items-center">
              <div>
                <p class="text-sm text-gray-500">{{ formatDate(event.date) }}</p>
                <p class="text-2xl font-bold text-orange-500">{{ event.price }} €</p>
              </div>
              <div class="text-right">
                <p class="text-sm text-gray-500">Disponibles</p>
                <p class="text-xl font-bold text-green-400">{{ event.ticketsAvailable }}</p>
              </div>
            </div>

            <button class="w-full mt-4 bg-gradient-to-r from-orange-500 to-orange-600 text-white py-3 rounded-lg font-bold hover:shadow-neon transition">
              Acheter
            </button>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'EventList',
  data() {
    return {
      events: [],
      totalEvents: 0,
      loading: true,
      error: null
    }
  },
  mounted() {
    this.fetchEvents()
    this.fetchEventsCount()
  },
  methods: {
    async fetchEvents() {
      try {
        this.loading = true
        const response = await axios.get('/api/events')
        this.events = response.data
      } catch (err) {
        this.error = 'Impossible de charger les événements'
        console.error(err)
      } finally {
        this.loading = false
      }
    },
    async fetchEventsCount() {
      try {
        const response = await axios.get('/api/events/count')
        this.totalEvents = response.data
      } catch (err) {
        console.error('Erreur lors du chargement du compteur:', err)
      }
    },
    formatDate(dateString) {
      const date = new Date(dateString)
      return date.toLocaleDateString('fr-FR', { 
        day: 'numeric', 
        month: 'long', 
        year: 'numeric' 
      })
    },
    goToEvent(id) {
      this.$router.push(`/event/${id}`)
    }
  }
}
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
