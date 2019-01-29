package lems.web.controller;

import org.apache.commons.codec.binary.Base64;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.kehao.lems.utils.LEMSResult;
import org.kehao.lems.web.controller.user.UserController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.fasterxml.jackson.databind.ObjectMapper;

import junit.framework.Assert;

@SuppressWarnings("deprecation")
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class TestUserController {
	@Autowired//注入要测试的Controller
	private UserController controller;
	//发送测试请求
	private MockMvc mockMvc;
	@Before
	public void init(){
		mockMvc=MockMvcBuilders.standaloneSetup(controller).build();
	}
	@After
	public void destroy(){
		
	}

    /**
     * 测试明文登录方法
     * @throws Exception
     */
    @Test
	public void userControllerLogin() throws Exception{		
		//发送执行一个HTTP请求
		RequestBuilder request=MockMvcRequestBuilders
		.post("/user/getuserinfo.do")
		.param("id", "9999");//传数据
		
		MvcResult result=mockMvc.perform(request)
		.andDo(MockMvcResultHandlers.print())//将请求头和响应头打印
		.andExpect(MockMvcResultMatchers.status().isOk())//期望返回状态码200
		.andReturn();//用来返回结果
		
		//提取响应中的json字符串
		String jsonStr=result.getResponse().getContentAsString();
		System.out.println("----------------------------"+'\n'+jsonStr+'\n'+"----------------------------");
		//将json字符串转成java对象
		ObjectMapper mapper=new ObjectMapper();
		LEMSResult lemsResult=mapper.readValue(jsonStr, LEMSResult.class);
		//断言
		Assert.assertEquals(0, lemsResult.getStatus());
	}

	/**
	 * 测试请求头用户登录方法
	 * @throws Exception
	 */
	@Test
    public void testAuthorLogin() throws Exception{
        String msg = "admin" + ":" + "123456";
        String base_64_msg= Base64.encodeBase64String(msg.getBytes());
        String authorization="Basic "+base_64_msg;

        //发送执行一个HTTP请求
        RequestBuilder request=MockMvcRequestBuilders
                .post("/user/login.do")
                .header("Authorization_login", authorization);//使用header传数据
        MvcResult result=mockMvc.perform(request)
                .andDo(MockMvcResultHandlers.print())//将请求头和响应头打印
                .andExpect(MockMvcResultMatchers.status().isOk())//期望返回状态码200
                .andReturn();//用来返回结果
        //提取响应中的json字符串
        String jsonStr=result.getResponse().getContentAsString();
        System.out.println(jsonStr);
        //将json字符串转成java对象
        ObjectMapper mapper=new ObjectMapper();
        LEMSResult noteResult=mapper.readValue(jsonStr, LEMSResult.class);
        //断言
        Assert.assertEquals(0, noteResult.getStatus());
    }
    @Test
    public void testAuthorAdd() throws Exception{
	    String uname="admin";
	    String passwd="123456";
	    String trueName="admin";
	    String email="admin@lems.com";
	    String masterid="9999";
        String msg = uname + ":" + passwd + ":"+trueName+ ":" + email+":"+masterid;
        String base_64_msg= Base64.encodeBase64String(msg.getBytes());
        String authorization="Basic "+base_64_msg;

        //发送执行一个HTTP请求
        RequestBuilder request=MockMvcRequestBuilders
                .post("/user/useradd.do")
                .header("Authorization_adduser", authorization);//使用header传数据
        MvcResult result=mockMvc.perform(request)
                .andDo(MockMvcResultHandlers.print())//将请求头和响应头打印
                .andExpect(MockMvcResultMatchers.status().isOk())//期望返回状态码200
                .andReturn();//用来返回结果
        //提取响应中的json字符串
        String jsonStr=result.getResponse().getContentAsString();
        System.out.println(jsonStr);
        //将json字符串转成java对象
        ObjectMapper mapper=new ObjectMapper();
        LEMSResult noteResult=mapper.readValue(jsonStr, LEMSResult.class);
        //断言
        Assert.assertEquals(0, noteResult.getStatus());
    }
	/**
	 * 测试明文登录方法
	 * @throws Exception
	 */
	@Test
	public void getUserList() throws Exception{
		//发送执行一个HTTP请求
		RequestBuilder request=MockMvcRequestBuilders
				.post("/user/user_list.do")
				.param("page","1")//传数据
				.param("rows","5")
                .param("uname","k")
				.param("sort","uname")
                .param("order","desc")
                .param("rname","管")
                .param("tureName","k");


		MvcResult result=mockMvc.perform(request)
				.andDo(MockMvcResultHandlers.print())//将请求头和响应头打印
				.andExpect(MockMvcResultMatchers.status().isOk())//期望返回状态码200
				.andReturn();//用来返回结果

		//提取响应中的json字符串
		String jsonStr=result.getResponse().getContentAsString();
		System.out.println("----------------------------"+'\n'+jsonStr+'\n'+"----------------------------");
		//将json字符串转成java对象
        System.err.println(jsonStr);
    }
}
