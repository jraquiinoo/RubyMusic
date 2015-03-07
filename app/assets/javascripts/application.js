// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.widget
//= require jquery.iframe-transport
//= require jquery.fileupload
//= require jquery.fileupload-ui
//= require materialize
//= require turbolinks
//= require_tree .


// Helper function that formats the file sizes
function formatFileSize(bytes){if (typeof bytes !== 'number'){return '';}if (bytes >= 1000000000){return (bytes / 1000000000).toFixed(2) + ' GB';}if (bytes >= 1000000){return (bytes / 1000000).toFixed(2) + ' MB';}return (bytes / 1000).toFixed(2) + ' KB';}
