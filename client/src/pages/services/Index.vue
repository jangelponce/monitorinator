<template>
  <h1>Services</h1>
</template>

<script>
// import Service from '~/backend/maenager/service'
import axios from 'axios'

export default {
  name: 'services-index',
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
          this.services = result
        })
        .catch((error) => {
          alert(error)
        })
    }
  }
}
</script>
