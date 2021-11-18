$(document).ready(function () {
  var table = $("#sortable").DataTable({
    initComplete: function (settings, json) {},
    language: {
      sProcessing: "Processing.",
      sLengthMenu: "show _MENU_ records",
      sZeroRecords: "none record",
      sInfo: "show No. _START_ to NO. _END_ ，Total _TOTAL_ records",
      sInfoEmpty: "show 0 to 0 records，total: 0",
      sInfoFiltered: "(由 _MAX_ 項結果過濾)",
      sInfoPostFix: "",
      sSearch: "search:",
      sUrl: "",
      sEmptyTable: "no data",
      sLoadingRecords: "Loading...",
      sInfoThousands: ",",
      oPaginate: {
        sFirst: "First",
        sPrevious: "Previous",
        sNext: "Next",
        sLast: "Last",
      },
      oAria: {
        sSortAscending: ": in increasing order",
        sSortDescending: ": in decreasing order",
      },
    },
    buttons: ["copy", "excel", "colvis"],
  });
  table.buttons().container().appendTo("#example_wrapper .col-md-6:eq(0)");
});
