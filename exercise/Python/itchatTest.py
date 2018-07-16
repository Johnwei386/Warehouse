#!/usr/bin/env python
# -*- coding:utf-8 -*-

"""
itchat开源接口实现，微信撤回消息可查看
"""
import os
import re
import shutil
import time
import itchat
from itchat.content import *

# 说明： 可以撤回的有文本文字、语音、视频、图片、位置、名片、分享和附件
msg_dict = {}

# 文件存储临时目录
rev_tmp_dir = "/tmp/RevDir/"
if not os.path.exists(rev_tmp_dir): os.mkdir(rev_tmp_dir)

# 表情有一个问题 | 接受信息和接受note的msg_id不一致
face_bug = None

@itchat.msg_register([TEXT, PICTURE, MAP, CARD, SHARING, RECORDING, ATTACHMENT, VIDEO])
def handler_receive_msg(msg):
    global face_bug
    # 获取的是本地时间戳并格式化本地时间戳 e: 2017-04-21 21:30:08
    msg_time_rec = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    # 消息ID
    msg_id = msg['MsgId']
    # 消息时间
    msg_time = msg['CreateTime']
    # 消息发送人昵称 | 这里也可以使用RemarkName备注，但是自己或者没有备注的人为None
    msg_from = (itchat.search_friends(userName=msg['FromUserName']))['NickName']
    # 消息内容
    msg_content = None
    # 分享的链接
    msg_share_url = None

    if msg['Type'] == 'Text' or msg['Type'] == 'Friends':
        msg_content = msg['Text']
    elif msg['Type'] == 'Recording' \
            or msg['Type'] == 'Attachment' \
            or msg['Type'] == 'Video' \
            or msg['Type'] == 'Picture':
        msg_content = r"" + msg['FileName']
        # 保存文件
        msg['Text'](rev_tmp_dir + msg['FileName'])
    elif msg['Type'] == 'Card':
        msg_content = msg['RecommendInfo']['NickName'] + r" 的名片"
    elif msg['Type'] == 'Map':
        x, y, location = re.search(
            "<location x=\"(.*?)\" y=\"(.*?)\".*label=\"(.*?)\".*", msg['OriContent']
        ).group(1, 2, 3)
        if location is None:
            msg_content = r"纬度->" + x.__str__() + " 经度->" + y.__str__()
        else:
            msg_content = r"" + location
    elif msg['Type'] == 'Sharing':
        msg_content = msg['Text']
        msg_share_url = msg['Url']
    face_bug = msg_content
    # 更新字典
    msg_dict.update(
        {
            msg_id:{
                "msg_from": msg_from, "msg_time": msg_time, "msg_time_rec": msg_time_rec,
                "msg_type": msg['Type'], "msg_content": msg_content, "msg_share_url": msg_share_url
            }
        }
    )

# 收到note通知类消息，判断是不是撤回并进行相应操作
@itchat.msg_register([NOTE])
def send_msg_helper(msg):
    global face_bug
    if re.search(r"\<\!\[CDATA\[.*撤回了一条消息\]\]\>", msg['Content']) is not None:
        # 获取消息的id
        old_msg_id = re.search("\<msgid\>(.*?)\<\/msgid\>", msg['Content']).group(1)
        old_msg = msg_dict.get(old_msg_id, {})
        if len(old_msg_id) < 11:
            itchat.send_file(rev_tmp_dir + face_bug, toUserName="filehelper")
            os.remove(rev_tmp_dir + face_bug)
        else:
            msg_body = "告诉你一个秘密～" + "\n" \
                        + old_msg.get('msg_from') + " 撤回了 " + old_msg.get('msg_type') + " 消息" + "\n" \
                        + old_msg.get('msg_time_rec') + "\n" \
                        + "撤回了什么 " + "\n" \
                        + r"" + old_msg.get('msg_content')
            # 如果是分享，存在链接
            if old_msg['msg_type'] == "Sharing": msg_body += "\n就是这个链接 " + old_msg.get('msg_share_url')
            # 将撤回的消息发送到文件助手
            itchat.send(msg_body, toUserName='filehelper')
            # 有文件的话也要将文件发送回去
            if old_msg('msg_type') == "Picture" \
                    or old_msg('msg_type') == "Recording" \
                    or old_msg('msg_type') == "Video" \
                    or old_msg('msg_type') == "Attachment":
                file = "@file@%s" % (rev_tmp_dir + old_msg['msg_content'])
                itchat.send(msg=file, toUserName='filehelper')
                os.remove(rev_tmp_dir + old_msg['msg_content'])
            # 删除字典旧消息
            msg_dict.pop(old_msg_id)

if __name__ == '__main__':
    itchat.auto_login(hotReload=True, enableCmdQR=2)
    itchat.run