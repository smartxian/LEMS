<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
    $(function () {
        var list_lab_uid_auth = getCookie("uid");
        var list_lab_token_auth = getCookie("token");
        if(list_lab_uid_auth==null||list_lab_token_auth==null){
            $.messager.alert('警告', "530,您没有登录");
            setTimeout(function () {
                window.location.reload();
            }, 3000);
            return;
        }
        $('#list_lab_list').datagrid({
            url: './lab/lab_list.do',
            queryParams: {//认证条件
                auth_uid: list_lab_uid_auth,
                auth_token: list_lab_token_auth
            },
            pagination: true,
            fit: true,
            fitColumns: true,
            singleSelect:true,
            idField: 'lid',
            pageSize: 5,
            pageList: [5, 10, 15, 20],
            sortName: 'lname',
            sortOrder: 'asc',
            columns: [[
                {field:'ck',checkbox:"true"},
                {field: 'id', title: '实验室编号', width: 100, sortable: true},
                {field: 'lname', title: '实验室名称', width: 100, sortable: true},
                {field: 'type', title: '实验室类型', width: 100, sortable: true},
                {field: 'lsize', title: '学生容量(人)', width: 100},
                {field: 'equcount', title: '设备容量(台)', width: 100},
                {field: 'lab_uname', title: '实验室负责人', width: 100,sortable: true},
                {
                    field: 'status',
                    title: '状态',
                    width: 100,
                    formatter: function (status, rec, index) {
                        if (status == 0) {
                            return '可用';
                        }
                        if (status == 2) {
                            return '已预约';
                        }
                    },
                    sortable: true,
                    fixed: true
                },
                {field: 'remark', title: '备注', width: 100}
            ]],
            onLoadSuccess:function (result) {
                if (result.status!=0){
                    $.messager.alert('警告', result.message);
                    setTimeout(function () {
                        window.location.reload();
                    }, 3000);
                }
            },
            toolbar:['-',{
                text:'增加',
                iconCls:'icon-edit',
                handler:function(){
                    $("#list_lab_dialog").dialog({
                        title: '实验室添加',
                        width: 650,
                        height: 480,
                        href: './lab/add_lab.jsp',
                        modal: true,
                        onClose: function () {
                            $('#list_lab_list').datagrid('load',{
                                auth_uid: list_lab_uid_auth,//认证条件
                                auth_token: list_lab_token_auth//认证条件
                            });
                        }
                    });
                }
            },'-',{
                text:'删除',
                iconCls:'icon-remove',
                handler:function(){
                    list_del_lab();
                    $('#list_lab_list').datagrid('load',{
                        auth_uid: list_lab_uid_auth,//认证条件
                        auth_token: list_lab_token_auth//认证条件
                    });
                }
            }]
        });

        $("#list_search_lab_btn").click(list_search_lab);//绑定查询事件
        $("#list_reset_search_lab_btn").click(list_reset_search_lab);

        /**
         * 删除实验室
         */
        function list_del_lab(){
            var del_lablist=$('#list_lab_list').datagrid('getSelections');
            var del_list='';
            for(var i=0;i<del_lablist.length;i++){
                var selected=del_lablist[i];
                del_list+=selected['lid']+' ';
            }
            del_list.trim();
            $.ajax({
                url: "./lab/labdel.do",
                type: "post",
                data:{
                    "delList":del_list,
                    auth_uid: list_lab_uid_auth,//认证条件
                    auth_token: list_lab_token_auth//认证条件
                },
                dataType: "json",
                success: function (result) {
                    if (result.status == 0) {
                        $.messager.alert('提示', result.message+"，已删除"+result.data+"条数据");
                    }
                    if (result.status != 0) {
                        $.messager.alert('警告', result.message);
                    }
                },
                error: function () {
                    $.messager.alert('警告', "删除实验室异常");
                },
                async: true
            });
        }

        /**
         * 条件查询
         */
        function list_search_lab() {
            var list_lname = $("#list_search_lname").val().trim();
            var list_id = $("#list_search_id").val().trim();
            var list_type = $("#list_search_type").val().trim();
            list_lname=(list_lname==""?undefined:list_lname);
            list_id=(list_id==""?undefined:list_id);
            list_type=(list_type==""?undefined:list_type);
            $('#list_lab_list').datagrid('load', {
                lname: list_lname,
                id:list_id,
                type: list_type,
                auth_uid: list_lab_uid_auth,//认证条件
                auth_token: list_lab_token_auth//认证条件
            });
        }

        /**
         * 清空条件查询
         */
        function list_reset_search_lab() {
            $("#list_search_lname").val("");
            $("#list_search_id").val("");
            $("#list_search_type").val("");
            $('#list_lab_list').datagrid('load',{
                auth_uid: list_lab_uid_auth,//认证条件
                auth_token: list_lab_token_auth//认证条件
            });
        }
    });
</script>
<div class="easyui-layout" data-options="fit : true">
    <div data-options="region:'north',split:false,collapsible:true" style="overflow: hidden">
        <form>

            <div style="float: left;margin-top: 5px;margin-bottom: 5px" >
                &emsp;<b>实验室编号查询</b><input id="list_search_id" class="easyui-validatebox">&emsp;
                &emsp;<b>实验室名查询</b><input id="list_search_lname" class="easyui-validatebox">&emsp;
                &emsp;<b>实验室类型查询</b><input id="list_search_type" class="easyui-validatebox">&emsp;
            </div>
            <div style="float: left;margin-top: 5px;margin-bottom: 5px">
                <input id="list_search_lab_btn" type="button" value="查询">
                <input id="list_reset_search_lab_btn" type="button" value="清空">&emsp;
            </div>
        </form>
    </div>
    <div id="list_lab_grid" data-options="region:'center',collapsible:false" style="padding:5px;background:#eee;overflow: hidden">
        <div id="list_lab_dialog" style="overflow: hidden">
            <%--用于实现datagrid弹出窗口--%>
        </div>
        <table id="list_lab_list"></table>
    </div>
</div>
