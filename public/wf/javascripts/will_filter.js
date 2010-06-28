var Wf = Wf || {};

/****************************************************************************
**** Will Filter Container
****************************************************************************/

Wf.Filter = Class.create({
  initialize: function() {
		this.original_form_action = null;
  },
	showSpinner: function() {
		$("wf_loader").show();
	},
  hideSpinner: function() {
    $("wf_loader").hide();
  },
  toggleDebugger: function() {
		if ($("wf_debugger").visible()) {
			new Effect.BlindUp("wf_debugger", {duration: 0.25});
		} else {	
		  new Effect.BlindDown("wf_debugger", {duration: 0.25});
		}
	},
	markDirty: function() {
	  if ($("wf_key") && $("wf_id").value == "") {
	    $("wf_key").value = "";
	  }
	},
	fieldChanged: function(fld) {
	  $(fld).setStyle("border:1px solid red");
	  this.markDirty();
	},
	saveFilter: function() {
    var filter_name = prompt("Please provide a name for the new filter:", "");
    if (filter_name == null) return;
    $("wf_name").value = filter_name;   
		
    this.showSpinner();
    new Ajax.Updater('wf_filter_conditions', '/wf/filter/save_filter', {
      parameters: $('wf_form').serialize(true),
      onComplete: function(transport) {
          wfFilter.hideSpinner();
      } 
    });
	},
  updateFilter: function() {
    var filter_name = prompt("Please provide a name for this filter:", $("wf_name").value);
    if (filter_name == null) return;
    $("wf_name").value = filter_name;   
		
		this.showSpinner();
    new Ajax.Updater('wf_filter_conditions', '/wf/filter/update_filter', {
      parameters: $('wf_form').serialize(true),
      onComplete: function(transport) {
          wfFilter.hideSpinner();
      } 
    });
  },
  deleteFilter: function() {
		if (!confirm("Are you sure you want to delete this filter?")) return;
		
    this.showSpinner();
    new Ajax.Updater('wf_filter_conditions', '/wf/filter/delete_filter', {
      parameters: $('wf_form').serialize(true),
      onComplete: function(transport) {
        wfFilter.hideSpinner();
      } 
    });
  },
  updateConditionAt: function(index) {
    this.showSpinner();
    this.markDirty();
    
    data_hash = $('wf_form').serialize(true);
    data_hash["at_index"] = index;
    
    new Ajax.Updater('wf_filter_conditions', '/wf/filter/update_condition', {
      parameters: data_hash,
      evalScripts: true,
      onComplete: function(transport) {
        wfFilter.hideSpinner();
      } 
    });
  },
	removeConditionAt: function(index) {
    this.showSpinner();
    this.markDirty();
    
    data_hash = $('wf_form').serialize(true);
    data_hash["at_index"] = index;
    
    new Ajax.Updater('wf_filter_conditions', '/wf/filter/remove_condition', {
      parameters: data_hash,
      evalScripts: true,
      onComplete: function(transport) {
        wfFilter.hideSpinner();
      } 
    });
	},
  removeAllConditions: function() {
    this.showSpinner();
    this.markDirty();

    new Ajax.Updater('wf_filter_conditions', '/wf/filter/remove_all_conditions', {
      parameters: $('wf_form').serialize(true),
      evalScripts: true,
      onComplete: function(transport) {
        wfFilter.hideSpinner();
      } 
    });
  },
	addCondition: function() {
    this.addConditionAfter(-1);
	},
  addConditionAfter: function(index) {
    this.showSpinner();
    this.markDirty();
    
    data_hash = $('wf_form').serialize(true);
    data_hash["after_index"] = index;
    
    new Ajax.Updater('wf_filter_conditions', '/wf/filter/add_condition', {
      parameters: data_hash,
      evalScripts: true,
      onComplete: function(transport) {
        wfFilter.hideSpinner();
      } 
    });
  },	
	loadSavedFilter: function() {
	  if ($("wf_key").value == "-1" || $("wf_key").value == "-2")
	    return;
	
	  this.showSpinner();
	  form_hash = $('wf_form').serialize(true);
	
	  new Ajax.Updater('wf_filter_conditions', '/wf/filter/load_filter', {
	    parameters: form_hash,
	    onComplete: function(transport) {
	      $('wf_form').submit();
	    } 
	  });
	},
	submit: function() {
    if (this.original_form_action != "") 
        $('wf_form').action = this.original_form_action;
		
    $('wf_form').submit();
	}
});

