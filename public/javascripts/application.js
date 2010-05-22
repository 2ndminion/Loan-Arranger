// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function number_to_currency (number, options) {
  try {
    var options   = options || {};
    var precision = options["precision"] || 2;
    var unit      = options["unit"] || "$";
    var separator = precision > 0 ? options["separator"] || "." : "";
    var delimiter = options["delimiter"] || ",";
  
    var parts = parseFloat(number).toFixed(precision).split('.');
    return unit + number_with_delimiter(parts[0], delimiter) + separator + parts[1].toString();
  } catch(e) {
    return number
  }
}

function number_with_delimiter (number, delimiter, separator) {
  try {
    var delimiter = delimiter || ",";
    var separator = separator || ".";
    
    var parts = number.toString().split('.');
    parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + delimiter);
    return parts.join(separator);
  } catch(e) {
    return number
  }
}

function renderLink(value){
  //return String.format("{0}",(value==1)?'Yes':'No');
  return "<a href='loans/edit/"+value+"'>Edit</a>";
}

function renderCurrency(value){
  return number_to_currency(value);
}


Ext.onReady(function(){

// create the Data Store
var store = new Ext.data.Store({

    proxy: new Ext.data.HttpProxy({
        url: 'loans.json',
        method: 'GET'
		}),


// create reader that reads the Employee records
    reader: new Ext.data.JsonReader({
        root: 'loans',
        totalProperty: 'total',
        id: 'id',
        fields: [
            'selected','id','lender', 'status', 'amount', 'interest_rate', 'risk', 'term', 'settlement_date', 'bundle', 'command_links'
        ]

    }),

     // turn on remote sorting
    remoteSort: true

});

store.setDefaultSort('id', 'asc');

// the check column is created using a custom plugin
var checkColumn = new Ext.grid.CheckColumn({
    header: 'Select',
    dataIndex: 'selected',
    width: 60,
	onMouseDown : function(e, t){
	    if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
	      e.stopEvent();
	      var index = this.grid.getView().findRowIndex(t);
	      var record = this.grid.store.getAt(index);
	      record.set(this.dataIndex, !record.data[this.dataIndex]);

		  // fire afterEdit with all required params
	      this.grid.fireEvent('afterEdit', {
			  grid: this.grid,
			  record: record,
			  field: this.dataIndex,
			  value: record.data[this.dataIndex],
			  originalValue: !record.data[this.dataIndex],
			  row: index,
			  column: this.grid.getColumnModel().getIndexById(this.id)
		   });
	      }
		  Ext.Ajax.request({
		    url: '/loans/toggle_lock/'+record.data['id']
		  });
		
	    }
});

// the column model has information about grid columns
// dataIndex maps the column to the specific data field in

// the data store
var cm = new Ext.grid.ColumnModel([
	checkColumn,
	{         
       header: "Id",
       dataIndex: 'id',
       width: 75,
       sortable: true
    },{         
       header: "Lender",
       dataIndex: 'lender',
       width: 150,
	   sortable: false
    },{
       header: "Status",
       dataIndex: 'status',
       width: 75,
       sortable: true
    },{
       header: "Amount",
       dataIndex: 'amount',
       width: 150,
       sortable: true,
       renderer: renderCurrency
    },{	   
	   header: "Rate",
	   dataIndex: 'interest_rate',
	   width: 50,
	   sortable: true
	},{		
       header: "Risk",
	   dataIndex: 'risk',
	   width: 50,
	   sortable: true
    },{	   
	   header: "Term",
	   dataIndex: 'term',
	   width: 50,
	   sortable: true
	},{		
       header: "Settlement Date",
       dataIndex: 'settlement_date',
       width: 150,
       sortable: true
    },{	
	   header: "Bundle",
	   dataIndex: 'bundle',
	   width: 150
	},{
       header: " ",
       dataIndex: 'command_links',
       width: 50,
	   renderer: renderLink
    }]);

// by default columns are sortable
cm.defaultSortable = false;

var grid = new Ext.grid.GridPanel({

    el:'loans-grid',
    width:745,
    height:500,
    title:'Loan Records',
	plugins: checkColumn,
    store: store,
    cm: cm,
    trackMouseOver:false,
    sm: new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn}),
    loadMask: true,
    viewConfig: {
        forceFit:true /*to auto expand the size of the columns to fit the grid width and prevent horizontal scrolling*/
    },

    bbar: new Ext.PagingToolbar({
        pageSize: 20,
        store: store,
        displayInfo: true,
        displayMsg: 'Displaying records {0} - {1} of {2}',
        emptyMsg: "No records to display"

    })

});


// render it
grid.render();


// trigger the data store load
store.load({params:{start:0, limit:25}});

});
