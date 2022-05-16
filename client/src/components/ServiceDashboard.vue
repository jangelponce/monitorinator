<template>
  <section class="section">
    <h1 class="title">{{ service.name }}</h1>
    <h2 class="subtitle">
      {{ weekName }}
    </h2>
    <div class="tile is-ancestor" v-for="(days, i) in chunks" :key="i">
      <div class="tile is-parent">
        <article class="tile is-child box" v-for="day in days" :key="day.day">
          <p class="subtitle">{{ dateToCardTitle(day.day) }}</p>
          <div class="menu">
            <ul class="menu-list">
              <li v-for="workshift in day.workshifts" :key="workshift.hour">
                <div class="level">
                  <div class="level-item">
                    {{ timeToHourRange(workshift.hour) }}
                  </div>
                  <div class="level-item">
                    {{ workshift.user && workshift.user.name }}
                  </div>
                </div>
              </li>
            </ul>
          </div>
        </article>
      </div>
    </div>
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
      weekName: "Cargando...",
      chunks: []
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
            this.weekName = week
            this.chunks = []
            for (let i = 0; i < days.length; i += 3) {
              this.chunks.push(days.slice(i, i + 3))
            }
          })
          .catch((error) => {
            alert(error)
          })
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