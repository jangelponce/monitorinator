<template>
  <label class="checkbox">
    <input :checked="available" type="checkbox" @change="(event) => submitCheckbox(event)">
  </label>
</template>

<script>
export default {
  name: "m-availability-checkbox",
  props: {
    serviceId: Number,
    userId: Number,
    timestamp: String,
    workshift: {
      type: Object,
      default () { return {} }
    },
    active: Boolean
  },
  data() {
    return {
      available: false,
      record: null
    }
  },
  created() {
    this.setData()
  },
  methods: {
    submitCheckbox(event) {
      if (event.target.checked) {
        this.createWorkshift()
      } else {
        this.deleteWorkshift()
      }
    },
    createWorkshift() {
      this.$server.post(`/api/v1/services/${this.serviceId}/workshifts`, {
        workshift: {
          timestamp: this.timestamp,
          user_id: this.userId,
          service_id: this.serviceId
        }
      })
        .then((response) => {
          this.record = response.data
        })
        .catch((error) => {
          alert(error)
        })
    },
    deleteWorkshift() {
      this.$server.delete(`/api/v1/services/${this.serviceId}/workshifts/${this.record.id}`)
        .then(() => {
          this.record = null
        })
        .catch((error) => {
          alert(error)
        })
    },
    setData() {
      const available = this.workshift.available
      if (available) {
        this.record = available.find((a) => a.user_id === this.userId)
        this.$nextTick(() => {
          this.available = !!this.record
        })
      }
      return false
    }
  }
}
</script>
