document.onload = () => {
  // La page est loadee, tu peux maintenant executer le code que tu veux
  document.querySelector("input").addEventListener("click", (e) => { alert('button clicked'); } )
}

function toggle_visibility(id) {
  var e = document.getElementById(id);
  console.log(e);
  if (e.style.display == 'block') {
    e.style.display = 'none';
  }
  else {
    e.style.display = 'block';
  }
}

function showID(id) {
  var e = document.getElementById(id);
  e.style.display = 'block';
}

function hideID(id) {
  var e = document.getElementById(id);
  e.style.display = 'none';
}


function myFunction(p1, p2) {
  return p1 * p2;   // The function returns the product of p1 and p2
}