/****************************************************************************
**** Will Filter Calendar
****************************************************************************/

Wf.Calendar = Class.create({
  initialize: function() {
    var e = Prototype.emptyFunction;
		this.trigger = null;
		this.last_selected_cell = null;
    this.options = Object.extend({
    }, arguments[0] || { });

    this.container = new Element('div', {id:'wf_calendar', className: 'wf_calendar', style: 'display:none;'});
    $(document.body).insert(this.container);
		
    this.selected_field_id = null;
  },
  openCalendar: function(fld_id, trigger, show_time) {
    if (this.selected_field_id == fld_id) {
      this.hide();
      return;
    }

    this.trigger = trigger;
		
    var form_hash = {};
		form_hash["wf_calendar_selected_date"] = $(fld_id).value;
    form_hash["wf_calendar_show_time"] = show_time;
		
    this.selected_field_id = fld_id;
    new Ajax.Updater('wf_calendar', '/wf/calendar', {
      parameters: form_hash,
      onComplete: function(transport) {
          var trigger_position = Position.cumulativeOffset(wfCalendar.trigger);
          var fld_left = trigger_position[0] - 237;
          var fld_top = trigger_position[1];
					
          $("wf_calendar").setStyle({"width":"230px", "left":(fld_left+"px"), "top":(fld_top+"px")});
					new Effect.Appear("wf_calendar", {duration: 0.25});
      } 
    });
  },
  selectDate: function(fld_id, trigger){
    this.openCalendar(fld_id, trigger, false);
  },
  selectDateTime: function(fld_id, trigger){
    this.openCalendar(fld_id, trigger, true);
  },
	changeMode: function(mode) {
    var form_hash = $('wf_calendar_form').serialize(true);
    form_hash["wf_calendar_mode"] = mode;
		
    if (mode == 'annual')
      form_hash["wf_calendar_start_date"] = $("wf_calendar_year").value + "-01-01";
		
    new Ajax.Updater('wf_calendar', '/wf/calendar', {
      parameters: form_hash,
      onComplete: function(transport) {
          var trigger_position = Position.cumulativeOffset(wfCalendar.trigger);
					var width = 400;
					if (mode=='annual') width = 680;
					
          var fld_left = trigger_position[0] - width - 7;
          var fld_top = trigger_position[1];
          $("wf_calendar").setStyle({"width":(width+"px"), "left":(fld_left+"px"), "top":(fld_top+"px")});
      } 
    });
	},
	goToStartDate: function(start_date) {
    var form_hash = $('wf_calendar_form').serialize(true);
		if (start_date == '')
      form_hash["wf_calendar_start_date"] = $("wf_calendar_year").value + "-" + $("wf_calendar_month").value + "-01";
		else
			form_hash["wf_calendar_start_date"] = start_date;
		
	  new Ajax.Updater('wf_calendar', '/wf/calendar', {
	    parameters: form_hash,
	    onComplete: function(transport) {
	    } 
	  });
	},
	setSelectedFieldValue: function(value) {
	  if (this.selected_field_id==null || $(this.selected_field_id)==null)
	    return;
	  $(this.selected_field_id).value = value;
		wfFilter.fieldChanged(this.selected_field_id);
	  this.selected_field_id = null;
	},
	selectDateValue: function(elem_id, date) {
		if (this.last_selected_cell)
      $(this.last_selected_cell).removeClassName("selected");
			
	  $(elem_id).addClassName('selected'); 
		this.last_selected_cell = elem_id;
		
	  $("wf_calendar_selected_date").value = date;
	},
	setDate: function() {
	  this.setSelectedFieldValue($("wf_calendar_selected_date").value);
    this.hide();
	},
	prepandZero: function(val) {
	  if (parseInt(val) >= 10) 
	    return val;
	    
	  return ("0" + val);
	},
	setDateTime: function() {
	  var val = $("wf_calendar_selected_date").value;
	  val += " " + this.prepandZero($("wf_calendar_hour").value);
	  val += ":" + this.prepandZero($("wf_calendar_minute").value);
	  val += ":" + this.prepandZero($("wf_calendar_second").value);
	  
	  this.setSelectedFieldValue(val);
	  this.hide();
  },
	hide: function() {
		this.selected_field_id = null;
    new Effect.Fade("wf_calendar", {duration: 0.25});
	}
});

