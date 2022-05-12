<template>
  <div>
    <div class="hero">
      <div class="hero-body media px-0">
        <div class="media-content">
          <p class="title">Servicios</p>
          <p class="subtitle">Panel general de servicios</p>
        </div>
        <div class="media-right">
          <button class="button is-primary">Nuevo</button>
        </div>
      </div>
    </div>

    <MDropdown :text="'Select a service'">
      <MDropdownItem v-for="service in services" :key="service.id">
        {{ service.name }}
      </MDropdownItem>
    </MDropdown>
  </div>
</template>

<script>
// import Service from '~/backend/maenager/service'
import axios from 'axios'
import MDropdown from '@/components/Dropdown.vue'
import MDropdownItem from '@/components/DropdownItem.vue'

export default {
  name: 'services-index',
  components: {
    MDropdown,
    MDropdownItem
  },
  data() {
    return {
      services: []
    }
  },
  created() {
    this.getServices()
  },
  methods: {
    getServices () {
      axios.get('http://172.29.239.236:3000/api/v1/services')
        .then((result) => {
          this.services = result.data
        })
        .catch((error) => {
          alert(error)
        })
    }
  }
}
</script>
