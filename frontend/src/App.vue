<template>
  <div class="min-h-screen bg-dark-bg">
    <!-- Header -->
    <header class="bg-dark-card border-b border-neon-purple/20 sticky top-0 z-50 backdrop-blur-lg bg-opacity-90">
      <div class="container mx-auto px-4 py-4">
        <div class="flex items-center justify-between">
          <router-link to="/" class="flex items-center space-x-3">
            <div class="w-10 h-10 bg-gradient-to-br from-neon-purple to-neon-pink rounded-lg flex items-center justify-center">
              <span class="text-2xl">🎫</span>
            </div>
            <h1 class="text-2xl font-bold bg-gradient-to-r from-neon-purple to-neon-pink bg-clip-text text-transparent">
              TicketStore Premium
            </h1>
          </router-link>
          
          <nav class="hidden md:flex space-x-6">
            <router-link to="/" class="text-gray-300 hover:text-neon-purple transition">Événements</router-link>
            <a href="#" class="text-gray-300 hover:text-neon-purple transition">Mon compte</a>
          </nav>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main>
      <router-view />
    </main>

    <!-- Footer -->
    <footer class="bg-dark-card border-t border-neon-purple/20 mt-20">
      <div class="container mx-auto px-4 py-8 text-center text-gray-400">
        <p>© 2024 TicketStore Premium - Projet pédagogique sur la performance applicative</p>
        <p class="text-sm mt-2">🎯 Optimisez, Scalez, Résilience</p>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>
