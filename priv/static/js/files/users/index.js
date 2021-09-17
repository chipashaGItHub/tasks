$(function() {
    const url = '/home/admin/profile/users/:view'
    const userForm = 'tQnwtfkqwquvEFjMapqsSwPhpslsMC5vqzSrxmTxeuNDczspnNB2wByZh82QbpdymajAXYa7yVh4jndGRpq8jkPuGr'
    $('.datatable-users-index').DataTable({
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
                form: userForm,
                view: ""
            }
        },
        "columns": [
            {title: "First Name", data: "first_name"},
            {title: "Last Name", data: "last_name"},
            {title: "Mobile", data: "mobile"},
            {title: "Username", data: "username"},
            {title: "Email Address", data: "email"},
            {
                title: "status",
                data: "status",
                "render": function (data, type, row) {
                    if (data === "true") {
                        return '<p> ACTIVE </p>';
                    }else {
                        return '<p> DISABLED </p>'
                    }
                }
            },
            {title: "Date", data: "date"},
            {title: "Login Attempts", data: "failed_attempts"},

            {title: "Last Logged Date", data: "last_login_date" },
            {title: "Actions",
                data: "id",
                render: function (data, type, row){
                    return data
                }
            }
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