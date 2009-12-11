function getRealLeft(imgElem) {
  var xPos = eval(imgElem).offsetLeft;
  var tempEl = eval(imgElem).offsetParent;
    while (tempEl != null) {
      xPos += tempEl.offsetLeft;
      tempEl = tempEl.offsetParent;
    }
  return xPos;
}

function getRealTop(imgElem) {
  var yPos = eval(imgElem).offsetTop;
  var tempEl = eval(imgElem).offsetParent;
  while (tempEl != null) {
      yPos += tempEl.offsetTop;
      tempEl = tempEl.offsetParent;
    }
  return yPos;
}
  
function beginLoading() {
  $("mf_loader").show();
}
  
function finishLoading() {
  $("mf_loader").hide();
}
  
function toggleSQLConditions() {
  $("mf_sql_conditions").toggle();
}
  
function disableControlButtons() {
/*  
  $("mf_btn_delete").disabled = true;
  $("mf_btn_update").disabled = true;
*/  
}

function enableControlButtons() {
/*  disableControlButtons();
  
  if ($("mf_id").value != "") {
    $("mf_btn_delete").disabled = false;
    $("mf_btn_update").disabled = false;
  }
  $("mf_btn_save").disabled = false;
*/  
}
    
function fieldChanged(fldId) {
  $(fldId).setStyle("border:1px solid red");
  markDirty();
}
    
function markDirty() {
  if ($("mf_key") && $("mf_id").value == "") {
    $("mf_key").value = "";
  }
}
    
function saveFilter() {
  promptForFilterAction('save_filter');
}
  
function updateFilter() {
  promptForFilterAction('update_filter');
}

function deleteFilter() {
  promptForFilterAction('delete_filter');
}

function loadPredefinedFilter() {
  if ($("mf_key").value == "-1" || $("mf_key").value == "-2")
    return;

  beginLoading();
  form_hash = $('mf_form').serialize(true);

  new Ajax.Updater('mf_filter_conditions', '/model_filter/load_filter', {
    parameters: form_hash,
    onComplete: function(transport) {
      $('mf_form').submit();
    } 
  });
}
  
function performFilterAction(action) {
  if (action=="submit") {
    $('mf_form').submit();
    return;     
  }

  beginLoading();
  markDirty();
  
  form_hash = $('mf_form').serialize(true);
  form_hash["filter_action"] = action;
  
  new Ajax.Updater('mf_filter_conditions', '/model_filter/update', {
    parameters: form_hash,
    evalScripts: true,
    onComplete: function(transport) {
      finishLoading();
      enableControlButtons();
    } 
  });
  
}
  
function promptForFilterAction(action) {
  if (action == "save_filter") {
    var filter_name = prompt("Please provide a name for the new filter:", "");
    if (filter_name == null) return;
    $("mf_name").value = filter_name;   
  } else if (action == "update_filter") {
    var filter_name = prompt("Please provide a name for this filter:", $("mf_name").value) ;
    if (filter_name == null) return;
    $("mf_name").value = filter_name;   
  } else {
    if (!confirm("Are you sure you want to delete this filter?")) return;
  }

  beginLoading();
  form_hash = $('mf_form').serialize(true);
  
  new Ajax.Updater('mf_filter_conditions', '/model_filter/' + action, {
    parameters: form_hash,
    onComplete: function(transport) {
      if (action == "delete_filter") {
          $('mf_form').submit();
      } else {
          finishLoading();
          enableControlButtons();
      }               
    } 
  });
} 
  
var selected_field_id = null;
function openCalendar(fld_id, trigger, show_time) {
  if (selected_field_id == fld_id) {
    selected_field_id = null;
    $("mf_calendar").hide();
    return;
  }
  
  selected_field_id = fld_id;
  new Ajax.Updater('mf_calendar', '/model_filter/calendar', {
    parameters:{'date':$(fld_id).value, 'show_time':show_time},
    onComplete: function(transport) {
        var fld_left = getRealLeft(trigger) - 237;
        var fld_top = getRealTop(trigger) - 7;
        $("mf_calendar").setStyle({"left":(fld_left+"px"), "top":(fld_top+"px")});
        $("mf_calendar").show();
    } 
  });
}
  
function selectDateTime(fld_id, trigger){
  openCalendar(fld_id, trigger, true);
}

function selectDate(fld_id, trigger) {
  openCalendar(fld_id, trigger, false);
}
  
function goToDate(date, show_time) {
  skip_date = false;
  if (date == '') {
    date = $("mf_cal_year").value + "-" + $("mf_cal_month").value + "-01";
    skip_date = true;
  }
  new Ajax.Updater('mf_calendar', '/model_filter/calendar', {
    parameters:{'date':date, 'show_time':show_time, 'skip_date':skip_date},
    onComplete: function(transport) {
      
    } 
  });
}
  
function setSelectedFieldValue(value) {
  if (selected_field_id==null)
    return;
  $(selected_field_id).value = value;
  selected_field_id = null;
}

function selectDateValue(elem_id, date) {
  for (i = 0; i < 31; i++) {
    if ($("mf_cal_cell_" + i)) {
      $("mf_cal_cell_" + i).removeClassName("selected");
    }
  }
  $("mf_cal_cell_" + elem_id).addClassName('selected'); 
  $("mf_selected_date").value = date;
}
  
function setDate() {
  setSelectedFieldValue($("mf_selected_date").value);
  $("mf_calendar").hide();
}

function prepandZero(val) {
  if (parseInt(val) >= 10) 
    return val;
    
  return ("0" + val);
}
  
function setDateTime() {
  var val = $("mf_selected_date").value;
  val += " " + prepandZero($("mf_cal_hour").value);
  val += ":" + prepandZero($("mf_cal_minute").value);
  val += ":" + prepandZero($("mf_cal_second").value);
  
  setSelectedFieldValue(val);
  $("mf_calendar").hide();
}

