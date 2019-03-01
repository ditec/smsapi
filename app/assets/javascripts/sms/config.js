// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
//= require jquery3
//= require jquery_ujs

document.addEventListener("turbolinks:load", function() {
  $('#config_delivery select').change(function() {
    if( $(this).val() == "X dias antes"){
      $('#cant').show();
    }else{
      $('#cant').hide();
    }

    if( $(this).val() == "Inmediato"){
      $("#config_time input").prop("checked", false);
      $('#config_time').hide();
      $('#time_select').hide();
    }else{
      $('#config_time').show();
    }
  });

  $('#config_time input').change(function() {
    if( $(this).is(':checked')){
      $('#time_select').show();
    }else{
      $('#time_select').hide();
    }
  });

  $('#config_text_area').keyup(function (e) {
    var left = 160 - $(this).val().replace(/#\w+/g, "").length;
    if(left <= 0 && (e.keyCode !== 8)) { 
      e.preventDefault();
    }
    $('#config_counter').text('Characters left: ' + left);
  });
});