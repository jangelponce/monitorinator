<template>
  <div :class="buttonClass">
    <div class="dropdown-trigger">
      <button class="button" aria-haspopup="true" aria-controls="dropdown-menu" @click="toggle">
        <span>{{ text }}</span>
        <span class="icon is-small">
          <font-awesome-icon :icon="['fas', 'angle-down']" />
        </span>
      </button>
    </div>
    <div class="dropdown-menu" id="dropdown-menu" role="menu">
      <div class="dropdown-content">
        <slot />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "m-dropdown",
  props: {
    text: String
  },
  data () {
    return {
      isActive: false
    }
  },
  computed: {
    buttonClass() {
      const className = 'dropdown'
      return this.isActive ? className + ' is-active' : className;
    }
  },
  methods: {
    toggle() {
      console.log('toggling')
      this.isActive = !this.isActive
    }
  }
}
</script>

<style>

</style>