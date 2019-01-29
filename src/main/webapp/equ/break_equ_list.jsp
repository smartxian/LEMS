<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
    $(function () {
        var break_equ_list_uid_auth = getCookie("uid");
        var add_equ_list_token_auth = getCookie("token");
        if (break_equ_list_uid_auth == null || add_equ_list_token_auth == null) {
            $.messager.alert('警告', "530,您没有登录");
            setTimeout(function () {
                window.location.reload();
            }, 3000);
            return;
        }
        $('#break_equ_list').datagrid({
            url: './equ/break_equ_list.do',
            queryParams: {//认证条件
                auth_uid: break_equ_list_uid_auth,
                auth_token: add_equ_list_token_auth
            },
            pagination: true,
            fit: true,
            fitColumns: true,
            singleSelect: true,
            idField: 'eid',
            pageSize: 5,
            pageList: [5, 10, 15, 20],
            sortName: 'ename',
            sortOrder: 'asc',
            columns: [[
                {field: 'ck', checkbox: "true"},
                {field: 'id', title: '故障编号', width: 100, sortable: true},
                {field: 'e_id', title: '设备编号', width: 100, sortable: true},
                {field: 'ename', title: '设备名称', width: 100, sortable: true},
                {field: 'etype', title: '设备类型', width: 100, sortable: true},
                {field: 'lname', title: '所属实验室', width: 100},
                {
                    field: 'status',
                    title: '状态',
                    width: 100,
                    formatter: function (status, rec, index) {
                        if (status == 0) {
                            return '未修复';
                        }
                        if (status == 1) {
                            return '已修复';
                        }
                    },
                    sortable: true,
                    fixed: true
                },
                {field: 'breason', title: '故障原因', width: 100}
            ]],
            onLoadSuccess:function (result) {
                if (result.status!=0){
                    $.messager.alert('警告', result.message);
                    setTimeout(function () {
                        window.location.reload();
                    }, 3000);
                }
            },
            toolbar: ['-', {
                text: '修复',
                iconCls: 'icon-edit',
                handler: function () {
                    break_equ_list_fix();
                }
            }, '-', {
                text: '删除',
                iconCls: 'icon-edit',
                handler: function () {
                    break_equ_list_del();
                }
            }]
        });

        $("#break_equ_list_search_lab_btn").click(break_equ_list_search_lab);//绑定查询事件
        $("#break_equ_list_reset_search_lab_btn").click(break_equ_list_reset_search_lab);

        /**
         * 修复设备
         */
        function break_equ_list_fix() {
            var break_equ = $('#break_equ_list').datagrid('getSelected');
            var break_equ_bid = break_equ['bid'];
            var break_equ_eid = break_equ['eid'];
            $.ajax({
                url: "./equ/fixed_equ.do",
                type: "post",
                data: {
                    "bid": break_equ_bid,
                    "eid": break_equ_eid,
                    "auth_uid": break_equ_list_uid_auth,
                    "auth_token": add_equ_list_token_auth
                },
                dataType: "json",
                success: function (result) {
                    if (result.status == 0) {
                        $.messager.alert('提示', result.message);
                        $('#break_equ_list').datagrid('load', {
                            "auth_uid": break_equ_list_uid_auth,
                            "auth_token": add_equ_list_token_auth
                        });
                    }
                    if (result.status != 0) {
                        $.messager.alert('警告', result.message);
                    }
                    $('#break_equ_list').datagrid('clearSelections');//清除选中
                },
                error: function () {
                    $.messager.alert('警告', "修复设备异常");
                },
                async: true
            });
        }

        /**
         * 删除修复设备
         */
        function break_equ_list_del() {
            var break_equ = $('#break_equ_list').datagrid('getSelected');
            var break_equ_bid = break_equ['bid'];
            var break_equ_status = break_equ['status'];
            if (break_equ_status == 1) {
                $.ajax({
                    url: "./equ/fixed_equ_del.do",
                    type: "post",
                    data: {
                        "bid": break_equ_bid,
                        "auth_uid": break_equ_list_uid_auth,
                        "auth_token": add_equ_list_token_auth
                    },
                    dataType: "json",
                    success: function (result) {
                        if (result.status == 0) {
                            $.messager.alert('提示', result.message);
                            $('#break_equ_list').datagrid('load', {
                                "auth_uid": break_equ_list_uid_auth,
                                "auth_token": add_equ_list_token_auth
                            });
                        }
                        if (result.status != 0) {
                            $.messager.alert('警告', result.message);
                        }
                        $('#break_equ_list').datagrid('clearSelections');//清除选中
                    },
                    error: function () {
                        $.messager.alert('警告', "修复设备异常");
                    },
                    async: true
                });
            } else {
                $.messager.alert("info", "此设备尚未修复不可删除");
            }
        }


        /**
         * 条件查询
         */
        function break_equ_list_search_lab() {
            var break_equ_ename = $("#break_equ_list_search_ename").val().trim();
            var break_equ_eid = $("#break_equ_list_search_eid").val().trim();
            var break_equ_id = $("#break_equ_list_search_id").val().trim();
            break_equ_ename = (break_equ_ename == "" ? undefined : break_equ_ename);
            break_equ_eid = (break_equ_eid == "" ? undefined : break_equ_eid);
            break_equ_id = (break_equ_id == "" ? undefined : break_equ_id);
            $('#break_equ_list').datagrid('load', {
                "ename": break_equ_ename,
                "e_id": break_equ_eid,
                "id": break_equ_id,
                "auth_uid": break_equ_list_uid_auth,
                "auth_token": add_equ_list_token_auth
            });
        }

        /**
         * 清空条件查询
         */
        function break_equ_list_reset_search_lab() {
            $("#break_equ_list_search_ename").val("");
            $("#break_equ_list_search_eid").val("");
            $("#break_equ_list_search_id").val("");
            $('#break_equ_list').datagrid('load', {
                "auth_uid": break_equ_list_uid_auth,
                "auth_token": add_equ_list_token_auth
            });
        }
    });
</script>
<div class="easyui-layout" data-options="fit : true">
    <div data-options="region:'north',split:false,collapsible:true" style="overflow: hidden">
        <form>

            <div style="float: left;margin-top: 5px;margin-bottom: 5px">
                &emsp;<b>故障编号查询</b><input id="break_equ_list_search_id" class="easyui-validatebox">&emsp;
                &emsp;<b>设备编号查询</b><input id="break_equ_list_search_eid" class="easyui-validatebox">&emsp;
                &emsp;<b>设备名查询</b><input id="break_equ_list_search_ename" class="easyui-validatebox">&emsp;
            </div>
            <div style="float: left;margin-top: 5px;margin-bottom: 5px">
                <input id="break_equ_list_search_lab_btn" type="button" value="查询">
                <input id="break_equ_list_reset_search_lab_btn" type="button" value="清空">&emsp;
            </div>
        </form>
    </div>
    <div id="break_equ_list_grid" data-options="region:'center',collapsible:false"
         style="padding:5px;background:#eee;overflow: hidden">
        <div id="break_equ_list_dialog" style="overflow: hidden">
            <%--用于实现datagrid弹出窗口--%>
        </div>
        <table id="break_equ_list"></table>
    </div>
</div>
