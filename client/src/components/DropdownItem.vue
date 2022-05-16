<template>
  <div :class="className">
    <slot />
  </div>
</template>

<script>
export default {
  name: 'm-dropdown-item',
  props: {
    isActive: {
      type: Boolean,
      default: false
    },
  },
  computed: {
    className() {
      const name = 'dropdown-item'
      return this.isActive ? name + ' is-active' : name;
    }
  },
}
</script>

<style scoped>
.dropdown-item {
  cursor: pointer;
}
</style>
