<template>
<div>
  <nav class="navbar" role="navigation" aria-label="main navigation">
    <div class="navbar-brand">

      <router-link class="has-text-primary navbar-item" :to="{ name: 'home' }">
        Monitorinator
      </router-link>

      <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false">
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
      </a>
    </div>

    <div class="navbar-start">
      <router-link class="navbar-item" :to="{name: 'services-index'}">
        Services
      </router-link>
    </div>

    <div class="navbar-end">
      <router-link class="navbar-item" :to="{name: 'services-index'}">
        {user}
      </router-link>
    </div>
  </nav>
  <div class="container">
    <router-view />
  </div>
</div>
</template>

<script>

export default {
  name: 'App',
}
</script>
