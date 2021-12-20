<template>
  <div class="row">
    <div class="col-12 mb-2">
      <label class="form-label">Criterias</label>
    </div>
    <div class="col-12 mb-2" v-for="(clause, i) in object.data.clauses" :key="i">
      <configured-criteria @remove-clause="removeClause(i)" :prefix="prefix" v-model="object.data.clauses[i]" :criteria-template="criteriaTemplate" :index="i" />
    </div>
    <div class="col-12 d-flex flex-row justify-content-end mt-5">
      <div class="flex-column-reverse col-1 d-grid gap-2">
        <button @click="addNewClause" type="button" class="btn text-light btn-secondary">Add More Clause</button>
      </div>
    </div>
  </div>
</template>

<script>
import Qs from "qs"
import ConfiguredCriteria from "./configured.criteria"

export default {
  components:{
    ConfiguredCriteria
  },
  props: {
    url: {
      type: String,
    },
    configuration: {
      type: Object
    },
    params: {
      type: Object
    },
    criteriaTemplate: {
      type: Array,
      default: () => []
    },
    prefix: {
      default: "configuration[data][clauses_attributes]"
    }
  },
  data: function () {
    return {
      form_url: this.url,
      object: this.configuration
    }
  },
  methods: {
    toggleShow(prop){
      this.show[prop] = !this.show[prop]
    },
    addNewClause(){
      this.object.data.clauses.push({ field: "", comparison_operator: "", logical_operator: "", label: "", placeholder: ""})
    },
    removeClause(i){
      this.object.data.clauses.splice(i, 1)
    },
  },
  computed: {


  },
  created(){

  }
}
</script>
