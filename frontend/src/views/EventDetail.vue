<template>
  <div class="container mx-auto px-4 py-12">
    <!-- Loading State -->
    <div v-if="loading" class="text-center py-20">
      <div class="inline-block animate-spin rounded-full h-16 w-16 border-t-4 border-b-4 border-neon-purple"></div>
      <p class="mt-4 text-gray-400">Chargement...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-20">
      <p class="text-red-400 text-xl">❌ {{ error }}</p>
      <button @click="$router.push('/')" class="mt-4 text-neon-purple hover:underline">
        Retour aux événements
      </button>
    </div>

    <!-- Event Detail -->
    <div v-else-if="event" class="max-w-6xl mx-auto">
      <!-- Back Button -->
      <button 
        @click="$router.push('/')" 
        class="mb-6 text-gray-400 hover:text-neon-purple transition flex items-center space-x-2"
      >
        <span>←</span>
        <span>Retour</span>
      </button>

      <div class="grid md:grid-cols-2 gap-12">
        <!-- Image -->
        <div class="relative rounded-2xl overflow-hidden shadow-neon">
          <!-- Image optimisée -->
          <img 
            :src="event.imageUrl + '&w=800&q=75&fm=webp'"
            :alt="event.title"
            class="w-full h-full object-cover"
            loading="lazy"
          />
        </div>

        <!-- Info -->
        <div>
          <h1 class="text-5xl font-black mb-4">
            <span class="bg-gradient-to-r from-neon-purple to-neon-pink bg-clip-text text-transparent">
              {{ event.title }}
            </span>
          </h1>

          <p class="text-gray-300 text-lg mb-8 leading-relaxed">
            {{ event.description }}
          </p>

          <div class="bg-dark-card rounded-xl p-6 mb-8 border border-neon-purple/20">
            <div class="grid grid-cols-2 gap-6">
              <div>
                <p class="text-sm text-gray-500 mb-1">Date</p>
                <p class="text-xl font-bold">{{ formatDate(event.date) }}</p>
              </div>
              <div>
                <p class="text-sm text-gray-500 mb-1">Prix</p>
                <p class="text-3xl font-bold text-orange-500">{{ event.price }} €</p>
              </div>
              <div class="col-span-2">
                <p class="text-sm text-gray-500 mb-1">Billets disponibles</p>
                <p class="text-2xl font-bold text-green-400">{{ event.ticketsAvailable }}</p>
              </div>
            </div>
          </div>

          <!-- Checkout Form -->
          <div class="bg-dark-card rounded-xl p-6 border border-neon-purple/20">
            <h3 class="text-2xl font-bold mb-4">Réserver vos billets</h3>
            
            <div class="mb-4">
              <label class="block text-sm text-gray-400 mb-2">Nombre de billets</label>
              <input 
                v-model.number="quantity"
                type="number"
                min="1"
                :max="event.ticketsAvailable"
                class="w-full bg-dark-bg border border-neon-purple/30 rounded-lg px-4 py-3 text-white focus:outline-none focus:border-neon-purple"
              />
            </div>

            <div class="mb-6">
              <p class="text-sm text-gray-400">Total</p>
              <p class="text-4xl font-bold text-neon-purple">{{ total }} €</p>
            </div>

            <button 
              @click="checkout"
              :disabled="checkoutLoading || quantity < 1 || quantity > event.ticketsAvailable"
              class="w-full bg-gradient-to-r from-orange-500 to-orange-600 text-white py-4 rounded-lg font-bold text-lg hover:shadow-neon-strong transition disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <span v-if="checkoutLoading">⏳ Traitement...</span>
              <span v-else>🎫 Acheter maintenant</span>
            </button>

            <p v-if="checkoutSuccess" class="mt-4 text-green-400 text-center">
              ✅ Commande réussie !
            </p>
            <p v-if="checkoutError" class="mt-4 text-red-400 text-center">
              ❌ {{ checkoutError }}
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'EventDetail',
  data() {
    return {
      event: null,
      loading: true,
      error: null,
      quantity: 1,
      checkoutLoading: false,
      checkoutSuccess: false,
      checkoutError: null
    }
  },
  computed: {
    total() {
      if (!this.event) return 0
      return (this.event.price * this.quantity).toFixed(2)
    }
  },
  mounted() {
    this.fetchEvent()
  },
  methods: {
    async fetchEvent() {
      try {
        this.loading = true
        const id = this.$route.params.id
        const response = await axios.get(`/api/events/${id}`)
        this.event = response.data
      } catch (err) {
        this.error = 'Impossible de charger cet événement'
        console.error(err)
      } finally {
        this.loading = false
      }
    },
    async checkout() {
      try {
        this.checkoutLoading = true
        this.checkoutSuccess = false
        this.checkoutError = null
        const response = await axios.post('/api/checkout', {
          eventId: this.event.id,
          quantity: this.quantity
        })

        if (response.data) {
          this.checkoutSuccess = true
          await this.fetchEvent()
          this.quantity = 1
        } else {
          this.checkoutError = 'Échec de la commande'
        }
      } catch (err) {
        this.checkoutError = 'Erreur lors du traitement'
        console.error(err)
      } finally {
        this.checkoutLoading = false
      }
    },
    formatDate(dateString) {
      const date = new Date(dateString)
      return date.toLocaleDateString('fr-FR', { 
        weekday: 'long',
        day: 'numeric', 
        month: 'long', 
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      })
    }
  }
}
</script>
