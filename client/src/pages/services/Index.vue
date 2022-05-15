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

    <div class="modal is-active">
      <div class="modal-background"></div>
      <div class="modal-card">
        <section class="modal-card-body">
          <p class="title is-4">Nuevo servicio</p>
          <div class="field">
            <label class="label">Nombre</label>
            <div class="control">
              <input v-model="form.name" class="input" type="text" placeholder="Text input">
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-primary" @click="submitService">
            Guardar
          </button>
        </footer>
      </div>
      <button class="modal-close is-large" aria-label="close"></button>
    </div>

    <MDropdown :text="'Select a service'">
      <MDropdownItem v-for="service in services" :key="service.id">
        {{ service.name }}
      </MDropdownItem>
    </MDropdown>
  </div>
</template>

<script>
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
      services: [],
      form: {
        name: ""
      }
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
    },
    submitService () {
      axios.post('http://172.29.239.236:3000/api/v1/services', this.form)
        .then((result) => {
          this.services.push(result.data)
        })
        .catch((error) => {
          alert(error)
        })
    }
  }
}
</script>
