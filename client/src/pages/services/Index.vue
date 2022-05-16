<template>
  <div>
    <div class="hero">
      <div class="hero-body media px-0">
        <div class="media-content">
          <p class="title">Servicios</p>
          <p class="subtitle">Panel general de servicios</p>
        </div>
        <div class="media-right">
          <button class="button is-primary" @click="openModal = true">Nuevo</button>
        </div>
      </div>
    </div>

    <MModal :is-active="openModal" @close="openModal = false">
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
    </MModal>

    <MDropdown :text="'Selecciona un servicio'" class="mr-4">
      <MDropdownItem v-for="service in services" :key="service.id" @click="selectedService = service">
        {{ service.name }}
      </MDropdownItem>
    </MDropdown>

    <MDropdown :text="'Selecciona una semana'">
      <MDropdownItem v-for="(week, i) in weeks" :key="i" @click="selectedWeek = week">
        Semana {{ i + 1 }}
      </MDropdownItem>
    </MDropdown>

    <MServiceDashboard v-if="selectedService.id" :service="selectedService" :week="selectedWeek"></MServiceDashboard>
  </div>
</template>

<script>
import axios from 'axios'
import MDropdown from '@/components/Dropdown.vue'
import MDropdownItem from '@/components/DropdownItem.vue'
import MModal from '@/components/Modal.vue'
import MServiceDashboard from '@/components/ServiceDashboard.vue'

export default {
  name: 'services-index',
  components: {
    MDropdown,
    MDropdownItem,
    MModal,
    MServiceDashboard,
  },
  data() {
    return {
      openModal: false,
      selectedService: {
        weeks: []
      },
      selectedWeek: null,
      services: [],
      form: {
        name: ""
      }
    }
  },
  computed: {
    weeks() {
      console.log()
      return this.selectedService.weeks
    }
  },
  created() {
    this.getServices()
  },
  methods: {
    getServices () {
      axios.get('http://192.168.70.214:3000/api/v1/services')
        .then((result) => {
          this.services = result.data
        })
        .catch((error) => {
          alert(error)
        })
    },
    getWeeks () {
      axios.get(`http://192.168.70.214:3000/api/v1/services/${this.selectedService.id}/weeks`)
        .then((result) => {
          this.selectedService.weeks = result.data
          this.openModal = false
        })
        .catch((error) => {
          alert(error)
        })
    },
    submitService () {
      axios.post('http://192.168.70.214:3000/api/v1/services', this.form)
        .then((result) => {
          this.services.push(result.data)
          this.openModal = false
        })
        .catch((error) => {
          alert(error)
        })
    }
  },
  watch: {
    selectedService() {
      this.getWeeks()
    }
  }
}
</script>
