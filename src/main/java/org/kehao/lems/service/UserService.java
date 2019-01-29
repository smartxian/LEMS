package org.kehao.lems.service;

import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.List;

import org.kehao.lems.entity.User;
import org.kehao.lems.entity.extend.UserEx;
import org.kehao.lems.utils.LEMSResult;

/**
 * Created by kehao on 2017/4/20.
 */
public interface UserService {
    /**
     * 通过用户id获取用户信息
     * @param uid
     * @return
     */
    LEMSResult getUserByUid(String uid);

    /**
     * 通过用户名获取用户信息
     * @param name
     * @return
     */
    LEMSResult getUserByName(String name);

    /**
     * 登录检查方法
     * @param auther
     * @return
     * @throws UnsupportedEncodingException
     */
    LEMSResult checkLogin(String auther)throws UnsupportedEncodingException;

    /**
     * 添加用户方法
     * @param auther
     * @return
     */
    LEMSResult userAdd(String auther)throws UnsupportedEncodingException;

    /**
     * 校验用户名是否存在
     * @param uname
     * @return
     */
    LEMSResult useraddValidation(String uname);

    /**
     * 修改用户信息
     * @param user
     * @return
     */
    LEMSResult modfifyUserInfo(User user);

    /**
     * 发送验证邮件
     * @return
     */
    LEMSResult sendValiCode(String uname);

    /**
     * 校验验证码
     * @param reqCode
     * @return
     */
    LEMSResult valiCodeValidation(String uname,String reqCode);

    /**
     * 重置用户密码，重置密码与修改密码共用
     * @param auther
     * @return
     * @throws UnsupportedEncodingException
     */
    LEMSResult modifyUserPasswd(String auther)throws UnsupportedEncodingException;

    /**
     * 查询用户，搜索功能
     *
     * @param page
     * @param pageSize
     * @param userEx 搜索条件
     * @return
     */
    LEMSResult getUser(Integer page, Integer pageSize, String order, String sort, UserEx userEx);

    /**
     * 查询用户，搜索功能,搜索到的用户数量
     * @param userEx
     * @return
     */
    Long getUserCount(UserEx userEx) ;

    /**
     * 批量禁用用户
     * @param delList
     * @return
     */
    LEMSResult userDel (List<String> delList);


    /**
     * 获取所有用户，装载下拉列表使用
     * @return
     */
    LEMSResult getAllUser();
}
