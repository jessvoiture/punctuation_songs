<script>
  export let value; // Store passed as a prop
  export let options; // Dropdown options
</script>

<select bind:value={$value}>
  {#each options as option}
    <option value={option}>{option}</option>
  {/each}
</select>

<style>
  select {
    font-size: 24px;
    font-weight: bold;
  }

  option {
    font-size: 14px;
    color: #000;
  }

  select {
    padding: 4px 32px 4px 4px;
    border: none;
    border-bottom: 2px solid #ddd;
    border-radius: 8px 8px 0 0;
    background-color: #fff;
    appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 10 6'%3E%3Cpath d='M1 1 L5 5 L9 1' stroke='%23000' fill='none' stroke-width='1.5'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 8px center;
    background-size: 10px;
    transition: background-color 0.3s ease;
  }

  select:hover {
    background-color: #f6f6f6;
  }

  select:focus {
    border-radius: 8px;
    background-color: #f6f6f6;
  }
</style>
