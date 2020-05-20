document.onload = () => {
  // La page est loadee, tu peux maintenant executer le code que tu veux
  document.querySelector("input").addEventListener("click", (e) => { alert('button clicked'); } )
}

window.toggle_visibility = function(id) {
  var e = document.getElementById(id);
  if (e.style.display == 'block') {
    e.style.display = 'none';
  }
  else {
    e.style.display = 'block';
  }
}

window.showID = function(id) {
  var e = document.getElementById(id);
  id.style.display = 'block';
}

window.hideID = function(id) {
  var e = document.getElementById(id);
  e.style.display = 'none';
}

window.myFunction = function(p1, p2) {
  return p1 * p2;   // The function returns the product of p1 and p2
}
