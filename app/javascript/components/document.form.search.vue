<template>
  <div>
    <ul class="nav nav-tabs" id="searchTab">
      <li class="nav-item">
        <button class="nav-link" :class="display.general && 'active'" id="general-tab" data-bs-toggle="tab" data-bs-target="#general" type="button" role="tab" aria-controls="general" aria-selected="true">General</button>
      </li>
      <li class="nav-item">
        <button class="nav-link" :class="display.heavy && 'active'" id="heavy-tab" data-bs-toggle="tab" data-bs-target="#heavy" type="button" role="tab" aria-controls="heavy" aria-selected="false">Heavy</button>
      </li>
      <li class="nav-item">
        <button class="nav-link" :class="display.simple_advanced && 'active'" id="simple-advanced-tab" data-bs-toggle="tab" data-bs-target="#simple-advanced" type="button" role="tab" aria-controls="simple-advanced" aria-selected="false">Configured</button>
      </li>
      <li class="nav-item">
        <button class="nav-link" :class="display.advanced && 'active'" id="advanced-tab" data-bs-toggle="tab" data-bs-target="#advanced" type="button" role="tab" aria-controls="advanced" aria-selected="false">Advanced</button>
      </li>
    </ul>
    <div class="tab-content" id="searchTabContent">
      <div class="tab-pane fade" :class="display.general && 'active show'" id="general" role="tabpanel" aria-labelledby="general-tab">
      <form :action="url" accept-charset="UTF-8" method="get">
        <div class="d-flex flex-row justify-content-start mt-3">
          <div class="col-11">
            <input name="search" :value="params.search" type="search" class="form-control">
          </div>
          <div class="col-1 d-grid">
            <input type="submit" name="commit" value="Search" class="ms-1 btn btn-primary" data-disable-with="Search">
          </div>
        </div>
      </form>

      </div>
      <div class="tab-pane fade" :class="display.heavy && 'active show'" id="heavy" role="tabpanel" aria-labelledby="heavy-tab">
        <form :action="form_url" accept-charset="UTF-8" method="get">
          <div class="d-flex flex-row justify-content-start mt-3">
            <div class="col-11">
              <input name="heavy_search" :value="params.heavy_search" type="search" class="form-control">
            </div>
            <div class="col-1 d-grid">
              <input type="submit" name="commit" value="Search" class="ms-1 btn btn-primary" data-disable-with="Search">
            </div>
          </div>
        </form>
      </div>
      <div class="tab-pane fade" :class="display.simple_advanced && 'active show'" id="simple-advanced" role="tabpanel" aria-labelledby="simple-advanced-tab">
        <form :action="simple_advanced_search_url" accept-charset="UTF-8" method="get" class="mt-3" v-for="(qbt, i) in query_builder_templates" :key="`qbt-${i}`">
          <fieldset>
            <legend>
              {{ qbt.name }}
            </legend>
            <configured-criteria-input v-for="(clause, iq) in query_builder_templates[i].data.clauses" :key="`q-${iq}`" v-model="query_builder_templates[i].data.clauses[iq]" />
          </fieldset>
          <div class="d-flex flex-row justify-content-end mt-5">
            <div class="flex-column-reverse col-1 d-grid gap-2">
              <button @click="submitSimpleAdvancedSearch(i)" type="button" class="btn text-light btn-success">Submit</button>
            </div>
          </div>
        </form>
      </div>
      <div class="tab-pane fade" :class="display.advanced && 'active show'" id="advanced" role="tabpanel" aria-labelledby="advanced-tab">
        <form :action="advanced_search_url" accept-charset="UTF-8" method="get" class="mt-3" ref="advancedSearch">
          <criteria @remove-clause="removeCriteria(i)" :criteria-template="criteriaTemplate" v-model="clauses[i]" v-for="(clause, i) in clauses" :key="i" class="mb-3" />
          <div class="d-flex flex-row justify-content-end mt-5">
            <div class="flex-column-reverse col-1 d-grid gap-2">
              <button @click="addNewCriteria" type="button" class="btn text-light btn-secondary">Add More Criteria</button>
              <button @click="submitAdvancedSearch" type="button" class="btn text-light btn-success">Submit</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import Criteria from "./criteria"
