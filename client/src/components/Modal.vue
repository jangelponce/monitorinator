<template>
  <div :class="modalClass">
    <div class="modal-background"></div>
    <slot />
    <button class="modal-close is-large" aria-label="close" @click="$emit('close')"></button>
  </div>
</template>

<script>
export default {
  name: 'm-modal',
  props: {
    isActive: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    modalClass() {
      const className = 'modal'
      return this.isActive ? className + ' is-active' : className;
    }
  }
}
</script>

<style>

</style>