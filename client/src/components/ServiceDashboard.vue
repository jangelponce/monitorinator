<template>
  <section>
    <div class="hero">
      <div class="hero-body media px-0">
        <div class="media-content">
          <p class="title is-4">{{ service.name }}</p>
          <p class="subtitle">{{ dateRangeToSubtitle(beginningOfWeek, endOfWeek) }}</p>
        </div>
        <div class="media-right">
          <button class="button is-primary" @click="editMode = !editMode">Editar disponibilidad</button>
        </div>
      </div>
    </div>

    <table class="table is-fullwidth">
      <tbody>
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
          <tr v-for="workshift in day.workshifts" :key="workshift.hour">
            <td>
              {{ timeToHourRange(workshift.hour) }}
            </td>
            <template v-if="editMode">
              <td v-for="user in users" :key="user.id">
                <MAvailabilityCheckbox :user="user.id" :service="service.id" :datetime="workshift.hour" />
              </td>
            </template>
            <template v-else>
              <td>
                {{ workshift.user && workshift.user.name }}
              </td>
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
      editMode: true,
      beginningOfWeek: null,
      endOfWeek: null,
      days: [],
      users: []
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
    dateRangeToSubtitle(begin, end) {
      const b = new Date(begin)
      const e = new Date(end)
      e.setHours(e.getHours() + 1)
      const beginDate = new Intl.DateTimeFormat('es').format(b)
      const endDate = new Intl.DateTimeFormat('es').format(e)

      return `Del ${beginDate} al ${endDate}`
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