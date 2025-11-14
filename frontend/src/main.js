import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import EventList from './views/EventList.vue'
import EventDetail from './views/EventDetail.vue'
import './style.css'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: EventList },
    { path: '/event/:id', component: EventDetail }
  ]
})

createApp(App)
  .use(router)
  .mount('#app')
