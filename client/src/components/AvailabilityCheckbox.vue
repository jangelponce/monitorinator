<template>
  <label class="checkbox">
    <input v-model="available" type="checkbox">
  </label>
</template>

<script>
export default {
  name: "m-availability-checkbox",
  props: {
    user: Number,
    datetime: String,
    service: Number
  },
  data() {
    return {
      available: false
    }
  }
}
</script>
