// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function renderLink(value){
  //return String.format("{0}",(value==1)?'Yes':'No');
  return "<a href='loans/show/"+value+"'>Show</a>";
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
            'lender', 'status', 'amount', 'settlement_date','command_show_link'
        ]

    }),

     // turn on remote sorting
    remoteSort: true

});

store.setDefaultSort('lender', 'asc');


// the column model has information about grid columns
// dataIndex maps the column to the specific data field in

// the data store
var cm = new Ext.grid.ColumnModel([{         
       header: "Lender",
       dataIndex: 'lender',
       width: 150
    },{

       header: "Status",
       dataIndex: 'status',
       width: 150

    },{

       header: "Amount",
       dataIndex: 'amount',
       width: 150

    },{

       header: "Settlement Date",
       dataIndex: 'settlement_date',
       width: 150

    },{

       header: "Commands",
       dataIndex: 'command_show_link',
       width: 150,
	   renderer: renderLink

    }]);

// by default columns are sortable
cm.defaultSortable = true;

var grid = new Ext.grid.GridPanel({

    el:'loans-grid',
    width:700,
    height:500,
    title:'Loan Records',
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
