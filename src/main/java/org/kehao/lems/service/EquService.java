package org.kehao.lems.service;

import org.kehao.lems.entity.EquBreak;
import org.kehao.lems.entity.EquLab;
import org.kehao.lems.entity.EquSchedule;
import org.kehao.lems.entity.Equipment;
import org.kehao.lems.entity.extend.EquBreakEx;
import org.kehao.lems.entity.extend.EquipmentEx;
import org.kehao.lems.utils.LEMSResult;

import java.util.List;

/**
 * Created by hao on 2017/04/27.
 */
public interface EquService {
    /**
     * 添加采购设备，设备表部分
     *
     * @param equipment
     * @return
     */
    LEMSResult equAdd(Equipment equipment);
//    LEMSResult equDel(String eid);

    /**
     * 获得条件查询的记录
     *
     * @param page
     * @param rows
     * @param order
     * @param sort
     * @param equipmentEx
     * @return
     */
    LEMSResult equGet(Integer page, Integer rows, String order, String sort, EquipmentEx equipmentEx);

    /**
     * 获得条件查询的记录总数
     *
     * @param equipmentEx
     * @return
     */
    Long equGetCount(EquipmentEx equipmentEx);

    /**
     * 批量删除设备
     *
     * @param delList
     * @return
     */
    LEMSResult equDel(List<String> delList);

    /**
     * 转移设备
     *
     * @param equLab
     * @return
     */
    LEMSResult moveEqu(EquLab equLab);

    /**
     * 设备报修
     *
     * @param equBreak
     * @return
     */
    LEMSResult breakEqu(EquBreak equBreak);

    /**
     * 获取故障设备列表
     *
     * @param page
     * @param rows
     * @param order
     * @param sort
     * @param equBreakEx
     * @return
     */
    LEMSResult labGetBreak(Integer page, Integer rows, String order, String sort, EquBreakEx equBreakEx);

    /**
     * 获取故障设备数量
     *
     * @param equBreakEx
     * @return
     */
    Long labGetBreakCount(EquBreakEx equBreakEx);

    /**
     * 修复设备
     * @param bid
     * @param eid
     * @return
     */
    LEMSResult fixEqu(String bid,String eid);

    /**
     * 删除已修复的记录
     * @param bid
     * @return
     */
    LEMSResult fixEquDel(String bid);

    /**
     * 获取可预约设备数量
     * @param equipmentEx
     * @return
     */
    Long enOrderEquCount(EquipmentEx equipmentEx);

    /**
     * 获取可预约设备列表
     * @param page
     * @param pageSize
     * @param order
     * @param sort
     * @param equipmentEx
     * @return
     */
    LEMSResult enOrderEqu(Integer page, Integer pageSize, String order, String sort, EquipmentEx equipmentEx);

    /**
     * 预约设备
     * @param equSchedule
     * @return
     */
    LEMSResult orderEqu(EquSchedule equSchedule);
}
