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

    <MDropdown 
      v-model="isServiceDropdownActive"
      :text="selectedService.name || 'Selecciona un servicio'"
      class="mr-4"
    >
      <MDropdownItem v-for="service in services" :key="service.id" @click="selectService(service)">
        {{ service.name }}
      </MDropdownItem>
    </MDropdown>

    <MDropdown 
      v-model="isWeekDropdownActive" 
      :text="selectedWeek ? selectedWeekName : 'Selecciona una semana'"
    >
      <MDropdownItem v-for="(week, i) in weeks" :key="i" @click="selectWeek(week, i)">
        Semana {{ i + 1 }}
      </MDropdownItem>
    </MDropdown>

    <MServiceDashboard v-if="selectedService.id" :service="selectedService" :week="selectedWeek"></MServiceDashboard>
  </div>
</template>

<script>
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
      selectedWeekName: null,
      services: [],
      form: {
        name: ""
      },
      isServiceDropdownActive: false,
      isWeekDropdownActive: false
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
      this.$server.get('/api/v1/services')
        .then((result) => {
          this.services = result.data
        })
        .catch((error) => {
          alert(error)
        })
    },
    getWeeks () {
      this.$server.get(`/api/v1/services/${this.selectedService.id}/weeks`)
        .then((result) => {
          this.selectedService.weeks = result.data
          this.openModal = false
        })
        .catch((error) => {
          alert(error)
        })
    },
    submitService () {
      this.$server.post('/api/v1/services', this.form)
        .then((result) => {
          this.services.push(result.data)
          this.openModal = false
        })
        .catch((error) => {
          alert(error)
        })
    },
    selectService(service) {
      this.selectedService = service
      this.isServiceDropdownActive = false
    },
    selectWeek(week, i) {
      this.selectedWeek = week
      this.selectedWeekName = `Semana ${i + 1}`
      this.isWeekDropdownActive = false
    }
  },
  watch: {
    selectedService() {
      this.getWeeks()
    }
  }
}
</script>
