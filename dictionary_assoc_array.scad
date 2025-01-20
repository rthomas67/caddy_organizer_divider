available_specs = [
  ["mgn7c", 1,2,3,4],
  ["mgn7h", 2,3,4,5],
];

function selector(item) = available_specs[search([item], available_specs)[0]];

chosen_spec = selector("mgn7c");

echo("Specification was returned from function", chosen_spec);