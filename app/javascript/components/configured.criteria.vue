<template>
 <div class="row" ref="clause">
    <div class="col-2">
      <label class="form-label">Select Field</label>
      <vue-typeahead-bootstrap show-on-focus @hit="setClause" v-model="clause.label" :data="field_selections" :serializer="entry => entry.label" required placeholder="Select Field">
        <template slot="suggestion" slot-scope="{ data, htmlText }">
          <span v-html="`${data.namespace}${data.namespace ? `/` : ``}${htmlText}`"></span>
        </template>
      </vue-typeahead-bootstrap>
    </div>
    <div class="col-2">
      <label class="form-label">Select Operator</label>
      <vue-typeahead-bootstrap @hit="clause.comparison_operator = $event.value" v-model="clause.comparison_operator" show-on-focus :data="comparison_operator_selections" required placeholder="Select Operator" :serializer="entry => entry.value">
        <template slot="suggestion" slot-scope="{ data }">
          <span v-html="`${data.text}`"></span>
        </template>
      </vue-typeahead-bootstrap>
    </div>
    <div class="col-2">
      <label class="form-label">Select Chain</label>
      <vue-typeahead-bootstrap @hit="clause.logical_operator = $event.value" v-model="clause.logical_operator" show-on-focus :data="logical_operator_selections" required placeholder="Select Chain" :serializer="entry => entry.value">
        <template slot="suggestion" slot-scope="{ data }">
          <span v-html="`${data.text}`"></span>
        </template>
      </vue-typeahead-bootstrap>
    </div>
    <div class="col-2">
      <label class="form-label">Label</label>
      <input type="text" v-model="clause.label" class="form-control">
    </div>
    <div class="col-2">
      <label class="form-label">Placeholder</label>
      <input type="text" v-model="clause.placeholder" class="form-control">
    </div>
    <div class="col-1 checkboxes">
      <input type="checkbox" v-model="clause.ignore_blank_values" class="form-check-input">
      <label class="form-check-label"> Ignore blank</label>
    </div>
    <div class="col-1 d-flex align-items-end">
      <div class="d-grid w-100">
      <button @click="removeClause" type="button" class="btn-block btn text-light btn-danger">Remove</button>
      </div>
    </div>
    <div v-for="(val, key, i) in clause" :key="`${key}-${i}`">
      <input v-if="!['choices'].includes(key)"  type="hidden" v-model="clause[`${key}`]"  :name="`configuration[data][clauses_attributes][${index}][${key}]`"/>
    </div>
    <div v-if="Array.isArray(clause.choices)">
      <div v-for="(choice, i) in clause.choices" :key="`${i}`">
        <input v-for="(cval, ckey) in choice" :key="`${ckey}-${i}`" type="hidden" v-model="clause[`choices`][i][`${ckey}`]" :name="`configuration[data][clauses_attributes][${index}][choices_attributes][${i}][${ckey}]`"/>
      </div>
    </div>
  </div>
</template>

<script>
export default {

  props: {
    value: undefined,
    index: {
      type: Number,
      default: 0
    },
    criteriaTemplate: {
      type: Array,
      default: () => []
    },
    prefix: {
      default: "configuration[data][clauses_attributes]"
    }
  },
  data(){
    return {
      clause: this.value || {}
    }
  },
  methods: {
    hit(e){
      window.console.log(e)
    },
    setClause(e){
      if(typeof e === 'object'){
        const newClause = Object.assign({}, e, {
          comparison_operator: this.clause.comparison_operator, logical_operator: this.clause.logical_operator
        })
        if(!newClause.comparison_operators[newClause.comparison_operator]){
          newClause.comparison_operator = "eq"
        }
        if(!newClause.logical_operator){
          newClause.logical_operator = "where"
        }
        this.clause = newClause
      }else{
        this.clause = Object.assign({}, {field: "", comparison_operator: ""})
      }
    },
    removeClause(){
      this.$emit('remove-clause', this.clause)
    }
  },
  watch: {
    clause: {
      handler(val){
        this.$emit("input", val)
      },
      deep: true
    }
  },
  computed: {
    field_selections: function() {
      return this.criteriaTemplate
    },
    comparison_operator_selections: function(){
      if(this.clause.comparison_operators){
        return Object.keys(this.clause.comparison_operators).map((co) => {
          return {text: this.clause.comparison_operators[co].name, value: co}
        })
      }else{
        return []
      }
    },
    comparison_operator: function(){
      return this.comparison_operator_selections.find(co => co.value === this.clause.comparison_operator)
    },
   logical_operator_selections: function(){
     return [{value: "where", text: "Where"}, { value: "or", text: "Or" }, {value: "and", text: "And"}]
   }
  }

}
</script>

<style scoped>
.checkboxes{
  padding-top: 27px;
}
</style>