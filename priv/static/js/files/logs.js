$(function() {
    const url = '/home/admin/recon/audits/:view'
    const logsForm = 'atqxmqkKvUrBkbKfNlDBsjsmqnBntlBbxujYJhKkMusgalAlpnfqdzuXnnhztnwgqWnWqaJjgjvlvRfvkykkqfkqcn'
    $('.datatable-logs').DataTable({
        responsive: true,
        autoWidth: false,
        processing: true,
        select: {
            style: 'multi'
        },
        buttons: {
            buttons: [
                {
                    extend: 'copyHtml5',
                    className: 'btn btn-default',
                    text: '<i class="icon-copy3 position-left"></i> Copy'
                },
                {
                    extend: 'csvHtml5',
                    className: 'btn btn-default',
                    text: '<i class="icon-file-spreadsheet position-left"></i> CSV',
                    fieldSeparator: '\t',
                    extension: '.tsv'
                }
            ]
        },
        language: {
            'loadingRecords': '&nbsp;',
            processing: '<i class="fal fa-spinner fa-spin fa-2x fa-fw"></i><span class="sr-only">Powered by ProBASE</span> '
        },
        serverSide: true,
        paging: true,
        ajax: {
            type: "POST",
            url: url,
            data: {
                _csrf_token: $("#csrf").val(),
                form: logsForm,
                view: ""
            }
        },
        "columns": [
            {title: "Date", data: "date"},
            {title: "Description", data: "description"},
            {title: "Username", data: "username"},
            {title: "IP Address", data: "ip_address"},
            {title: "Narration", data: "reference"},
            {title: "Action Performed", data: "actionType" }
        ],
        lengthChange: false,
        lengthMenu: [[10, 20, 50, 100, 500, 1000, 10000, 20000], [10, 20, 50, 100, 500, 1000, 10000, 20000]],
        order: [[1, 'asc']],
        columnDefs: [
            {
                "targets": 5,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red"></span>'
            }
        ]
    });
});