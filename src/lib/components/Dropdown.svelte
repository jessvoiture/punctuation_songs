<script>
  import { selectedOption } from "../../stores";

  const options = [
    "parantheses",
    "exclamation mark",
    "question mark",
    "period",
    "apostrophe",
    "phonetic elision",
    "contraction/possession",
  ];
</script>

<select bind:value={$selectedOption}>
  <option value="paratheses" disabled>Select an option</option>
  {#each options as option}
    <option value={option}>{option}</option>
  {/each}
</select>

<style>
  select {
    font-size: 20px; /* Change the font size of the dropdown */
  }

  option {
    font-size: 20px; /* Change the font size of the dropdown options */
  }

  select {
    padding: 8px 32px 8px 4px; /* Add some padding for better appearance */
    border-radius: 5px; /* Rounded corners */
    border: 1px solid #ccc; /* Light border */
    background-color: #f9f9f9; /* Light background color */
    appearance: none; /* Remove default browser styling for better control */
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 10 6'%3E%3Cpath d='M1 1 L5 5 L9 1' stroke='%23000' fill='none' stroke-width='1.5'/%3E%3C/svg%3E"); /* Custom arrow */
    background-repeat: no-repeat;
    background-position: right 8px center; /* Position the arrow */
    background-size: 10px; /* Size of the arrow */
  }
</style>
