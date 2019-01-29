<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
    $(function () {
        var add_user_uid_auth = getCookie("uid");
        var add_user_token_auth = getCookie("token");
        if(add_user_uid_auth==null||add_user_token_auth==null){
            $.messager.alert('警告', "530,您没有登录");
            setTimeout(function () {
                window.location.reload();
            }, 3000);
            return;
        }
        $("#add_user_btn").click(add_user);//添加用户按钮事件绑定
        $("#adduser_reset_btn").click(adduser_reset);

        $("#adduser_namebox").blur(validation_adduser);
        $("#adduser_namebox").focus(function () {
            $("#adduser_namebox_msg").text("");
        });
        //暂时不启用

        //动态装载下来菜单
        $.ajax({
            url: './role/get_all_role.do',
            dataType: 'json',
            data:{
                "auth_uid": add_user_uid_auth,
                "auth_token": add_user_token_auth
            },
            success: function (result) {
                var data = result.data;
                var dataList, rid, rname;
                dataList = [];
                for(var i=0;i<data.length;i++){
                    rid = data[i].rid;
                    rname = data[i].rname;
                    dataList.push({"id": rid, "text": rname});
                }
                $("#adduser_rolebox").combobox("loadData", dataList);
            },
            error: function () {
                $.messager.alert('警告', "获取角色异常");
            },
            async: true
        });

        /**
         * 注册页面回车键事件绑定
         */
        $("#adduser_emailbox").keydown(function (event) {
            var keyCode = event.keyCode;
            if (keyCode == 13) {
                add_user();
            }
        });
        //验证用户名是否被占用
        function validation_adduser() {
            var adduser_uname = $("#adduser_namebox").val();
            $.ajax({
                url: "./user/useradd_validation.do",
                type: "post",
                data: {
                    "uname": adduser_uname,
                    "auth_uid": add_user_uid_auth,
                    "auth_token": add_user_token_auth
                },
                dataType: "json",
                success: function (result) {
                    if (result.status != 0) {
                        $("#adduser_namebox_msg").text(result.message);
//                        $.messager.alert('警告', result.message);
                    }
                },
                error: function () {
                    $.messager.alert('警告', "校验用户名异常");
                },
                async: true
            });
        }

        //用户添加
        function add_user() {
            var adduser_uid = getCookie("uid");
            if (adduser_uid == null) {
                $.messager.alert('警告', "非法操作");//masterId不能为空
            }

            var adduser_uname = $("#adduser_namebox").val();
            var adduser_passwd = $("#adduser_passbox").val();
            var adduser_trueName = $("#adduser_truenamebox").val();
            var adduser_email = $("#adduser_emailbox").val();
            var adduser_role=$("#adduser_rolebox").combobox('getValue');

            var adduser_msg = adduser_uname + ":" + adduser_passwd + ":" + adduser_trueName + ":" + adduser_email + ":" + adduser_uid+ ":" + adduser_role;
            var base64_adduser_msg = Base64.encode(adduser_msg);

            $.ajax({
                url: "./user/useradd.do",
                type: "post",
                data:{
                    "auth_uid": add_user_uid_auth,
                    "auth_token": add_user_token_auth
                },
                dataType: "json",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader("Authorization_adduser", "Basic " + base64_adduser_msg);
                },
                success: function (result) {
                    if (result.status == 0) {
                        $.messager.alert('提示', result.message);
                        adduser_reset();
                    }
                    if (result.status != 0) {
                        $.messager.alert('警告', result.message);
                    }
                },
                error: function () {
                    $.messager.alert('警告', "添加用户异常");
                },
                async: true
            });
        }

        function adduser_reset() {
            $("#adduser_namebox").val("");
            $("#adduser_passbox").val("");
            $("#adduser_truenamebox").val("");
            $("#adduser_emailbox").val("");
        }
    });

</script>
<form method="post">
    <table class="table table-hover table-condensed" style="width: 500px;margin: auto">
        <h3 style="text-align: center">添加用户</h3>
        <hr>
        <tr>
            <th>登录名</th>
            <td>
                <input id="adduser_namebox" type="text" placeholder="请输入登录名" class="easyui-validatebox"
                       data-options="required:true">
            </td>
            <td style="width:130px;margin-left: 80px">
                <span style="color:red;margin-left: 10px" id="adduser_namebox_msg"></span>
            </td>
        </tr>
        <tr>
            <th>密码</th>
            <td>
                <input id="adduser_passbox" type="password" placeholder="请输入密码" class="easyui-validatebox"
                       data-options="required:true">
            </td>
            <td></td>
        </tr>
        <tr>
            <th>真实姓名</th>
            <td>
                <input id="adduser_truenamebox" type="text" placeholder="请输入真实姓名" class="easyui-validatebox"
                       data-options="required:true">
            </td>
            <td></td>
        </tr>
        <tr>
            <th>邮箱</th>
            <td>
                <input id="adduser_emailbox" type="text" placeholder="请输入邮箱" class="easyui-validatebox"
                       data-options="required:true">
            </td>
            <td></td>
        </tr>
        <tr>
            <th>角色</th>
            <td>
                <select id="adduser_rolebox" class="easyui-combobox easyui-validatebox" placeholder="请选择角色"
                        data-options="valueField:'id', textField:'text',panelHeight:'auto'"></select>
            </td>
            <td></td>
        </tr>
        <tr>
            <td colspan="2">
                <div class="dialog-button">
                    <a id="adduser_reset_btn" class="l-btn">
                                    <span class="l-btn-left">
                                        <span class="l-btn-text">清空</span>
                                    </span>
                    </a>
                    <a id="add_user_btn" class="l-btn">
                                    <span class="l-btn-left" style="color:#ffffff;background-color:#0e90d2">
                                        <span class="l-btn-text">添加</span>
                                    </span>
                    </a>
                </div>
            </td>
        </tr>
    </table>
</form>