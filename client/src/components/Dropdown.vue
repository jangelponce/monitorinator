<template>
  <div :class="buttonClass">
    <div class="dropdown-trigger">
      <button class="button" aria-haspopup="true" aria-controls="dropdown-menu" @click="$emit('update:modelValue', !modelValue)">
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
    text: String,
    modelValue: {
      type: Boolean,
      default: false,
    }
  },
  computed: {
    buttonClass() {
      const className = 'dropdown'
      return this.modelValue ? className + ' is-active' : className;
    }
  }
}
</script>

<style>

</style>