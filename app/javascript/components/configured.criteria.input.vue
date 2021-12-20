<template>
 <div class="row" ref="clause">
    <div v-if="clause.type === 'string' && Array.isArray(clause.choices) && clause.choices.length" class="col-4">
      <label class="form-label">{{ clause.label }}</label>
      <select name="search" v-model="clause.values" class="form-control">
        <option v-if="clause.placeholder" :value="null" >{{ clause.placeholder }}</option>
        <option v-for="(opt, i) in clause.choices" :key="i" :value="opt.value">{{ opt.label }}</option>
      </select>
    </div>
    <div v-else-if="clause.type == 'boolean'" class="col-4">
      <label class="form-label">{{ clause.label }}</label>
      <select name="search" v-model="clause.values" class="form-control">
        <option v-if="clause.placeholder" :value="null" >{{ clause.placeholder }}</option>
        <option :value="true">True</option>
        <option :value="false">False</option>
      </select>
    </div>
    <div v-else class="col-4">
      <label class="form-label">{{ clause.label }}</label>
      <input v-if="clause.type == 'date'" name="search" v-model="clause.values" :placeholder="clause.placeholder" type="date" class="form-control">
      <input v-else-if="clause.type == 'date_time'" name="search" v-model="clause.values" :placeholder="clause.placeholder" type="datetime-local" class="form-control">
      <input v-else-if="clause.type == 'integer'" name="search" v-model="clause.values" :placeholder="clause.placeholder" type="number" class="form-control">
      <input v-else-if="clause.type == 'big_decimal'" name="search" v-model="clause.values" :placeholder="clause.placeholder" type="number" class="form-control">
      <input v-else name="search" :placeholder="clause.placeholder" v-model="clause.values" class="form-control">
    </div>
  </div>
</template>

<script>
export default {

  props: {
    value: undefined,
  },
  data(){
    return {
      clause: this.value || {}
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

}
</script>