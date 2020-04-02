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
