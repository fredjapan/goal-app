document.addEventListener('DOMContentLoaded', function () {

  window.menu_collapse = function(el) {
    var el = document.getElementById(el);
    el.classList.add("navigation-collapsed");
    document.getElementById("menu-expand-button").classList.remove("is-hidden")
  }

  window.menu_expand = function(el) {
    var el = document.getElementById(el);
    el.classList.remove("navigation-collapsed");
    document.getElementById("menu-expand-button").classList.add("is-hidden")
  }

  //Button Loading state onclick if class is .clickable

  $(function() {                       
    $(".clickable").click(function() {
      $(this).addClass("is-loading");
    });
  });

  // Modals

  var rootEl = document.documentElement;
  var allModals = getAll('.modal');
  var modalButtons = getAll('.modal-button');
  var modalCloses = getAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button, .modal-close-button');

  if (modalButtons.length > 0) {
      modalButtons.forEach(function (el) {
          el.addEventListener('click', function () {
              var target = document.getElementById('modal-window');
              rootEl.classList.add('is-clipped');
              target.classList.add('is-active');
          });
      });
  }

  if (modalCloses.length > 0) {
      modalCloses.forEach(function (el) {
          el.addEventListener('click', function () {
              closeModals();
          });
      });
  }

  document.addEventListener('keydown', function (event) {
      var e = event || window.event;
      if (e.keyCode === 27) {
          closeModals();
      }
  });

  function closeModals() {
      rootEl.classList.remove('is-clipped');
      allModals.forEach(function (el) {
          el.classList.remove('is-active');
      });
  }

  // Functions

  function getAll(selector) {
      return Array.prototype.slice.call(document.querySelectorAll(selector), 0);
  }


});
