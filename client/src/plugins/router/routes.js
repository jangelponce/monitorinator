export const routes = [
  {
    name: "home",
    path: "/",
    component: () => import('@/pages/Home.vue')
  },
  {
    name: "services-index",
    path: "/services",
    component:  () => import('@/pages/services/Index.vue'),
  },
];
