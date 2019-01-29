<%--
实验室负责人管理页面
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
    $(function () {
        var mgr_lab_uid_auth = getCookie("uid");
        var mgr_lab_token_auth = getCookie("token");
        if(mgr_lab_uid_auth==null||mgr_lab_token_auth==null){
            $.messager.alert('警告', "530,您没有登录");
            setTimeout(function () {
                window.location.reload();
            }, 3000);
            return;
        }
        $('#mgr_lab_list').datagrid({
            url: './lab/lab_mgr_list.do',
            queryParams: {//认证条件
                auth_uid: mgr_lab_uid_auth,
                auth_token: mgr_lab_token_auth
            },
            pagination: true,
            fit: true,
            fitColumns: true,
            singleSelect: true,
            idField: 'lid',
            pageSize: 5,
            pageList: [5, 10, 15, 20],
            sortName: 'lname',
            sortOrder: 'asc',
            columns: [[
                {field: 'ck', checkbox: "true"},
                {field: 'id', title: '实验室编号', width: 100, sortable: true},
                {field: 'lname', title: '实验室名称', width: 100, sortable: true},
                {field: 'type', title: '实验室类型', width: 100, sortable: true},
                /*----------实验室部分--------*/
                {field: 'lab_uname', title: '实验室负责人', width: 100, sortable: true},
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
                text: '管理',
                iconCls: 'icon-edit',
                handler: function () {
                    var mod_mgr_lab = $('#mgr_lab_list').datagrid('getSelected');
                    var mgr_lab_lid = mod_mgr_lab['lid'];
                    var mgr_lab_id = mod_mgr_lab['id'];
                    var mgr_lab_lname = mod_mgr_lab['lname'];

                    $("#mgr_lab_dialog").dialog({
                        title: '实验室管理',
                        width: 650,
                        height: 480,
                        href: './lab/mod_mgr_lab.jsp',
                        params: {
                            'mod_mgr_lab_lid': mgr_lab_lid,
                            'mod_mgr_lab_id': mgr_lab_id,
                            'mod_mgr_lab_lname': mgr_lab_lname
                        },//传递参数
                        modal: true,
                        onClose: function () {
//                            $('#mgr_lab_list').datagrid('clearSelections');//清除选中
                            $('#mgr_lab_list').datagrid('load', {
                                auth_uid: mgr_lab_uid_auth,//认证条件
                                auth_token: mgr_lab_token_auth//认证条件
                            });
                        }
                    });
                }
            }]
        });

        $("#mgr_search_lab_btn").click(mgr_lab_search_lab);//绑定查询事件
        $("#mgr_reset_search_lab_btn").click(mgr_reset_search_lab);


        /**
         * 条件查询
         */
        function mgr_lab_search_lab() {
            var mgr_lname = $("#mgr_lab_search_lname").val().trim();
            var mgr_id = $("#mgr_lab_search_id").val().trim();
            var mgr_type = $("#mgr_lab_search_type").val().trim();
            mgr_lname=(mgr_lname==""?undefined:mgr_lname);
            mgr_id=(mgr_id==""?undefined:mgr_id);
            mgr_type=(mgr_type==""?undefined:mgr_type);
            $('#mgr_lab_list').datagrid('load', {
                lname: mgr_lname,
                id: mgr_id,
                type: mgr_type,
                auth_uid: mgr_lab_uid_auth,//认证条件
                auth_token: mgr_lab_token_auth//认证条件
            });
        }

        /**
         * 清空条件查询
         */
        function mgr_reset_search_lab() {
            $("#mgr_lab_search_lname").val("");
            $("#mgr_lab_search_id").val("");
            $("#mgr_lab_search_type").val("");
            $('#mgr_lab_list').datagrid('load', {});
        }
    });
</script>
<div class="easyui-layout" data-options="fit : true">
    <div data-options="region:'north',split:false,collapsible:true" style="overflow: hidden">
        <form>

            <div style="float: left;margin-top: 5px;margin-bottom: 5px">
                &emsp;<b>实验室编号查询</b><input id="mgr_lab_search_id" class="easyui-validatebox">&emsp;
                &emsp;<b>实验室名查询</b><input id="mgr_lab_search_lname" class="easyui-validatebox">&emsp;
                &emsp;<b>实验室类型查询</b><input id="mgr_lab_search_type" class="easyui-validatebox">&emsp;
            </div>
            <div style="float: left;margin-top: 5px;margin-bottom: 5px">
                <input id="mgr_search_lab_btn" type="button" value="查询">
                <input id="mgr_reset_search_lab_btn" type="button" value="清空">&emsp;
            </div>
        </form>
    </div>
    <div id="mgr_lab_grid" data-options="region:'center',collapsible:false"
         style="padding:5px;background:#eee;overflow: hidden">
        <div id="mgr_lab_dialog" style="overflow: hidden"></div>
        <table id="mgr_lab_list"></table>
    </div>
</div>