/****************************************************************************
**** Will Filter Exporter
****************************************************************************/

Wf.Exporter = Class.create({
  initialize: function() {
    var e = Prototype.emptyFunction;
    this.options = Object.extend({
    }, arguments[0] || { });

    this.container = new Element('div', {id:'wf_exporter', className: 'wf_exporter', style: 'display:none;'});
    $(document.body).insert(this.container);
  },
	show: function (trigger) {
	  var form_hash = $('wf_form').serialize(true);
	  
	  new Ajax.Updater('wf_exporter', '/wf/exporter', {
	    parameters: form_hash,
	    onComplete: function(transport) {
          var trigger_position = Position.cumulativeOffset(trigger);
          var fld_left = trigger_position[0] - 240;
          var fld_top = trigger_position[1];
	        $("wf_exporter").setStyle({"left":(fld_left+"px"), "top":(fld_top+"px")});
          new Effect.Appear("wf_exporter", {duration: 0.25});
	    } 
	  });
  },
  hide: function() {
    new Effect.Fade("wf_exporter", {duration: 0.25});
  },
	selectAllFields: function (fld) {
	  var i = 0;
	  var chkFld = $("wf_fld_chk_" + i);
	  while (chkFld != null) {
	    chkFld.checked = fld.checked;
	    i++;
	    chkFld = $("wf_fld_chk_" + i);
	  }   
	  this.updateExportFields();
	},
	selectField: function (fld) {
	  if (!fld.checked) {
	    $("wf_fld_all").checked = false;
	  }
	  this.updateExportFields();
	},
	updateExportFields: function () {
	  var i = 0;
	  var chkFld = $("wf_fld_chk_" + i);
	  var fields = "";
	  while (chkFld != null) {
	    if (chkFld.checked) {
	      if (fields != "") fields += ",";
	      fields += $("wf_fld_name_" + i).value;
	    }
	    i++;
	    chkFld = $("wf_fld_chk_" + i);
	  }   
	
	  $("wf_export_fields").value = fields;
	}, 
  exportFilter: function() {
		if (wfFilter.original_form_action == "")
      wfFilter.original_form_action = $('wf_form').action;
			
    this.updateExportFields();
		
    if ($("wf_export_fields").value == "") {
      alert("Please select st least one field to export");
      return;
    }

    if ($('wf_export_format_selector').value == "-1") {
      alert("Please select an export format");
      return;
    }

    $('wf_export_format').value = $('wf_export_format_selector').value; 
    $('wf_form').action = '/wf/exporter/export';
    $('wf_form').submit();
  }
});


/****************************************************************************
**** Will Filter Initialization
****************************************************************************/

Wf.DomLoaded  = false
Event.observe(document,'dom:loaded',function(){Wf.DomLoaded = true;});

var wfFilter = null;
var wfCalendar = null;
var wfExporter = null;

function initializeWillFilter() { 
  var setup = function() { 
    wfFilter = new Wf.Filter(); 
    wfCalendar = new Wf.Calendar(); 
    wfExporter = new Wf.Exporter(); 
  } 
  if(Wf.DomLoaded) { 
    setup() 
  } else { 
    if(Prototype.Browser.IE) { 
      Event.observe(window,'load',setup); 
    } else { 
      Event.observe(document,'dom:loaded',setup); 
    } 
  } 
}
