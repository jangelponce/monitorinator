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

    <aside class="menu pb-6" v-for="day in days" :key="day.day">
      <p class="menu-label">
        {{ dateToCardTitle(day.day) }}
      </p>
      <ul class="menu-list">
        <li v-for="workshift in day.workshifts" :key="workshift.hour">
          <div class="level">
            <div class="level-item">
              {{ timeToHourRange(workshift.hour) }}
            </div>
            <div v-if="editMode" class="level-item">
              <div v-if="workshift.user">
                {{ workshift.user && workshift.user.name }}  
              </div>
              <div v-else>
                Edit mode
              </div>
            </div>
            <div v-else class="level-item">
              {{ workshift.user && workshift.user.name }}
            </div>
          </div>
        </li>
      </ul>
    </aside>
  </section>  
</template>

<script>
import axios from "axios"

export default {
  name: 'm-service-dashboard',
  props: {
    service: Object,
    week: String,
  },
  data () {
    return {
      editMode: true,
      beginningOfWeek: null,
      endOfWeek: null,
      days: []
    }
  },
  created() {
    this.getWorkshiftsWeek()
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