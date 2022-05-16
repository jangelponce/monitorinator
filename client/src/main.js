import { createApp } from 'vue'
import App from './App.vue'
import router from '@/plugins/router'
import server from '@/plugins/server'
import FontAwesomeIcon from "@/plugins/fontawesome";

import './assets/main.scss'

const app = createApp(App)
  .use(router)
  .use(server)
  .component('font-awesome-icon', FontAwesomeIcon)

app.mount('#app')