import SimpleCriteria from "./simple.criteria"
import ConfiguredCriteriaInput from "./configured.criteria.input"
import Qs from "qs"

export default {
  components:{
    Criteria,
    SimpleCriteria,
    ConfiguredCriteriaInput
  },
  props: {
    url: {
      type: String,
    },
    params: {
      type: Object
    },
    query_builder_templates: {
      type: Array
    },
    criteriaTemplate: {
      type: Array,
      default: () => []
    }
  },
  data: function () {
    return {
      clauses: this.params.advanced_search || [],
      simple_clauses: this.params.simple_advanced_search,
      form_url: this.url,
      show: {
        general: false,
        heavy: false,
        advanced: false,
        simple_advanced: false,
      }
    }
  },
  methods: {
    toggleShow(prop){
      this.show[prop] = !this.show[prop]
    },
    hit(event){
      window.console.log(event)
    },
    addNewSimpleCriteria(){
      this.simple_clauses.push({ field: "", comparison_operator: "", logical_operator: ""})
    },
    removeSimpleCriteria(i){
      this.simple_clauses.splice(i, 1)
    },
    addNewCriteria(){
      this.clauses.push({ field: "", comparison_operator: "", logical_operator: ""})
    },
    removeCriteria(i){
      this.clauses.splice(i, 1)
    },
    submitSimpleAdvancedSearch(index){
      const qbt = this.query_builder_templates[index]
      const simple_advanced_search = { simple_advanced_search_id: qbt.id,  simple_advanced_search: qbt.data.clauses.map(c => ({type: c.type, field: c.field, values: c.values, comparison_operator: c.comparison_operator, logical_operator: c.logical_operator})) }
      const encoded_search_url = Qs.stringify(simple_advanced_search, {
        arrayFormat: "brackets",
        encode: false
      });
      this.form_url = `${this.url}?${encoded_search_url}`
      window.location = this.form_url
    },
    submitAdvancedSearch(){
      const advanced_search = { advanced_search: this.clauses.map(c => ({type: c.type, field: c.field, values: c.values, comparison_operator: c.comparison_operator, logical_operator: c.logical_operator})) }
      const encoded_search_url = Qs.stringify(advanced_search, {
        arrayFormat: "brackets",
        encode: false
      });
      this.form_url = `${this.url}?${encoded_search_url}`
      window.location = this.form_url
    },
  },
  computed: {
    field_selections: function() {
      return this.criteriaTemplate
    },

    display: function(){
      return this.show
    },

    advanced_search_url: function(){
      return this.form_url
    },
    simple_advanced_search_url: function(){
      return this.form_url
    }
  },
  created(){
    const qbt_id = this.params['simple_advanced_search_id']
    if(qbt_id !== undefined){
      const qbt_index = this.query_builder_templates.findIndex(qbt => parseInt(qbt_id) === qbt.id)
      if(qbt_index >= 0){
        const qbt = this.query_builder_templates[qbt_index]
        const params_qbt = this.params.simple_advanced_search
        qbt.data.clauses.forEach((clause, i) => {
          qbt.data.clauses[i] = Object.assign({}, clause, params_qbt[i])
        });
      }
    }
    if(!this.clauses.length){
      this.addNewCriteria()
    }else{
      this.clauses = this.clauses.map(c => {
        const template = this.criteriaTemplate.find(ct => ct.field === c.field)
        if(template){
          c = Object.assign({}, template, {ignore_blank_values: c.ignore_blank_values, comparison_operator: c.comparison_operator, logical_operator: c.logical_operator, values: c.values})
        }
        return c
      })
    }
    const params = this.params
    if(params.search){
      this.toggleShow('general')
    }
    else if(params.heavy_search){
      this.toggleShow('heavy')
    }
    else if(params.advanced_search){
      this.toggleShow('advanced')
    }else if(params.simple_advanced_search){
      this.toggleShow('simple_advanced')
    }
    else{
      this.toggleShow('general')
    }
  }
}
</script>
