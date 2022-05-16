<template>
  <section>
    <div class="hero">
      <div class="hero-body media px-0">
        <div class="media-content">
          <p class="title is-4">{{ service.name }}</p>
          <p class="subtitle">{{ dateRangeToSubtitle(beginningOfWeek, endOfWeek) }}</p>
        </div>
        <div class="media-right">
          <button class="button mr-4 is-primary" @click="calculateWorkshifts">Calcular turnos</button>
          <button class="button is-primary" @click="editMode = !editMode">Editar disponibilidad</button>
        </div>
      </div>
    </div>

    <table class="table is-fullwidth">
      <tbody>
        <template v-if="days.length">
          <tr>
            <td class="pt-6">
              <p class="menu-label">
                Usuarios
              </p>
            </td>
            <td class="pt-6" colspan="1">
              <p class="menu-label">
                Turnos
              </p>
            </td>
          </tr>
          <template v-for="user in users" :key="user.id">
            <tr class="has-text-white">
              <td :class="userColor(user.id)">
                <p>
                  {{ user.name }}
                </p>
              </td>
              <td colspan="3">
                <p class="menu-label">
                  {{ userCounts[user.id] }}
                </p>
              </td>
            </tr>
          </template>
        </template>
        <template v-for="day in days" :key="day.day">
          <tr>
            <td class="pt-6">
              <p class="menu-label">
                {{ dateToCardTitle(day.day) }}
              </p>
            </td>
            <template v-if="editMode">
              <td v-for="user in users" :key="user.id" class="pt-6">
                <p class="menu-label">
                  {{ user.name }}
                </p>
              </td>
            </template>
            <template v-else>
              <td colspan="1"></td>
            </template>
          </tr>
          <tr v-for="ws in day.workshifts" :key="ws.hour" class="has-text-white">
            <td :class="hourTdClass(ws)">
              {{ timeToHourRange(ws.hour) }}
            </td>
            <template v-if="editMode">
              <td v-for="user in users" :key="user.id">
                <MAvailabilityCheckbox 
                  :userId="user.id"
                  :serviceId="service.id" 
                  :timestamp="ws.hour" 
                  :workshift="ws"
                />
              </td>
            </template>
            <template v-else>
              <template v-if="ws.workshift">
                <td :class="userColor(ws.workshift.user.id)">
                  <p>
                    {{ ws.workshift.user.name }}
                  </p>
                </td>
              </template>
              <template v-else>
                <td class="has-text-centered has-text-warning">
                  <font-awesome-icon :icon="['fas', 'triangle-exclamation']" />
                </td>
              </template>
            </template>
          </tr>
        </template>
      </tbody>
    </table>
  </section>  
</template>

<script>
import axios from "axios"
import MAvailabilityCheckbox from "@/components/AvailabilityCheckbox.vue"

export default {
  name: 'm-service-dashboard',
  components: {
    MAvailabilityCheckbox
  },
  props: {
    service: Object,
    week: String,
  },
  data () {
    return {
      editMode: false,
      beginningOfWeek: null,
      endOfWeek: null,
      days: [],
      users: [],
      userCounts: {}
    }
  },
  computed: {
    userColors () {
      let colors = {}
      const colorClasses = ['primary','info','warning']
      this.users.forEach((user, i) => {
        colors[user.id] = colorClasses[i]
      })

      return colors
    }
  },
  created() {
    this.getWorkshiftsWeek()
    this.getUsers()
  },
  methods: {
    getWorkshiftsWeek() {
      if (this.week) {
        axios.get(`http://192.168.70.214:3000/api/v1/services/${this.service.id}/workshifts/week?date=${this.week}`)
          .then((response) => {
            const { week, days} = response.data
            this.days = days
            this.beginningOfWeek = week.beginning_of_week
            this.endOfWeek = week.end_of_week
            this.countWorkshiftsPerUser()
          })
          .catch((error) => {
            alert(error)
          })
      }
    },
    getUsers() {
      axios.get(`http://192.168.70.214:3000/api/v1/users`)
        .then((response) => {
          this.users = response.data
        })
        .catch((error) => {
          alert(error)
        })
    },
    calculateWorkshifts() {
      console.log("calculating")
      axios.put(`http://192.168.70.214:3000/api/v1/services/${this.service.id}/workshifts/calculate?date=${this.week}`)
        .then(() => {
          console.log("calculations done")
        })
        .catch((error) => {
          alert(error)
        })
    },
    countWorkshiftsPerUser() {
      let counts = {}
      this.users.forEach((user) => {
        counts[user.id] = 0
      })

      this.days.forEach((day) => {
        day.workshifts.forEach((ws) => {
          if (ws.workshift) {
            counts[ws.workshift.user_id] = counts[ws.workshift.user_id] + 1
          }
        })
      })
      this.userCounts = counts
    },
    dateRangeToSubtitle(begin, end) {
      if (begin && end) {
        const b = new Date(begin)
        const e = new Date(end)
        e.setHours(e.getHours() + 1)
        const beginDate = new Intl.DateTimeFormat('es').format(b)
        const endDate = new Intl.DateTimeFormat('es').format(e)
  
        return `Del ${beginDate} al ${endDate}`
      } else {
        return 'Selecciona una semana'
      }
    },
    dateToCardTitle(value) {
      const date = new Date(value)
      return new Intl.DateTimeFormat('es', { weekday: 'long', month: 'long', day: 'numeric' }).format(date)
    },
    timeToHourRange(value) {
      const bt = new Date(value)
      const et = new Date(value)
      et.setHours(et.getHours() + 1)
      const beginTime = new Intl.DateTimeFormat('es', { timeStyle: 'short' }).format(bt)
      const endTime = new Intl.DateTimeFormat('es', { timeStyle: 'short' }).format(et)

      return `${beginTime} - ${endTime}`
    },
    hourTdClass(ws) {
      if (ws.workshift) {
        return 'has-background-success-dark'
      } else {
        return 'has-background-danger-dark'
      }
    },
    userColor(user_id) {
      const color = this.userColors[user_id]
      return color ? `has-background-${color}` : ''
    }
  },
  watch: {
    service() {
      this.getWorkshiftsWeek()
    },
    week() {
      this.getWorkshiftsWeek()
    }
  }
}
</script>

<style scoped>
.level-item {
  justify-content: left;
}
</style>